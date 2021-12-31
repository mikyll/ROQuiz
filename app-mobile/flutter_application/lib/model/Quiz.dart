import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Question.dart';

class Quiz {
  late List<Question> quiz;
  late List<Answer> answers; // user answers (selected or unselected)
  late int givenAnswers; // total given answers
  late int correctAnswer; // total correct answers

  Quiz(List<Question> questions, int qNum) {
    _resetQuiz(questions, qNum);
  }

  void _resetQuiz(List<Question> questions, int qNum) {
    quiz = List<Question>.empty();

    // reset Questions
    questions.shuffle();
    for (int i = 0; i < qNum; i++) {
      quiz.add(questions[i]);
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
}
