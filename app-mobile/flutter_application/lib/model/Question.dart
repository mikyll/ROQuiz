import 'dart:collection';
import 'dart:io';
import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Settings.dart';

class Question {
  String question = "";
  List<String> answers = [];
  Answer correctAnswer = Answer.NONE;

  Question(this.question);

  void addAnswer(String answer) {
    if (answers.length == Settings.DEFAULT_ANSWER_NUMBER) {
      throw Exception("Answer number excedeed.");
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

  void shuffleAnswers() {
    List<String> a = answers;
    String ca = answers[correctAnswer.index];

    a.shuffle();

    answers = [];
    for (int i = 0; i < a.length; i++) {
      answers.add(a[i]);
      if (a[i] == ca) {
        correctAnswer = Answer.values[i];
      }
    }
  }
}
