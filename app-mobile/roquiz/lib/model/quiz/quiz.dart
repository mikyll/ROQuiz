import 'package:roquiz/model/quiz/question.dart';

class Quiz {
  List<Question> _questions = [];
  List<int> _userAnswers = [];

  Quiz(List<Question> questions, int questionNum, bool shuffleAnswers) {}
}
