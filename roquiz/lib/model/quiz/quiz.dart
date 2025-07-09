import 'package:roquiz/model/quiz/question.dart';

class Quiz {
  List<Question> _questions = [];
  List<int> _userAnswers = [];

  int _iQuestion = 0;

  Quiz();

  Quiz.init(
      List<Question> selectedQuestions, int questionNum, bool shuffleAnswers) {
    selectedQuestions.shuffle();
    for (int i = 0; i < questionNum; i++) {
      _questions.add(selectedQuestions[i]);
      _userAnswers[i] = -1;
    }
  }

  int get currentQuestion => _iQuestion;
}
