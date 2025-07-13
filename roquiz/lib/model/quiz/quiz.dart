import 'package:roquiz/model/quiz/question.dart';

class Quiz {
  List<Question> questions = [];
  List<int?> selectedAnswers = [];

  Quiz(List<Question> selectedQuestions, int questionNum, bool shuffleAnswers) {
    selectedQuestions.shuffle();
    for (int i = 0; i < questionNum; i++) {
      questions.add(selectedQuestions[i]);
      selectedAnswers.add(null);
    }
  }
}
