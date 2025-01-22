import 'dart:convert';
import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

import '../model/quiz/question.dart';

// Launch system url in the system browser
void openUrl(String url, {bool external = true}) async {
  launchUrlString(
    url,
    mode: external ? LaunchMode.externalApplication : LaunchMode.inAppWebView,
  ).then((onValue) {}).onError((error, stackTrace) {
    throw Exception("Could not launch $url: $error");
  });
}

// NB: Questions already contain the topic, so there's no need to return the list while parsing
List<Question> parseQuestions(String content, int maxNumAnwers) {
  const minAnswers = 2;

  List<Question> questions = [];
  List<String> topics = [];
  String currentTopic = "";

  content = content.trim();

  // Empty content
  if (content.isEmpty) {
    throw FormatException("File vuoto");
  }

  LineSplitter ls = const LineSplitter();
  List<String> lines = ls.convert(content);

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

      // Parse topic
      currentTopic = lines[iQ].substring(1).replaceAll("=", "").trim();

      // Duplicated topic
      if (topics.contains(currentTopic)) {
        throw FormatException("Riga ${iQ + 1}: argomento duplicato");
      }
      topics.add(currentTopic);
      continue;
    }

    // Parse question
    Question question = Question.onlyBody(questions.length + 1, lines[iQ]);
    if (topics.isNotEmpty) {
      question.setTopic(currentTopic);
    }
    iQ++;

    // Parse answers
    for (int iA = 0; iA < maxNumAnwers; iQ++, iA++) {
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

      question.addAnswer(splitted[1]);
    }

    if (iQ >= lines.length) {
      throw FormatException(
          "Riga ${iQ + 1}: fine del file prima della lettura della risposta corretta");
    }

    // Try reading the correct answer
    if (lines[iQ].length != 1) {
      throw FormatException("Riga ${iQ + 1}: risposta corretta assente");
    }

    if (question.getAnswers().length < minAnswers) {
      throw FormatException(
          "Riga ${iQ + 1}: non sono ammesse domande con meno di $minAnswers risposte");
    }

    // Check if the correct answer is valid (in letters range)
    int letterCode = lines[iQ].codeUnitAt(0);
    if (letterCode < "A".codeUnitAt(0) ||
        letterCode > "A".codeUnitAt(0) + question.getAnswers().length - 1) {
      throw FormatException(
          "Riga ${iQ + 1}: la risposta corretta dev'essere una delle risposte presenti");
    }
    question.setCorrectAnswer(letterCode - 65);
    iQ++;

    questions.add(question);
  }

  return questions;
}

Map<String, int> getTopicSizes(List<Question> questions) {
  Map<String, int> topicSizes = {};

  for (Question question in questions) {
    String topic = question.getTopic();
    if (topicSizes.containsKey(topic)) {
      topicSizes[topic] = topicSizes[topic]! + 1;
    } else {
      topicSizes[topic] = 1;
    }
  }

  return topicSizes;
}

List<Question> parseQuestionsFromYaml(String content) {
  List<Question> questions = [];

  // TODO

  return questions;
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print("No arg specified args");
    return;
  }

  File file = File(args[0]);
  if (!file.existsSync()) {
    print("File ${args[0]} doesn't exist");
  }

  file.readAsString().then((content) {
    List<Question> questions = parseQuestions(content, 5);
    for (Question q in questions) {
      print(q.toYAML());
    }

    if (args.length >= 2 && args[1] == "-t") {
      Map<String, int> topicSizes = getTopicSizes(questions);
      for (String topic in topicSizes.keys) {
        print("- $topic");
      }
    }
  });
}
