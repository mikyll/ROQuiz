import 'package:roquiz/model/quiz/question.dart';

class Quiz {
  List<Question> questions = [];
  List<int?> selectedAnswers = [];

  Quiz({
    required this.questions,
    required int questionNum,
    required bool shuffleAnswers,
  }) {
    questions = List.of(questions);
    questions.shuffle();
    questions = questions.take(questionNum).toList();

    for (int i = 0; i < questionNum; i++) {
      if (shuffleAnswers) {
        questions[i].answers.shuffle();
      }

      selectedAnswers.add(null);
    }
  }

  int countCorrectAnswers() {
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] != null &&
          selectedAnswers[i] == questions[i].correctAnswer) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }
}
