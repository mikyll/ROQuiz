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

  /// Rehydrates a quiz from a stored snapshot. Unlike the default constructor,
  /// it does not shuffle or truncate: questions, answer order and the user's
  /// selections are preserved exactly as they were shown when the quiz was taken.
  Quiz.fromSnapshot({required this.questions, required this.selectedAnswers});

  /// Number of questions the user left blank (no answer selected).
  int countBlankAnswers() {
    return selectedAnswers.where((answer) => answer == null).length;
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
