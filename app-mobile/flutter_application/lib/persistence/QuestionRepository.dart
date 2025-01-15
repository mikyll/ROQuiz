import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roquiz/model/PlatformType.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionRepository {
  static final DateTime CUSTOM_DATE = DateTime.parse("1999-01-01T00:00:00Z");
  static final DateTime DEFAULT_LAST_QUESTION_UPDATE =
      DateTime.parse("2023-07-19T20:18:08Z");
  static const int DEFAULT_ANSWER_NUMBER = 5;

  DateTime lastQuestionUpdate = DEFAULT_LAST_QUESTION_UPDATE;
  List<Question> questions = [];
  bool topicsPresent = false;
  List<String> topics = [];
  List<int> qNumPerTopic = [];

  String error = "";

  late String _cachedNewContent;
  late DateTime _cachedNewDate;

  Future<String> loadString() async {
    final prefs = await SharedPreferences.getInstance();

    lastQuestionUpdate = DateTime.parse(prefs.getString("lastQuestionUpdate") ??
        DEFAULT_LAST_QUESTION_UPDATE.toString());

    String content = "";

    switch (getPlatformType()) {
      // Mobile
      case PlatformType.MOBILE:
        Directory appDocDir = await getApplicationSupportDirectory();

        String filePath = "${appDocDir.path}/Domande.txt";
        File file = File(filePath);

        // Check if file is present
        if (!file.existsSync()) {
          // If not create it and load from bundle
          file.create();

          String contentFromAsset =
              await rootBundle.loadString("assets/domande.txt");
          file.writeAsString(contentFromAsset);
        }

        String testContent = await file.readAsString();

        if (isValid(testContent) > 0) {
          String contentFromAsset =
              await rootBundle.loadString("assets/domande.txt");
          file.writeAsString(contentFromAsset);
        }
        content = testContent;

        break;

      // Desktop
      case PlatformType.DESKTOP:
        // Check if data/ directory exists, create it otherwise
        Directory dataDirectory = Directory.fromUri(Uri.directory('./data/'));
        if (!dataDirectory.existsSync()) {
          await dataDirectory.create(recursive: true);
        }

        // Check if questions file exists, copy it from asset otherwise
        File file = File("${dataDirectory.absolute.path}/Domande.txt");
        if (!file.existsSync()) {
          // If not create it and load from bundle
          await file.create();

          String contentFromAsset =
              await rootBundle.loadString("assets/domande.txt");
          file.writeAsString(contentFromAsset);
        } else if (isValid(file.readAsStringSync()) < 0) {
          String contentFromAsset =
              await rootBundle.loadString("assets/domande.txt");
          file.writeAsString(contentFromAsset);
        }

        content = await file.readAsString();

        break;

      // Web & others (NB: web would have the asset always updated to the last version)
      default:
        content = await rootBundle.loadString("assets/domande.txt");
    }

    return content;
  }

  Future<void> load() async {
    String content = await loadString();

    parse(content);
  }

  /// Retrieves the timestamp of the latest question file, from the GitHub repository.
  Future<DateTime> getLatestQuestionFileDate() async {
    DateTime date;

    http.Response response = await http.get(Uri.parse(
        'https://api.github.com/repos/mikyll/ROQuiz/commits?path=Domande.txt&page=1&per_page=1'));

    try {
      List<dynamic> json = jsonDecode(response.body);
      String dateString = json[0]['commit']['author']['date'];
      date = DateTime.parse(dateString);

      _cachedNewDate = date;

      return date;
    } catch (e) {
      print("Error: $e");

      return Future.error(e);
    }
  }

  /// Returns true if there is a more recent questions file
  Future<(bool, DateTime, int)> checkQuestionUpdates() async {
    if (getPlatformType() == PlatformType.MOBILE) {
      return (false, DateTime.now(), 0);
    }

    DateTime date = await getLatestQuestionFileDate();
    String content = await downloadFile();
    int qNum = isValid(content);

    _cachedNewDate = date;

    return (date.isAfter(lastQuestionUpdate), date, qNum);
  }

  Future<String> downloadFile(
      [url =
          "https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt"]) async {
    String result = "";

    // Get file content from repo
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      result = response.body;

      _cachedNewContent = result;
    }

    return result;
  }

  void updateQuestionsDate([DateTime? newDate]) async {
    final prefs = await SharedPreferences.getInstance();

    DateTime date;
    if (newDate != null) {
      date = newDate;
    } else {
      date = _cachedNewDate;
    }

    // Update shared preferences
    prefs.setString("lastQuestionUpdate", date.toString());

    // Load date to repository
    lastQuestionUpdate = date;
  }

  /// Overwrite questions file
  Future<bool> updateQuestionsFile([String? newContent]) async {
    String content;

    // Check if it's valid
    if (newContent != null) {
      content = newContent;
    } else {
      content = _cachedNewContent;
    }
    if (isValid(content) < 0) {
      return false;
    }

    // Update file
    switch (getPlatformType()) {
      // Mobile
      case PlatformType.MOBILE:
        Directory appDocDir = await getApplicationSupportDirectory();

        String filePath = "${appDocDir.path}/Domande.txt";
        File file = File(filePath);

        file.writeAsString(content);

        break;
      case PlatformType.DESKTOP:
        String filePath = "./data/Domande.txt";
        File file = File(filePath);

        file.writeAsString(content);

        break;
      default:
        print("TO-DO: implement");
    }

    // Load to repository
    parse(content);

    return true;
  }

  Future<void> update() async {
    updateQuestionsDate();
    await updateQuestionsFile();
  }

  // Parse a string and save each question in the repository
  void parse(String content) async {
    questions.clear();
    topics.clear();
    qNumPerTopic.clear();
    topicsPresent = false;
    error = "";

    int numPerTopic = 0, totQuest = 0;

    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(content);

    // the question file can be subdivided by topics (i == line #)
    for (int i = 0; i < lines.length; i++) {
      // if the first line starts with '@', then the file has topics
      if (i == 0 && lines[i].startsWith("@")) {
        topicsPresent = true;

        topics.add(lines[i].substring(1).replaceAll("=", ""));

        continue;
      }

      // next question
      if (lines.length > i && lines[i].isNotEmpty) {
        // next topic
        if (topicsPresent && lines[i].startsWith("@")) {
          qNumPerTopic.add(numPerTopic);
          numPerTopic = 0;

          topics.add(lines[i].substring(1).replaceAll("=", ""));
          i++;
        } else if (lines[i].startsWith("@")) {
          throw FileSystemException(
              "Riga ${i + 1}: divisione per argomenti non rilevata (non è presente l'argomento per le prime domande), ma ne è stato trovato uno comunque");
        }

        Question q = Question(totQuest + 1, lines[i]);

        for (int j = 0; j < DEFAULT_ANSWER_NUMBER; j++) {
          i++;
          if (lines.length <= i) {
            throw FileSystemException(
                "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} mancante");
          }
          List<String> splitted = lines[i].split(". ");
          if (splitted.length < 2 || splitted[1].isEmpty) {
            throw FileSystemException(
                "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} formata male");
          }

          q.addAnswer(splitted[1]);
        }
        i++;

        if (lines.length <= i || lines[i].length != 1) {
          throw FileSystemException("Riga ${i + 1}: risposta corretta assente");
        }

        int asciiValue = lines[i].codeUnitAt(0);
        int value = asciiValue - 65;
        if (value < 0 || value > DEFAULT_ANSWER_NUMBER - 1) {
          throw FileSystemException(
              "Riga ${i + 1}: risposta corretta non valida");
        }
        q.setCorrectAnswerFromInt(value);

        if (topicsPresent) {
          q.setTopic(topics.last);
        }

        questions.add(q);

        totQuest++;

        if (topicsPresent) numPerTopic++;
      }
    }

    if (topicsPresent) {
      qNumPerTopic.add(numPerTopic);

      print("Tot domande: $totQuest");
      print("Argomenti: ");
      for (int i = 0; i < qNumPerTopic.length; i++) {
        print("- ${topics[i]} (num domande: ${qNumPerTopic[i].toString()})");
      }
    }
  }

  List<Question> getQuestions() {
    return questions;
  }

  List<String> getTopics() {
    return topics;
  }

  List<int> getQuestionNumPerTopic() {
    return qNumPerTopic;
  }

  bool hasTopics() {
    return topicsPresent;
  }

  /// Restituisce un intero che indica il risultato ed una Stringa in caso di errore.
  static (int, String) isValidErrors(String content) {
    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(content);
    bool topics = false;
    int numQuestions = 0;

    // the question file can be subdivided by topics (i == line #)
    for (int i = 0; i < lines.length; i++) {
      // if the first line starts with '@', then the file has topics
      if (i == 0 && lines[i].startsWith("@")) {
        topics = true;

        continue;
      }

      // next question
      if (lines.length > i && lines[i].isNotEmpty) {
        // next topic
        if (lines[i].startsWith("@")) {
          if (topics) {
            i++;
          } else {
            return (
              -1,
              "Riga ${i + 1}: divisione per argomenti non rilevata (non è presente l'argomento per le prime domande), ma ne è stato trovato uno comunque"
            );
          }
        }

        // answers
        for (int j = 0; j < DEFAULT_ANSWER_NUMBER; j++) {
          i++;
          if (lines.length <= i) {
            return (
              -2,
              "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} mancante"
            );
          }
          List<String> splitted = lines[i].split(". ");
          if (splitted.length < 2 || splitted[1].isEmpty) {
            return (
              -3,
              "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} formata male"
            );
          }
        }
        i++;

        if (lines.length <= i || lines[i].length != 1) {
          return (-4, "Riga ${i + 1}: risposta corretta assente");
        }

        int asciiValue = lines[i].codeUnitAt(0);
        int value = asciiValue - 65;
        if (value < 0 || value > DEFAULT_ANSWER_NUMBER - 1) {
          return (-5, "Riga ${i + 1}: risposta corretta non valida");
        }

        numQuestions++;
      }
    }
    return (
      numQuestions,
      numQuestions > 0 ? "OK" : "Non sono presenti domande."
    );
  }

  static int isValid(String content) {
    int res;
    String err;
    (res, err) = isValidErrors(content);

    if (res < 0) {
      print(err);
    }
    return res;
  }

  static bool isValidBool(String content) {
    return isValid(content) > 0;
  }

  @override
  String toString() {
    String res = "";
    for (int i = 0; i < questions.length; i++) {
      res += "Q${i + 1}) ${questions[i].question}\n";

      for (int j = 0; j < questions[i].answers.length; j++) {
        res += "${Answer.values[j]}. ${questions[i].answers[j]}\n";
      }
      res += "\n";
    }

    return res;
  }

  // Auxiliary method for testing
  Future<void> reloadFromAsset() async {
    String content = await rootBundle.loadString("assets/domande.txt");

    updateQuestionsDate(DEFAULT_LAST_QUESTION_UPDATE);
    updateQuestionsFile(content);
    parse(content);
  }
}
