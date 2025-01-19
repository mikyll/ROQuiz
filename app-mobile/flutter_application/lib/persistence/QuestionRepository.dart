import 'package:flutter/material.dart';
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
  static const int MIN_ANSWER_NUMBER = 2;
  static const int MAX_ANSWER_NUMBER = 5;

  DateTime lastQuestionUpdate = DEFAULT_LAST_QUESTION_UPDATE;
  List<Question> questions = [];
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

    parseFromTxt(content);
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
    parseFromTxt(content);

    return true;
  }

  Future<void> update() async {
    updateQuestionsDate();
    await updateQuestionsFile();
  }

  // Parse a string and save each question in the repository
  void parseFromTxt(String content) async {
    questions.clear();
    topics.clear();
    qNumPerTopic.clear();
    error = "";
    int numPerTopic = 0;

    // Empty file
    if (content.trim().isEmpty) {
      throw FormatException("File vuoto");
    }

    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(content.trim());

    // Trim leading and trailing spaces
    for (String s in lines) {
      s = s.trim();
    }

    // Loop over lines
    for (int iQ = 0; iQ < lines.length; iQ++) {
      // Check if the current line is empty or full of white spaces
      if (lines[iQ].isEmpty) continue;

      // Check if the current line is a topic
      if (lines[iQ].startsWith("@")) {
        // Check if there already are questions without topic
        if (topics.isEmpty && questions.isNotEmpty) {
          throw FormatException(
              "Riga ${iQ + 1}: errore argomenti! E' stato trovato un argomento ma sono gia' presenti domande senza");
        }

        if (topics.isNotEmpty) {
          qNumPerTopic.add(numPerTopic);
          numPerTopic = 0;
        }

        // Parse topic
        String topic = lines[iQ].substring(1).replaceAll("=", "").trim();
        topics.add(topic);
        continue;
      }

      // Parse question
      Question q = Question(questions.length, lines[iQ]);
      if (topics.isNotEmpty) q.setTopic(topics.last);
      iQ++;

      // Parse answers
      for (int iA = 0; iA < MAX_ANSWER_NUMBER; iQ++, iA++) {
        // End of file
        if (iQ >= lines.length) {
          throw FormatException(
              "Riga ${iQ + 1}: fine del file prima della lettura di tutte le risposte");
        }

        // Check if answer line is empty
        if (lines[iQ].isEmpty) {
          throw FormatException("Riga ${iQ + 1}: risposta vuota");
        }

        // Check if we found the correct answer
        if (lines[iQ].length == 1) {
          break;
        }

        // Try splitting
        List<String> splitted = lines[iQ].split(". ");
        if (splitted.length < 2 || splitted[1].isEmpty) {
          throw FormatException(
              "Riga ${iQ + 1}: risposta ${String.fromCharCode((iA + 65))} formattata male");
        }

        q.addAnswer(splitted[1]);
      }

      if (iQ >= lines.length) {
        throw FormatException(
            "Riga ${iQ + 1}: fine del file prima della lettura della risposta corretta");
      }

      // Try reading the correct answer
      if (lines[iQ].length != 1) {
        throw FormatException("Riga ${iQ + 1}: risposta corretta assente");
      }

      if (q.answers.length < MIN_ANSWER_NUMBER) {
        throw FormatException(
            "Riga ${iQ + 1}: non sono ammesse domande con meno di $MIN_ANSWER_NUMBER risposte");
      }

      // Check if the correct answer is valid (in letters range)
      int letterCode = lines[iQ].codeUnitAt(0);
      if (letterCode < "A".codeUnitAt(0) ||
          letterCode > "A".codeUnitAt(0) + q.answers.length - 1) {
        throw FormatException(
            "Riga ${iQ + 1}: la risposta corretta dev'essere una delle risposte presenti");
      }
      q.setCorrectAnswerFromInt(letterCode - 65); // TODO
      iQ++;

      questions.add(q);

      if (topics.isNotEmpty) numPerTopic++;
    }

    if (topics.isNotEmpty) qNumPerTopic.add(numPerTopic);

    //printSummary();
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
    return topics.isNotEmpty;
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
        for (int j = 0; j < MAX_ANSWER_NUMBER; j++) {
          // Check correct answer
          if (lines[i].length == 1) {
            // Check if there are enough answers
            if (j < MIN_ANSWER_NUMBER) {
              return (
                -1,
                "Riga ${i + 1}: non sono ammesse domande con meno di $MIN_ANSWER_NUMBER risposte",
              );
            }

            int letterCode = lines[i].codeUnitAt(0);

            // Check if the correct answer is valid (in range)
            if (letterCode < "A".codeUnitAt(0) ||
                letterCode > "A".codeUnitAt(0) + j) {
              return (
                -2,
                "Riga ${i + 1}: non sono ammesse domande con meno di $MIN_ANSWER_NUMBER risposte",
              );
            }
            print("Risposta corretta: ${String.fromCharCode(letterCode)}");
            i++;
            break;
          }

          if (j == MAX_ANSWER_NUMBER) {
            return (
              -3,
              "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} mancante",
            );
          }

          if (lines.length <= i) {
            return (
              -4,
              "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} mancante"
            );
          }
          List<String> splitted = lines[i].split(". ");
          if (splitted.length < 2 || splitted[1].isEmpty) {
            return (
              -5,
              "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} formata male: ${lines[i]}"
            );
          }
        }
        i++;

        if (lines.length <= i || lines[i].length != 1) {
          return (-6, "Riga ${i + 1}: risposta corretta assente");
        }

        int asciiValue = lines[i].codeUnitAt(0);
        int value = asciiValue - 65;
        if (value < 0 || value > MAX_ANSWER_NUMBER - 1) {
          return (-7, "Riga ${i + 1}: risposta corretta non valida");
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

  void printSummary() {
    print("Tot domande: ${questions.length}");
    print("Argomenti: ");
    for (int i = 0; i < qNumPerTopic.length; i++) {
      print("- ${topics[i]} (num domande: ${qNumPerTopic[i].toString()})");
    }
  }

  // Auxiliary method for testing
  Future<void> reloadFromAsset() async {
    String content = await rootBundle.loadString("assets/domande.txt");

    updateQuestionsDate(DEFAULT_LAST_QUESTION_UPDATE);
    updateQuestionsFile(content);
    parseFromTxt(content);
  }
}

main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // String content = await rootBundle.loadString("assets/domande.txt");

  QuestionRepository qRepo = QuestionRepository();
  qRepo.parseFromTxt("""
@ topic-name =================

A. Answer 1
B. Answer 2
A
  """);
}
