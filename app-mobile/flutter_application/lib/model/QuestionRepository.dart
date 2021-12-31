import 'package:roquiz/model/Question.dart';

class QuestionRepository {
  List<Question> questions;
  List<String> topics;
  List<int> questionsPerTopic;

  List<Question> get questions {
    return questions;
  }

  QuestionRepository() {}

  _loadQuestions() {}
}
