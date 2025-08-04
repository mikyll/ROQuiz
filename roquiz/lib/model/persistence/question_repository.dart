import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:roquiz/cli/questions_parser.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionRepository {
  final String repositoryURL =
      "https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt";

  List<Question> questions = [];
  List<String> _topics = [];
  DateTime _lastQuestionUpdate = DateTime.parse("2000-00-00T00:00:00Z");

  Future<void> init({bool checkNewQuestions = false}) async {
    questions = await loadFromAsset();

    if (checkNewQuestions) {
      // Check if there are new questions

      // Download (from repo and save to local file)

      // http.Response response = await http.get(Uri.parse(repositoryURL));
      //questionsList =
    }
  }

  Future<DateTime> getLatestQuestionsFileDatetime({
    String repository = "mikyll/ROQuiz",
    String path = "Domande.txt",
  }) async {
    DateTime date;

    try {
      http.Response response = await http.get(
        Uri.parse(
          "https://api.github.com/reps/$repository/commits?path=$path&page=1&per_page=1",
        ),
      );

      dynamic json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Future.error(HttpException(json["message"]));
      }

      String dateString = json[0]['commit']['author']['date'];
      date = DateTime.parse(dateString);

      return Future<DateTime>.value(date);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> checkUpdates() {
    // TODO

    // 1. Get datetime from remote

    // 2. Compare current datetime with remote datetime

    // 3. If remote has a more recent datetime, return true

    return Future.value(false);
  }

  Future<List<Question>> loadFromAsset({
    String path = "assets/questions.yaml",
  }) async {
    String contentFromAsset = await rootBundle.loadString(path);

    List<Question> questions = parseQuestionsFromYaml(contentFromAsset);

    // Init topics
    for (Question q in questions) {
      // Todo
      String topic = q.topic!;

      if (!_topics.contains(topic)) {
        _topics.add(topic);
      }
    }

    return Future.value(questions);
  }

  Future<List<Question>> downloadFromRemote() {
    // TODO

    // 1. Download from remote URL

    // 2. Parse questions

    // 3. Return questions list

    return Future.value([]);
  }

  Future<void> saveToLocal(List<Question> questions, {bool custom = false}) {
    // TODO

    // 1. Save questions list to local file

    // 2. Update datetime in this class

    // 3. Update datetime in shared preferences
    // 3.1 Update custom in shared preferences

    return Future.value();
  }

  // TODO:
  // 1. check for updates
  //   - yes, download and save them in local file
  //   - no, proceed

  // static Future<QuestionRepository> loadFromAssets(
  //     {String path = "assets/domande.txt"}) async {
  //   String contentFromAsset = await rootBundle.loadString(path);

  //   QuestionRepository qRepo = QuestionRepository();

  //   return qRepo;
  // }

  // Future<void> loadFromAsset({String path = "assets/questions.yaml"}) async {
  //   String contentFromAsset = await rootBundle.loadString(path);

  //   questions = parseQuestionsFromYaml(contentFromAsset);

  //   // Init topics
  //   for (Question q in questions) {
  //     // Todo
  //     String topic = q.topic!;

  //     if (!_topics.contains(topic)) {
  //       _topics.add(topic);
  //     }
  //   }
  // }

  List<String> getTopics() {
    List<String> topics = [];

    for (Question q in questions) {
      // Todo
      String topic = q.topic!;

      if (!topics.contains(topic)) {
        topics.add(topic);
      }
    }
    return topics;
  }

  // Returns a map with questions grouped by topic
  Map<String, List<Question>> getGroupedQuestions() {
    Map<String, List<Question>> groupedQuestions = {};

    for (String topic in getTopics()) {
      groupedQuestions[topic] = [];
    }

    for (Question q in questions) {
      // Todo
      String topic = q.topic!;

      groupedQuestions[topic]!.add(q);
    }

    return groupedQuestions;
  }

  void loadFromFile() {}
}
