import 'package:roquiz/model/Answer.dart';

import 'package:roquiz/model/Question.dart';

class Quiz {
  List<Question> quiz;
  List<Answer> answers; // user answers (selected or unselected)
  int givenAnswers; // total given answers
  int correctAnswer; // total correct answers

  Quiz(List<Question> questions, int qNum) {
    this._resetQuiz(questions, qNum);
  }

  void _resetQuiz(List<Question> questions, int qNum) {
    this.quiz = List<Question>.empty();
  }
}
