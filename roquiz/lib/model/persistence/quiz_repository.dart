import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';

/// Local store for completed quizzes, backed by a Hive box.
///
/// The whole history is kept as a single JSON array under one key: the list is
/// small (capped at [maxHistory]) and on web Hive is backed by IndexedDB, so we
/// avoid both the rewrite cost mattering and the localStorage size ceiling.
/// Entries are kept newest-first and parsed defensively, so a single corrupt
/// record (e.g. left over from an older schema) never breaks the whole history.
class QuizRepository {
  static const String boxName = "quiz_history";
  static const String _entriesKey = "entries";

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
      debugPrint("QuizRepository: failed to decode history, ignoring it ($e)");
      return;
    }

    for (final entry in decoded) {
      try {
        quizList.add(QuizCompleted.fromJson(entry as Map<String, dynamic>));
      } catch (e) {
        debugPrint("QuizRepository: skipping malformed quiz entry ($e)");
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

  Future<void> clear() async {
    quizList.clear();
    await _persist();
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
