import 'package:roquiz/model/quiz/question.dart';

class QuizQuestion extends Question {
  QuizQuestion(
    super.id,
    super.body,
    super.topic,
    super.answers,
    super.correctAnswer,
  );
}
