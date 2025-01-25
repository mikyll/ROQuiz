import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/quiz/question.dart';

class Quiz {
  List<Question> _questions = [];
  List<int> _userAnswers = [];

  Quiz(QuestionRepository repository, int questionNum, bool shuffleAnswers) {}
}
