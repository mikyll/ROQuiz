import 'package:flutter/services.dart';
import 'package:roquiz/cli/utils/parser.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionRepository {
  late List<Question> _questions = [];
  List<String> _topics = [];
  DateTime _lastQuestionUpdate = DateTime.parse("2000-00-00T00:00:00Z");

  // static Future<QuestionRepository> loadFromAssets(
  //     {String path = "assets/domande.txt"}) async {
  //   String contentFromAsset = await rootBundle.loadString(path);

  //   QuestionRepository qRepo = QuestionRepository();

  //   return qRepo;
  // }

  Future<void> loadFromAsset({String path = "assets/domande.yaml"}) async {
    String contentFromAsset = await rootBundle.loadString(path);

    _questions = parseQuestionsFromYaml(contentFromAsset);

    // Init topics
    for (Question q in _questions) {
      String topic = q.getTopic();

      if (!_topics.contains(topic)) {
        _topics.add(topic);
      }
    }
  }

  List<String> getTopics() {
    List<String> topics = [];

    for (Question q in _questions) {
      String topic = q.getTopic();

      if (!topics.contains(topic)) {
        topics.add(topic);
      }
    }
    return topics;
  }

  Map<String, List<Question>> getGroupedQuestions() {
    Map<String, List<Question>> groupedQuestions = {};

    for (String topic in getTopics()) {
      groupedQuestions[topic] = [];
    }

    for (Question q in _questions) {
      String topic = q.getTopic();

      groupedQuestions[topic]!.add(q);
    }

    return groupedQuestions;
  }

  List<Question> getQuestions() {
    return _questions;
  }

  void loadFromFile() {}

  int checkUpdates() {
    return -1;
  }
}

// class Topic {
//   String name;
//   int size;
//   bool selected;
// }
