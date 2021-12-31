import 'dart:collection';
import 'package:roquiz/model/Answer.dart';

class Question {
  late String question;
  late HashMap<Answer, String> answers;
  late Answer correctAnswer;

  Question(String question) {
    question = question;
    answers = new HashMap<Answer, String>();
  }

  void _addAnswer(String answer) {
    if (answers.keys.length == 5) {
      throw Exception("Too many answers");
    }
    int index = answers.keys.length;
    Answer a = Answer.values[index];
    answers.putIfAbsent(a, () => answer);
  }

  void _setCorrectAnswerFromInt(int correctAnswer) {
    this.correctAnswer = Answer.values[correctAnswer];
  }

  void _setCorrectAnswerFromEnum(Answer correctAnswer) {
    this.correctAnswer = correctAnswer;
  }
}
