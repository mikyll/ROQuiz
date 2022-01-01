import 'dart:collection';
import 'package:roquiz/model/Answer.dart';

class Question {
  String question = "";
  List<String> answers = [];
  Answer correctAnswer = Answer.NONE;

  Future<List<String>> get getAnswers async {
    return answers;
  }

  Question(String question) {
    question = question;
  }

  void addAnswer(String answer) {
    if (answers.length == 5) {
      throw Exception("Too many answers");
    }
    int index = answers.length;
    Answer a = Answer.values[index];
    answers.add(answer);
  }

  void setCorrectAnswerFromInt(int correctAnswer) {
    this.correctAnswer = Answer.values[correctAnswer];
  }

  void setCorrectAnswerFromEnum(Answer correctAnswer) {
    this.correctAnswer = correctAnswer;
  }
}
