import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/persistence/Settings.dart';

class Question {
  int id = -1;
  String question = "";
  List<String> answers = [];
  Answer correctAnswer = Answer.NONE;
  String topic = "";

  Question(this.id, this.question);

  void addAnswer(String answer) {
    if (answers.length == Settings.DEFAULT_ANSWER_NUMBER) {
      throw Exception("Answer number excedeed.");
    }
    //int index = answers.length;
    //Answer a = Answer.values[index];
    answers.add(answer);
  }

  void setCorrectAnswerFromInt(int correctAnswer) {
    this.correctAnswer = Answer.values[correctAnswer];
  }

  void setCorrectAnswerFromEnum(Answer correctAnswer) {
    this.correctAnswer = correctAnswer;
  }

  void setTopic(String topic) {
    this.topic = topic;
  }

  void shuffleAnswers() {
    List<String> a = answers;
    String ca = answers[correctAnswer.index];

    a.shuffle();

    answers = [];
    for (int i = 0; i < a.length; i++) {
      answers.add(a[i]);
      if (a[i] == ca) {
        correctAnswer = Answer.values[i];
      }
    }
  }
}
