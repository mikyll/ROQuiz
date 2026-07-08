import 'dart:convert';

import 'package:roquiz/model/quiz/question.dart';
import 'package:yaml/yaml.dart';

/// Supported on-disk formats for a questions file.
enum QuestionFormat { txt, yaml }

/// Detects which [QuestionFormat] [content] is, or `null` if it is neither.
///
/// Tries the txt parser first and returns [QuestionFormat.txt] as soon as it
/// yields a non-empty list; otherwise falls back to the yaml parser. For real
/// question files at most one parser can succeed (a txt file is not a YAML list,
/// and a yaml file fails the txt answer-format validation), so this
/// short-circuit is equivalent to trying both — it just avoids the redundant
/// second parse.
QuestionFormat? inferQuestionFormat(String content) {
  try {
    if (parseQuestionsFromTxt(content).isNotEmpty) {
      return QuestionFormat.txt;
    }
  } catch (_) {}

  try {
    if (parseQuestionsFromYaml(content).isNotEmpty) {
      return QuestionFormat.yaml;
    }
  } catch (_) {}

  return null;
}

List<Question> parseQuestionsFromTxt(String content) {
  List<Question> questions = [];
  List<String> topics = [];
  String? currentTopic;

  // Remove leading and trailing whitespaces before splitting in lines
  content = content.trim();

  if (content.isEmpty) {
    throw FormatException("Empty file");
  }

  LineSplitter ls = const LineSplitter();
  List<String> lines = ls.convert(content);

  // Loop over lines
  for (int iLine = 0; iLine < lines.length; iLine++) {
    int id;
    String body;
    List<String> answers = [];
    int? correctAnswer;

    // Skip line if it's empty
    if (lines[iLine].isEmpty) {
      continue;
    }

    // Check if the current line is a topic
    if (lines[iLine].startsWith("@")) {
      // Check if there already are questions without topic
      if (topics.isEmpty && questions.isNotEmpty) {
        throw FormatException(
          "Line ${iLine + 1}: topics error! A topic was found but there already are ${questions.length} questions with no topic",
        );
      }

      // Parse topic
      currentTopic = lines[iLine].substring(1).replaceAll("=", "").trim();

      // Duplicated topic
      if (topics.contains(currentTopic)) {
        throw FormatException(
          "Line ${iLine + 1}: duplicated topic '$currentTopic'",
        );
      }
      topics.add(currentTopic);
      continue;
    }

    id = questions.length;
    body = lines[iLine];
    iLine++;

    // Parse answers
    for (int iAnswer = 0; ; iLine++, iAnswer++) {
      // End of file
      if (iLine >= lines.length) {
        break;
      }

      // Answer iAnswer is empty
      if (lines[iLine].isEmpty) {
        throw FormatException(
          "Line ${iLine + 1}: empty answer '${String.fromCharCode(iAnswer + 65)}'",
        );
      }

      // Break out if we find the correct answer
      if (lines[iLine].length == 1) {
        correctAnswer = lines[iLine].codeUnitAt(0) - 65;
        break;
      }

      // Try parsing answer iAnswer
      List<String> splitted = lines[iLine].split(". ");
      if (splitted[0].length != 1) {
        throw FormatException(
          "Line ${iLine + 1}: answer letter must be a single uppercase character be '${String.fromCharCode(iAnswer + 65)}'",
        );
      }
      if ((splitted[0].codeUnitAt(0) - 65) != iAnswer) {
        throw FormatException(
          "Line ${iLine + 1}: answer letter must be '${String.fromCharCode(iAnswer + 65)}', but got '${splitted[0]}'",
        );
      }

      if (splitted.length < 2) {
        throw FormatException(
          "Line ${iLine + 1}: answer '${String.fromCharCode(iAnswer + 65)}' badly formatted",
        );
      }
      if (splitted[1].isEmpty) {
        throw FormatException(
          "Line ${iLine + 1}: answer '${String.fromCharCode(iAnswer + 65)}' is empty",
        );
      }

      String answerBody = lines[iLine].substring(2).trim();
      answers.add(answerBody);
    }
    if (correctAnswer == null) {
      throw FormatException(
        "Line ${iLine + 1}: missing correct answer for question #$id",
      );
    }

    try {
      Question question = Question(
        id: id,
        body: body,
        topic: currentTopic,
        answers: answers,
        correctAnswer: correctAnswer,
      );
      questions.add(question);
    } catch (e) {
      throw FormatException("Line ${iLine + 1}: error in question #$id: $e");
    }
  }

  return questions;
}

List<Question> parseQuestionsFromYaml(String content) {
  List<Question> questions = [];

  final dynamic parsedData = loadYaml(content);

  if (parsedData is! List) {
    throw FormatException("Invalid YAML format: expected a list of questions");
  }

  int iQ = 0;
  for (final question in parsedData) {
    if (question is! Map) {
      throw FormatException("Invalid question: $question");
    }

    final body = question["body"] as String;
    final topic = question["topic"] as String?;
    final answers = question["answers"] as List;
    final correctAnswer = question["correct_answer"];
    final custom = question["custom"] as bool?;

    Question q = Question(
      id: iQ,
      body: body,
      topic: topic,
      answers: List<String>.from(answers),
      correctAnswer: correctAnswer,
      isCustom: custom,
    );

    questions.add(q);
    iQ++;
  }

  return questions;
}

Map<String, int> getTopicSizes(List<Question> questions) {
  Map<String, int> topicSizes = {};

  for (Question question in questions) {
    String? topic = question.topic;

    // No topics
    if (topic == null) {
      return topicSizes;
    }

    if (topicSizes.containsKey(topic)) {
      topicSizes[topic] = topicSizes[topic]! + 1;
    } else {
      topicSizes[topic] = 1;
    }
  }

  return topicSizes;
}
