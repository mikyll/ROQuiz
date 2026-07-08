import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:roquiz/model/quiz/question_parser.dart';
import 'package:roquiz/model/quiz/question.dart';

/// Where the currently loaded questions file came from.
///
///   - [asset]: the bundled file shipped with this app version (the default and
///     the always-available fallback);
///   - [remote]: a copy downloaded from the "cloud" (the ROQuiz GitHub repo);
///   - [custom]: a file loaded or edited by the user.
///
/// The source drives the remote-update policy: an [asset]/[remote] file may be
/// replaced with a newer official one, while a [custom] file is never overwritten
/// without the user's confirmation (see [peekRemoteUpdate]).
enum QuestionSource { asset, remote, custom }

/// The outcome of a side-effect-free remote-update check ([peekRemoteUpdate]):
/// the latest remote commit datetime and whether it is newer than what the
/// repository currently reflects.
class RemoteQuestionsInfo {
  /// Datetime of the latest remote commit that touched the questions file.
  final DateTime remoteDate;

  /// True when [remoteDate] is strictly newer than the currently loaded file
  /// (for a custom set, newer than the last official commit the user has seen).
  final bool isNewer;

  const RemoteQuestionsInfo({required this.remoteDate, required this.isNewer});
}

/// Outcome of loading the saved copy from the box — distinguishes a fresh
/// install (nothing saved, a normal asset fallback) from a corrupt saved copy
/// (an asset fallback that must surface an error to the user).
enum _BoxLoad { ok, absent, corrupt }

// About the current file we persist: its raw content and format (so it
// round-trips exactly), its [QuestionSource], the datetime of the loaded file
// ([_currentFileDate] — the remote commit datetime for a downloaded file), and
// the newest remote commit datetime we have ever observed ([_lastKnownRemoteDate],
// tracked independently of the current source so the custom-file update check is
// well-posed: a custom file has no remote-comparable date of its own).
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
  static const String _sourceKey = "source";

  /// Datetime of the loaded file (reuses the legacy `lastUpdate` key so existing
  /// boxes migrate without touching this value — it already held the remote
  /// commit datetime for downloaded files).
  static const String _currentFileDateKey = "lastUpdate";
  static const String _lastKnownRemoteDateKey = "lastKnownRemoteDate";

  /// Legacy key: the old boolean "is this a custom file". Read only to migrate
  /// pre-[QuestionSource] boxes.
  static const String _legacyCustomKey = "custom";

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
  QuestionSource _source = QuestionSource.asset;
  DateTime _currentFileDate = _epoch;
  DateTime _lastKnownRemoteDate = _epoch;

  String? _lastLoadError;

  Box? _box;

  /// HTTP client for the remote calls. Injectable so tests can drive the
  /// update logic without real network access.
  final http.Client _client;

  QuestionRepository({http.Client? client})
    : _client = client ?? http.Client();

  /// Provenance of the currently loaded questions file.
  QuestionSource get source => _source;

  /// Datetime of the currently loaded questions file (remote commit datetime for
  /// a downloaded file; [_epoch] for the untouched bundled asset).
  DateTime get lastQuestionUpdate => _currentFileDate;

  /// Whether the current file was provided/edited by the user (and so must not
  /// be overwritten without asking — see [peekRemoteUpdate]).
  bool get isCustom => _source == QuestionSource.custom;

  /// A user-facing error from the last [init], or null. Set when the saved copy
  /// was present but unreadable and the bundled asset was loaded instead.
  String? get lastLoadError => _lastLoadError;

  /// Raw-content URL of the remote questions file.
  String get remoteRawUrl =>
      "https://raw.githubusercontent.com/$remoteRepository/$remoteBranch/$remotePath";

  /// Opens the store and loads the questions: the saved copy when present,
  /// otherwise the bundled asset (which must always load, so the app is usable
  /// even offline / on first run / when the saved copy is unreadable). When the
  /// saved copy is present but unreadable, the asset is loaded and [lastLoadError]
  /// is set so the caller can surface a recoverable error.
  ///
  /// This never touches the network: the remote-update check is a separate,
  /// caller-driven step (see [peekRemoteUpdate]) so startup can't be blocked.
  Future<void> init() async {
    _box = await Hive.openBox(boxName);
    _lastLoadError = null;

    switch (await _loadFromBox()) {
      case _BoxLoad.ok:
        break;
      case _BoxLoad.absent:
        // Fresh install (or the box was cleared): load the asset silently.
        await _loadAssetInMemory();
        break;
      case _BoxLoad.corrupt:
        // A saved copy exists but can't be parsed. Fall back to the asset but
        // leave the corrupt blob untouched (it may be a recoverable custom set)
        // and surface an error — the next successful save/update replaces it.
        await _loadAssetInMemory();
        _lastLoadError =
            "Le domande salvate non sono leggibili: è stato ripristinato "
            "il set di domande integrato.";
        break;
    }
  }

  /// Loads the saved questions from the Hive box. Returns [_BoxLoad.absent] when
  /// there is no saved copy (a normal fresh install) and [_BoxLoad.corrupt] when
  /// a saved copy is present but can't be parsed — the caller distinguishes the
  /// two to decide whether to surface an error. In either non-ok case the
  /// in-memory state is left untouched for the caller to replace with the asset.
  Future<_BoxLoad> _loadFromBox() async {
    final box = _box;
    if (box == null) {
      return _BoxLoad.absent;
    }

    final content = box.get(_contentKey);
    if (content is! String) {
      return _BoxLoad.absent;
    }

    final List<Question> parsed;
    try {
      parsed = _parse(content, _formatFromName(box.get(_formatKey) as String?));
    } catch (e) {
      debugPrint(
        "QuestionRepository: saved questions are corrupt, "
        "falling back to asset ($e)",
      );
      return _BoxLoad.corrupt;
    }

    // Content parsed: commit it, then read the metadata with safe fallbacks (a
    // malformed date/source must not discard otherwise-valid questions).
    questions = parsed;
    _source = _readSource(box);
    _currentFileDate = _readDate(box.get(_currentFileDateKey)) ?? _epoch;
    _lastKnownRemoteDate =
        _readDate(box.get(_lastKnownRemoteDateKey)) ??
        // No stored value (e.g. a migrated box): a downloaded file's own commit
        // datetime is the newest remote we can prove we have seen.
        (_source == QuestionSource.remote ? _currentFileDate : _epoch);
    return _BoxLoad.ok;
  }

  /// Reads the persisted [QuestionSource], migrating pre-enum boxes from the old
  /// boolean `custom` flag (a stored non-epoch date implies a downloaded remote).
  QuestionSource _readSource(Box box) {
    final name = box.get(_sourceKey);
    if (name is String) {
      try {
        return QuestionSource.values.byName(name);
      } catch (_) {
        // Unknown value: fall through to the legacy migration.
      }
    }
    if (box.get(_legacyCustomKey) == true) {
      return QuestionSource.custom;
    }
    final legacyDate = _readDate(box.get(_currentFileDateKey));
    if (legacyDate != null && legacyDate.isAfter(_epoch)) {
      return QuestionSource.remote;
    }
    return QuestionSource.asset;
  }

  DateTime? _readDate(Object? raw) {
    if (raw is! String) {
      return null;
    }
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }

  /// Loads the bundled asset into the working state (in memory only — does not
  /// persist, so a corrupt saved copy is not destroyed). Used as the fallback.
  Future<void> _loadAssetInMemory({String path = assetPath}) async {
    questions = await loadFromAsset(path: path);
    _source = QuestionSource.asset;
    _currentFileDate = _epoch;
  }

  /// Parses the bundled asset. Always available; used as the fallback source.
  Future<List<Question>> loadFromAsset({String path = assetPath}) async {
    final content = await rootBundle.loadString(path);
    return _parse(content, _formatFromPath(path));
  }

  /// Replaces the current questions with the bundled asset and persists it as an
  /// [QuestionSource.asset] copy, resetting the file datetime to [_epoch] so a
  /// later update check re-downloads any newer remote file. (User feature:
  /// "restore from assets".)
  Future<void> restoreFromAsset({String path = assetPath}) async {
    final content = await rootBundle.loadString(path);
    final format = _formatFromPath(path);
    questions = _parse(content, format);
    await _saveContent(
      content,
      format,
      source: QuestionSource.asset,
      currentFileDate: _epoch,
    );
  }

  /// Loads questions from raw [content] (e.g. a user-picked file) and persists
  /// it as a [QuestionSource.custom] copy — so the remote update check leaves it
  /// alone. The [format] is inferred when not given; throws [FormatException]
  /// when the content can't be recognized or parsed.
  Future<void> loadFromContent(String content, {QuestionFormat? format}) async {
    final resolved = format ?? inferQuestionFormat(content);
    if (resolved == null) {
      throw const FormatException("Unrecognized questions file format");
    }
    questions = _parse(content, resolved);
    await _saveContent(
      content,
      resolved,
      source: QuestionSource.custom,
      currentFileDate: DateTime.now().toUtc(),
    );
  }

  /// Replaces the working [questions] with [edited] and persists them as a
  /// custom copy. Use this to save the result of an in-app editing session.
  Future<void> saveQuestions(List<Question> edited) async {
    questions = edited;
    await save();
  }

  /// Serializes the current [questions] to YAML for export to a file. Mirrors
  /// the on-disk format used by [save] but returns the content instead of
  /// persisting it. Re-importable via [loadFromContent].
  String exportToYaml() => questions.map((q) => q.toYaml()).join("\n");

  /// Serializes the current [questions] to YAML and persists them as a
  /// [QuestionSource.custom] copy. Use this after in-app edits to save the
  /// working question set.
  Future<void> save() async {
    final content = questions.map((q) => q.toYaml()).join("\n");
    await _saveContent(
      content,
      QuestionFormat.yaml,
      source: QuestionSource.custom,
      currentFileDate: DateTime.now().toUtc(),
    );
  }

  /// Checks the remote for a newer questions file WITHOUT downloading or mutating
  /// any state — the caller decides what to do with the result (the interactive
  /// flow confirms with the user before replacing anything). "Newer" is measured
  /// against the last official commit the user has seen for a custom set (whose
  /// own file datetime is unrelated to the remote) and against the loaded file's
  /// datetime otherwise. Network/parse errors propagate to the caller.
  ///
  /// Apply the update with [downloadFromRemote] (which switches to a
  /// [QuestionSource.remote] copy, discarding any custom set); for a custom set,
  /// decline it with [markRemoteSeen] so the same commit isn't offered again.
  Future<RemoteQuestionsInfo> peekRemoteUpdate() async {
    final remoteDate = await getLatestQuestionsFileDatetime();
    final reference = _source == QuestionSource.custom
        ? _lastKnownRemoteDate
        : _currentFileDate;
    return RemoteQuestionsInfo(
      remoteDate: remoteDate,
      isNewer: remoteDate.isAfter(reference),
    );
  }

  /// Records [date] as the newest official commit the user has been shown, so the
  /// custom-set update check won't flag it again (a still-newer commit later will
  /// flag anew). No-op when [date] isn't newer than the last one already seen.
  Future<void> markRemoteSeen(DateTime date) async {
    if (!date.isAfter(_lastKnownRemoteDate)) {
      return;
    }
    _lastKnownRemoteDate = date;
    await _box?.put(_lastKnownRemoteDateKey, date.toIso8601String());
  }

  /// Downloads the questions file from the remote, replaces the current
  /// questions and persists it as a [QuestionSource.remote] copy. [commitDate]
  /// should be the remote commit datetime (fetched separately to avoid a second
  /// API call); when omitted it is looked up.
  Future<void> downloadFromRemote({DateTime? commitDate}) async {
    final content = await _downloadRaw(remoteRawUrl);
    final format = inferQuestionFormat(content) ?? QuestionFormat.txt;
    final date = commitDate ?? await getLatestQuestionsFileDatetime();
    questions = _parse(content, format);
    await _saveContent(
      content,
      format,
      source: QuestionSource.remote,
      currentFileDate: date,
      // We now hold this remote commit, so it is the newest one we've seen.
      lastKnownRemoteDate: date,
    );
  }

  /// Fetches the datetime of the latest commit that touched the questions file
  /// on the remote repository, via the GitHub commits API.
  Future<DateTime> getLatestQuestionsFileDatetime({
    String repository = remoteRepository,
    String path = remotePath,
    String branch = remoteBranch,
  }) async {
    final response = await _client.get(
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
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw HttpException(
        "Failed to download questions file (${response.statusCode})",
      );
    }
    return utf8.decode(response.bodyBytes);
  }

  /// Persists [content] and its metadata to the box, updating in-memory state
  /// too. A no-op on the box side when [init] hasn't opened it yet (in-memory
  /// state is still updated). [lastKnownRemoteDate] defaults to the current
  /// value — only a downloaded remote file advances it.
  Future<void> _saveContent(
    String content,
    QuestionFormat format, {
    required QuestionSource source,
    required DateTime currentFileDate,
    DateTime? lastKnownRemoteDate,
  }) async {
    _source = source;
    _currentFileDate = currentFileDate;
    _lastKnownRemoteDate = lastKnownRemoteDate ?? _lastKnownRemoteDate;

    final box = _box;
    if (box == null) {
      return;
    }
    await box.put(_contentKey, content);
    await box.put(_formatKey, format.name);
    await box.put(_sourceKey, source.name);
    await box.put(_currentFileDateKey, _currentFileDate.toIso8601String());
    await box.put(
      _lastKnownRemoteDateKey,
      _lastKnownRemoteDate.toIso8601String(),
    );
    // Drop the legacy boolean flag so it can't shadow the new source key.
    await box.delete(_legacyCustomKey);
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
