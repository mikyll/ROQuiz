import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';

/// Outcome of [CompletedQuizRepository.importFromJson]: how many imported quizzes were
/// actually added to the history, and how many were skipped because they
/// duplicate an existing completion (same timestamp) or could not be parsed.
class ImportResult {
  final int added;
  final int skippedDuplicates;
  final int skippedInvalid;

  const ImportResult({
    required this.added,
    required this.skippedDuplicates,
    required this.skippedInvalid,
  });
}

/// Local store for completed quizzes, backed by a Hive box.
///
/// The whole history is kept as a single JSON array under one key: the list is
/// small (capped at [maxHistory]) and on web Hive is backed by IndexedDB, so we
/// avoid both the rewrite cost mattering and the localStorage size ceiling.
/// Entries are kept newest-first and parsed defensively, so a single corrupt
/// record (e.g. left over from an older schema) never breaks the whole history.
class CompletedQuizRepository {
  static const String boxName = "quiz_history";
  static const String _entriesKey = "entries";

  /// Identifies a file produced by [exportToJson], so imports can reject
  /// unrelated JSON files instead of silently wiping the history.
  static const String exportType = "roquiz_history";

  /// Maximum number of completed quizzes retained; older ones are dropped.
  static const int maxHistory = 100;

  final List<QuizCompleted> quizList = [];

  Box? _box;

  Future<void> load() async {
    _box = await Hive.openBox(boxName);

    quizList.clear();
    final raw = _box!.get(_entriesKey);
    if (raw is! String) {
      return;
    }

    final List<dynamic> decoded;
    try {
      decoded = jsonDecode(raw) as List<dynamic>;
    } catch (e) {
      debugPrint(
        "CompletedQuizRepository: failed to decode history, ignoring it ($e)",
      );
      return;
    }

    for (final entry in decoded) {
      try {
        quizList.add(QuizCompleted.fromJson(entry as Map<String, dynamic>));
      } catch (e) {
        debugPrint(
          "CompletedQuizRepository: skipping malformed quiz entry ($e)",
        );
      }
    }

    quizList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> add(QuizCompleted quiz) async {
    quizList.insert(0, quiz);
    if (quizList.length > maxHistory) {
      quizList.removeRange(maxHistory, quizList.length);
    }
    await _persist();
  }

  Future<void> remove(QuizCompleted quiz) async {
    quizList.remove(quiz);
    await _persist();
  }

  /// Removes every quiz in [quizzes] in a single persisted operation.
  Future<void> removeAll(Iterable<QuizCompleted> quizzes) async {
    final Set<QuizCompleted> toRemove = quizzes.toSet();
    quizList.removeWhere(toRemove.contains);
    await _persist();
  }

  Future<void> clear() async {
    quizList.clear();
    await _persist();
  }

  /// Serializes a history into a self-describing JSON document suitable for
  /// sharing or backup. Exports [quizzes] when given (e.g. a user-selected
  /// subset), otherwise the whole history.
  String exportToJson({Iterable<QuizCompleted>? quizzes}) {
    return jsonEncode({
      "type": exportType,
      "version": QuizCompleted.schemaVersion,
      "exportedAt": DateTime.now().toIso8601String(),
      "quizzes": (quizzes ?? quizList).map((q) => q.toJson()).toList(),
    });
  }

  /// Imports the quizzes contained in [content] and returns an [ImportResult]
  /// breaking down how many were added versus skipped (duplicates / malformed).
  /// When [merge] is set, the imported quizzes are added to the existing history
  /// (deduplicated by timestamp); otherwise the current history is replaced.
  /// Throws [FormatException] when [content] is not a recognizable history
  /// export, or when it contains no valid quizzes. Malformed individual entries
  /// are skipped as long as at least one is valid.
  Future<ImportResult> importFromJson(
    String content, {
    bool merge = false,
  }) async {
    final dynamic decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic> || decoded["type"] != exportType) {
      throw const FormatException("Not a roquiz history file");
    }
    final dynamic rawQuizzes = decoded["quizzes"];
    if (rawQuizzes is! List) {
      throw const FormatException("History file has no quizzes");
    }

    final List<QuizCompleted> imported = [];
    for (final entry in rawQuizzes) {
      try {
        imported.add(QuizCompleted.fromJson(entry as Map<String, dynamic>));
      } catch (e) {
        debugPrint(
          "CompletedQuizRepository: skipping malformed imported quiz ($e)",
        );
      }
    }
    final int skippedInvalid = rawQuizzes.length - imported.length;

    // Bail out before mutating the history: a file whose entries are all
    // missing or malformed yields nothing to import. Without this, overwrite
    // mode would clear() then addAll([]) and silently wipe the history while
    // reporting success.
    if (imported.isEmpty) {
      throw const FormatException("History file has no valid quizzes");
    }

    // Deduplicate by timestamp: a completion is uniquely identified by when it
    // happened, so re-importing the same quiz is a no-op when merging. In merge
    // mode existing entries are seeded first so they win over imported dupes.
    final Set<String> seen = merge
        ? {for (final quiz in quizList) quiz.timestamp.toIso8601String()}
        : <String>{};
    final List<QuizCompleted> result = merge
        ? [...quizList]
        : <QuizCompleted>[];
    int added = 0;
    int skippedDuplicates = 0;
    for (final quiz in imported) {
      if (seen.add(quiz.timestamp.toIso8601String())) {
        result.add(quiz);
        added++;
      } else {
        skippedDuplicates++;
      }
    }

    result.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    quizList
      ..clear()
      ..addAll(result);
    if (quizList.length > maxHistory) {
      quizList.removeRange(maxHistory, quizList.length);
    }
    await _persist();
    return ImportResult(
      added: added,
      skippedDuplicates: skippedDuplicates,
      skippedInvalid: skippedInvalid,
    );
  }

  Future<void> _persist() async {
    final box = _box;
    if (box == null) {
      return;
    }
    final encoded = jsonEncode(quizList.map((q) => q.toJson()).toList());
    await box.put(_entriesKey, encoded);
  }
}
