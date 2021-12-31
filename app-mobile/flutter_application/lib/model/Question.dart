import 'dart:collection';
import 'package:roquiz/model/Answer.dart';

class Question {
  late String question;
  late HashMap<Answer, String> answers;
  late Answer correctAnswer;

  Question(String question) {
    question = question;
  }

  void _addAnser(String answer) {}

  void _setCorrectAnswerFromInt(int correctAnswer) {}
  void _setCorrectAnswerFromEnum(Answer correctAnswer) {}
}
