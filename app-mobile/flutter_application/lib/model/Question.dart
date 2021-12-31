import 'dart:collection';
import 'package:roquiz/model/Answer.dart';

class Question {
  String question;
  HashMap<Answer, String> answers;
  Answer correctAnswer;

  Question({required this.question /*, this.answers, this.correctAnswer*/});
}
