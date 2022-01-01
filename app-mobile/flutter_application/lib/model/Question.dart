import 'dart:collection';
import 'package:roquiz/model/Answer.dart';

class Question {
  String question = "";
  HashMap<Answer, String> answers = HashMap();
  Answer correctAnswer = Answer.NONE;

  Future<HashMap<Answer, String>> get getAnswers async {
    return answers;
  }

  Question(String question) {
    question = question;
  }

  void addAnswer(String answer) {
    if (answers.keys.length == 5) {
      throw Exception("Too many answers");
    }
    int index = answers.keys.length;
    Answer a = Answer.values[index];
    answers.putIfAbsent(a, () => answer);
  }

  void setCorrectAnswerFromInt(int correctAnswer) {
    this.correctAnswer = Answer.values[correctAnswer];
  }

  void setCorrectAnswerFromEnum(Answer correctAnswer) {
    this.correctAnswer = correctAnswer;
  }
}
