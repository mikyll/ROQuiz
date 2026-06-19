import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';

class QuizCompleted extends Quiz {
  /// Bumped whenever the persisted JSON shape changes, so [fromJson] can migrate
  /// (or skip) older entries instead of crashing.
  static const int schemaVersion = 1;

  final DateTime timestamp;
  final int timeSpent;
  final int correctAnswers;
  final double grade;

  QuizCompleted({
    required super.questions,
    required super.questionNum,
    required super.shuffleAnswers,
    required this.timestamp,
    required this.timeSpent,
    required this.correctAnswers,
    required this.grade,
  });

  /// Rebuilds a completed quiz from a stored snapshot, preserving the exact
  /// questions, answer order and selections (see [Quiz.fromSnapshot]).
  QuizCompleted.fromSnapshot({
    required super.questions,
    required super.selectedAnswers,
    required this.timestamp,
    required this.timeSpent,
    required this.correctAnswers,
    required this.grade,
  }) : super.fromSnapshot();

  Map<String, dynamic> toJson() => {
    "version": schemaVersion,
    "timestamp": timestamp.toIso8601String(),
    "timeSpent": timeSpent,
    "correctAnswers": correctAnswers,
    "grade": grade,
    "questions": questions.map((q) => q.toJson()).toList(),
    "selectedAnswers": selectedAnswers,
  };

  factory QuizCompleted.fromJson(Map<String, dynamic> json) {
    return QuizCompleted.fromSnapshot(
      questions: (json["questions"] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      selectedAnswers: (json["selectedAnswers"] as List).cast<int?>(),
      timestamp: DateTime.parse(json["timestamp"] as String),
      timeSpent: json["timeSpent"] as int,
      correctAnswers: json["correctAnswers"] as int,
      grade: (json["grade"] as num).toDouble(),
    );
  }
}
