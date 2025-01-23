import 'package:flutter/services.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionRepository {
  List<Question> _questions = [];
  Map<String, int> _topicSizes = {};
  DateTime _lastQuestionUpdate = DateTime.parse("2000-00-00T00:00:00Z");

  static Future<QuestionRepository> loadFromAssets(
      {String path = "assets/domande.txt"}) async {
    String contentFromAsset = await rootBundle.loadString(path);

    QuestionRepository qRepo = QuestionRepository();

    return qRepo;
  }

  int checkUpdates() {
    return -1;
  }
}
