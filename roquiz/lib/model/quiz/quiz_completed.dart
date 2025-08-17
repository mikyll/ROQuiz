import 'package:roquiz/model/quiz/quiz.dart';

class QuizCompleted extends Quiz {
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
}
