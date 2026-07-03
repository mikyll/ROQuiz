import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:roquiz/cli/questions_parser.dart';
import 'package:roquiz/model/quiz/question.dart';

// The current question file can be one of:
//   - the bundled asset (the default shipped with this app version);
//   - a copy downloaded from the "cloud" (the ROQuiz GitHub repository);
//   - a custom file loaded/edited by the user.
//
// About the current file we persist:
//   - its raw content and format, so it round-trips exactly;
//   - whether it is custom (user-provided) — a custom file is never replaced by
//     the remote update check;
//   - the last-update datetime — for a non-custom file this is the remote
//     commit datetime, used to decide whether a newer version is available.
//
// The saved copy is kept in a Hive box (a single blob under one key), mirroring
// [CompletedQuizRepository]: it works on every platform including web (Hive is
// backed by IndexedDB there), avoiding the localStorage size ceiling. Loading
// the bundled asset must always succeed, so it is used as a fallback whenever
// there is no saved copy or the saved copy can't be read.
class QuestionRepository {
  static const String boxName = "question_repository";
  static const String _contentKey = "content";
  static const String _formatKey = "format";
  static const String _lastUpdateKey = "lastUpdate";
  static const String _customKey = "custom";

  /// Bundled questions file, always available as a fallback.
  static const String assetPath = "assets/questions.yaml";

  /// Canonical remote source of the questions file (GitHub).
  static const String remoteRepository = "mikyll/ROQuiz";
  static const String remoteBranch = "main";
  static const String remotePath = "Domande.txt";

  /// Sentinel "never updated" datetime: older than any real remote commit, so a
  /// fresh install (asset only) is always considered updatable.
  static final DateTime _epoch = DateTime.fromMillisecondsSinceEpoch(
    0,
    isUtc: true,
  );

  List<Question> questions = [];
  DateTime _lastQuestionUpdate = _epoch;
  bool _custom = false;

  Box? _box;

  /// Datetime of the currently loaded questions file (remote commit datetime for
  /// a downloaded file; [_epoch] for the untouched bundled asset).
  DateTime get lastQuestionUpdate => _lastQuestionUpdate;

  /// Whether the current file was provided/edited by the user (and so must not
  /// be overwritten by the remote update check).
  bool get isCustom => _custom;

  /// Raw-content URL of the remote questions file.
  String get remoteRawUrl =>
      "https://raw.githubusercontent.com/$remoteRepository/$remoteBranch/$remotePath";

  /// Opens the store and loads the questions: the saved copy when present,
  /// otherwise the bundled asset (which must always load, so the app is usable
  /// even offline / on first run / when the saved copy is unreadable).
  ///
  /// When [checkForUpdates] is set, after loading it checks the remote for a
  /// newer file and, if found, downloads it and updates the saved copy. Update
  /// failures (offline, API errors) are swallowed so startup can't be blocked.
  Future<void> init({bool checkForUpdates = false}) async {
    _box = await Hive.openBox(boxName);

    if (!await _loadFromBox()) {
      questions = await loadFromAsset();
      _lastQuestionUpdate = _epoch;
      _custom = false;
    }

    if (checkForUpdates) {
      try {
        await updateFromRemoteIfNewer();
      } catch (e) {
        debugPrint("QuestionRepository: update check failed ($e)");
      }
    }
  }

  /// Loads the saved questions from the Hive box. Returns false (leaving the
  /// current state untouched) when there is no saved copy or it can't be parsed,
  /// so the caller can fall back to the asset.
  Future<bool> _loadFromBox() async {
    final box = _box;
    if (box == null) {
      return false;
    }

    final content = box.get(_contentKey);
    if (content is! String) {
      return false;
    }

    try {
      final format = _formatFromName(box.get(_formatKey) as String?);
      questions = _parse(content, format);

      final rawDate = box.get(_lastUpdateKey);
      _lastQuestionUpdate = rawDate is String
          ? DateTime.parse(rawDate)
          : _epoch;
      _custom = box.get(_customKey) == true;
      return true;
    } catch (e) {
      debugPrint(
        "QuestionRepository: failed to load saved questions, "
        "falling back to asset ($e)",
      );
      return false;
    }
  }

  /// Parses the bundled asset. Always available; used as the fallback source.
  Future<List<Question>> loadFromAsset({String path = assetPath}) async {
    final content = await rootBundle.loadString(path);
    return _parse(content, _formatFromPath(path));
  }

  /// Replaces the current questions with the bundled asset and persists it as a
  /// non-custom copy, resetting the update datetime so a later update check can
  /// re-download a newer remote file. (User feature: "restore from assets".)
  Future<void> restoreFromAsset({String path = assetPath}) async {
    final content = await rootBundle.loadString(path);
    final format = _formatFromPath(path);
    questions = _parse(content, format);
    await _saveContent(content, format, custom: false, lastUpdate: _epoch);
  }

  /// Loads questions from raw [content] (e.g. a user-picked file) and persists
  /// it as a custom copy — so the remote update check leaves it alone. The
  /// [format] is inferred when not given; throws [FormatException] when the
  /// content can't be recognized or parsed.
  Future<void> loadFromContent(String content, {QuestionFormat? format}) async {
    final resolved = format ?? inferQuestionFormat(content);
    if (resolved == null) {
      throw const FormatException("Unrecognized questions file format");
    }
    questions = _parse(content, resolved);
    await _saveContent(
      content,
      resolved,
      custom: true,
      lastUpdate: DateTime.now().toUtc(),
    );
  }

  /// Replaces the working [questions] with [edited] and persists them as a
  /// custom copy. Use this to save the result of an in-app editing session.
  Future<void> saveQuestions(List<Question> edited) async {
    questions = edited;
    await save();
  }

  /// Serializes the current [questions] to YAML and persists them as a custom
  /// copy. Use this after in-app edits to save the working question set.
  Future<void> save() async {
    final content = questions.map((q) => q.toYaml()).join("\n");
    await _saveContent(
      content,
      QuestionFormat.yaml,
      custom: true,
      lastUpdate: DateTime.now().toUtc(),
    );
  }

  /// Checks the remote for a newer questions file and, when found, downloads and
  /// saves it. Returns true when an update was applied. A custom file is never
  /// replaced. Network/parse errors propagate to the caller.
  Future<bool> updateFromRemoteIfNewer() async {
    if (_custom) {
      return false;
    }

    final remoteDate = await getLatestQuestionsFileDatetime();

    // Only replace the saved copy when the remote commit is strictly newer.
    if (!remoteDate.isAfter(_lastQuestionUpdate)) {
      return false;
    }

    await downloadFromRemote(commitDate: remoteDate);
    return true;
  }

  /// Returns whether the remote holds a questions file newer than the current
  /// one, without downloading it. A custom file is never considered outdated.
  Future<bool> checkUpdates() async {
    if (_custom) {
      return false;
    }
    final remoteDate = await getLatestQuestionsFileDatetime();
    return remoteDate.isAfter(_lastQuestionUpdate);
  }

  /// Downloads the questions file from the remote, replaces the current
  /// questions and persists it as a non-custom copy. [commitDate] should be the
  /// remote commit datetime (fetched separately to avoid a second API call);
  /// when omitted it is looked up.
  Future<void> downloadFromRemote({DateTime? commitDate}) async {
    final content = await _downloadRaw(remoteRawUrl);
    final format = inferQuestionFormat(content) ?? QuestionFormat.txt;
    questions = _parse(content, format);
    await _saveContent(
      content,
      format,
      custom: false,
      lastUpdate: commitDate ?? await getLatestQuestionsFileDatetime(),
    );
  }

  /// Fetches the datetime of the latest commit that touched the questions file
  /// on the remote repository, via the GitHub commits API.
  Future<DateTime> getLatestQuestionsFileDatetime({
    String repository = remoteRepository,
    String path = remotePath,
    String branch = remoteBranch,
  }) async {
    final response = await http.get(
      Uri.parse(
        "https://api.github.com/repos/$repository/commits"
        "?path=$path&sha=$branch&page=1&per_page=1",
      ),
      headers: const {"Accept": "application/vnd.github+json"},
    );

    final dynamic json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = json is Map && json["message"] is String
          ? json["message"] as String
          : "GitHub API error (${response.statusCode})";
      throw HttpException(message);
    }

    if (json is! List || json.isEmpty) {
      throw const FormatException("No commits found for the questions file");
    }

    final dateString = json[0]["commit"]["committer"]["date"] as String;
    return DateTime.parse(dateString);
  }

  /// Downloads raw text from [url], decoding as UTF-8 so accented characters in
  /// the questions survive regardless of the response's declared charset.
  Future<String> _downloadRaw(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw HttpException(
        "Failed to download questions file (${response.statusCode})",
      );
    }
    return utf8.decode(response.bodyBytes);
  }

  /// Persists [content] and its metadata to the box, updating in-memory state
  /// too. A no-op on the box side when [init] hasn't opened it yet (in-memory
  /// state is still updated).
  Future<void> _saveContent(
    String content,
    QuestionFormat format, {
    required bool custom,
    DateTime? lastUpdate,
  }) async {
    _custom = custom;
    _lastQuestionUpdate = lastUpdate ?? _lastQuestionUpdate;

    final box = _box;
    if (box == null) {
      return;
    }
    await box.put(_contentKey, content);
    await box.put(_formatKey, format.name);
    await box.put(_lastUpdateKey, _lastQuestionUpdate.toIso8601String());
    await box.put(_customKey, custom);
  }

  List<Question> _parse(String content, QuestionFormat format) {
    switch (format) {
      case QuestionFormat.txt:
        return parseQuestionsFromTxt(content);
      case QuestionFormat.yaml:
        return parseQuestionsFromYaml(content);
    }
  }

  QuestionFormat _formatFromPath(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith(".yaml") || lower.endsWith(".yml")
        ? QuestionFormat.yaml
        : QuestionFormat.txt;
  }

  QuestionFormat _formatFromName(String? name) {
    if (name == null) {
      return QuestionFormat.yaml;
    }
    try {
      return QuestionFormat.values.byName(name);
    } catch (_) {
      return QuestionFormat.yaml;
    }
  }

  List<String> getTopics() {
    List<String> topics = [];

    for (Question q in questions) {
      String topic = q.topic!;

      if (!topics.contains(topic)) {
        topics.add(topic);
      }
    }
    return topics;
  }

  // Returns a map with questions grouped by topic
  Map<String, List<Question>> getGroupedQuestions() {
    Map<String, List<Question>> groupedQuestions = {};

    for (String topic in getTopics()) {
      groupedQuestions[topic] = [];
    }

    for (Question q in questions) {
      String topic = q.topic!;

      groupedQuestions[topic]!.add(q);
    }

    return groupedQuestions;
  }
}
