import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Question.dart';

class Quiz {
  List<Question> questions = [];
  List<Answer> answers = []; // user answers (selected or unselected)
  int givenAnswers = 0; // total given answers
  int correctAnswer = 0; // total correct answers

  /*Quiz(List<Question> questions, int qNum, bool shuffleAnswers) {
    _resetQuiz(questions, qNum, shuffleAnswers);
  }*/

  void resetQuiz(List<Question> questions, int qNum, bool shuffleAnswers) {
    this.questions = [];
    answers = [];

    // reset Questions
    questions.shuffle();
    for (int i = 0; i < qNum; i++) {
      if (shuffleAnswers) questions[i].shuffleAnswers();

      this.questions.add(questions[i]);
      answers.add(Answer.NONE);
    }

    // reset Answer counters
    givenAnswers = 0;
    correctAnswer = 0;
  }

  void setAnswerFromInt(int index, int value) {
    if (answers[index] == Answer.NONE) {
      givenAnswers++;
    }

    answers[index] = Answer.values[value];
  }

  void setAnswerFromEnum(int index, Answer value) {
    if (answers[index] == Answer.NONE) {
      givenAnswers++;
    }
    answers[index] = value;
  }

  double getQuizGrade() {
    if (questions.isEmpty) return 0;
    double percentage = correctAnswer / questions.length;
    return 18 + percentage * (30 - 18);
  }

  double calculateFinalGrade(double writtenGrade) {
    double quizGrade = getQuizGrade();
    return ((writtenGrade * 2) + quizGrade) / 3;
  }

}
