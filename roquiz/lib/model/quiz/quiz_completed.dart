import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';
import 'package:roquiz/model/utils/grade.dart';

class QuizCompleted extends Quiz {
  /// Bumped whenever the persisted JSON shape changes. It's written into each
  /// entry and into the export envelope; [fromJson] doesn't read it (it parses
  /// defensively and ignores keys it no longer recognizes), but imports reject
  /// files declaring a *newer* version than this build understands. Version 2
  /// replaced the stored (total) `grade` with the written grade [writtenGrade]
  /// used at completion; the grade itself is now derived (see [grade]).
  static const int schemaVersion = 2;

  final DateTime timestamp;
  final int timeSpent;
  final int correctAnswers;

  /// The written-exam grade configured at the moment this quiz ended, or `null`
  /// if none was set. Kept for persistence/back-compat; display now uses the
  /// *current* global written grade via [gradeWith] (so entering it later
  /// updates past quizzes too), not this snapshot.
  final int? writtenGrade;

  QuizCompleted({
    required super.questions,
    required super.questionNum,
    required super.shuffleAnswers,
    required this.timestamp,
    required this.timeSpent,
    required this.correctAnswers,
    this.writtenGrade,
  });

  /// Rebuilds a completed quiz from a stored snapshot, preserving the exact
  /// questions, answer order and selections (see [Quiz.fromSnapshot]).
  QuizCompleted.fromSnapshot({
    required super.questions,
    required super.selectedAnswers,
    required this.timestamp,
    required this.timeSpent,
    required this.correctAnswers,
    this.writtenGrade,
  }) : super.fromSnapshot();

  /// Quiz-only grade (0–32), derived from the score.
  int get quizGrade => calculateQuizGrade(questions.length, correctAnswers);

  /// Grade for this attempt against a *live* [writtenGrade] (the current global
  /// setting): the estimated final grade when one is set, else the quiz-only
  /// grade. Used by the stats/history views so they reflect the written grade as
  /// soon as it's entered, instead of only on quizzes finished after it was set.
  double gradeWith(int? writtenGrade) => writtenGrade != null
      ? calculateTotalGrade(writtenGrade, quizGrade)
      : quizGrade.toDouble();

  Map<String, dynamic> toJson() => {
    "version": schemaVersion,
    "timestamp": timestamp.toIso8601String(),
    "timeSpent": timeSpent,
    "correctAnswers": correctAnswers,
    "writtenGrade": writtenGrade,
    "questions": questions.map((q) => q.toJson()).toList(),
    "selectedAnswers": selectedAnswers,
  };

  factory QuizCompleted.fromJson(Map<String, dynamic> json) {
    // A legacy total `grade` key (schema v1) is intentionally ignored: the grade
    // is now derived from the score and the snapshotted written grade.
    return QuizCompleted.fromSnapshot(
      questions: (json["questions"] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      selectedAnswers: (json["selectedAnswers"] as List).cast<int?>(),
      timestamp: DateTime.parse(json["timestamp"] as String),
      timeSpent: json["timeSpent"] as int,
      correctAnswers: json["correctAnswers"] as int,
      writtenGrade: json["writtenGrade"] as int?,
    );
  }
}
