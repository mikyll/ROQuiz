import 'package:roquiz/model/quiz/question.dart';

class Quiz {
  List<Question> questions = [];
  List<int?> selectedAnswers = [];

  Quiz({
    required this.questions,
    required int questionNum,
    required bool shuffleAnswers,
  }) {
    questions.shuffle();
    for (int i = 0; i < questionNum; i++) {
      questions.add(questions[i]);
      selectedAnswers.add(null);
    }
  }
}
