import 'dart:convert';
import 'dart:io';

import 'package:roquiz/model/quiz/question.dart';
import 'package:yaml/yaml.dart';

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

  // Trim leading and trailing whitespaces
  for (String s in lines) {
    s = s.trim();
  }

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
          "Line ${iLine + 1}: topics error! A topic was found but there already are questions with no topic",
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

    id = questions.length + 1;
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
          "Line ${iLine + 1}: empty answer ${String.fromCharCode(iAnswer + 65)}",
        );
      }

      // Break out if we find the correct answer
      if (lines[iLine].length == 1) {
        correctAnswer = lines[iLine].codeUnitAt(0) - 65;
        break;
      }

      // Try parsing answer iAnswer
      List<String> splitted = lines[iLine].split(". ");
      if (splitted.length < 2) {
        throw FormatException(
          "Line ${iLine + 1}: answer ${String.fromCharCode(iAnswer + 65)} badly formatted",
        );
      }
      if (splitted[1].isEmpty) {
        throw FormatException(
          "Line ${iLine + 1}: answer ${String.fromCharCode(iAnswer + 65)} is empty",
        );
      }
      answers.add(splitted[1]);
    }
    if (correctAnswer == null) {
      throw FormatException(
        "Line ${iLine + 1}: missing correct answer for question #$id",
      );
    }

    try {
      Question question = Question(
        id,
        body,
        currentTopic,
        answers,
        correctAnswer,
      );
      questions.add(question);
    } catch (e) {
      throw FormatException("Line ${iLine + 1}: error in question #$id: $e");
    }
  }

  return questions;
}

// TODO: refactor with new Question class
List<Question> parseQuestionsFromYaml(String content) {
  List<Question> questions = [];

  final dynamic parsedData = loadYaml(content);

  if (parsedData is! List) {
    throw FormatException("Invalid YAML format: expected a list of questions");
  }

  int iQ = 1;
  for (final el in parsedData) {
    if (el is Map) {
      try {
        final body = el["body"] as String;
        final topic = el["topic"] as String;
        final answers = el["answers"] as List;
        final correctAnswer = el["correct_answer"];

        Question q = Question(
          iQ,
          body,
          topic,
          List<String>.from(answers),
          correctAnswer,
        );

        iQ++;
        questions.add(q);
      } catch (e) {
        print("Error parsing question: $e");
      }
    } else {
      print("Invalid question format: $el");
    }
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

// // Parse from YAML
// void main(List<String> args) async {
//   if (args.isEmpty) {
//     print("No arg specified args");
//     return;
//   }

//   File file = File(args[0]);
//   if (!file.existsSync()) {
//     print("File ${args[0]} doesn't exist");
//   }

//   file.readAsString().then((content) {
//     List<Question> questions = parseQuestionsFromYaml(content);
//     print(questions.length);

//     if (args.length >= 2 && args[1] == "-t") {
//       Map<String, int> topicSizes = getTopicSizes(questions);
//       for (String topic in topicSizes.keys) {
//         print("- $topic: ${topicSizes[topic]}");
//       }
//     }
//     _printTopics(questions);
//     return;

//     /*List<Question> questions = parseQuestions(content, 5);
//     for (Question q in questions) {
//       print(q.toYAML());
//     }

//     if (args.length >= 2 && args[1] == "-t") {
//       Map<String, int> topicSizes = getTopicSizes(questions);
//       for (String topic in topicSizes.keys) {
//         print("- $topic");
//       }
//     }*/
//   });
// }

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
    List<Question> questions = parseQuestionsFromTxt(content);

    if (args.length >= 2 && args[1] == "-t") {
      Map<String, int> topicSizes = getTopicSizes(questions);
      for (String topic in topicSizes.keys) {
        print("- $topic: ${topicSizes[topic]}");
      }
    }
    _printTopics(questions);
    return;

    /*List<Question> questions = parseQuestions(content, 5);
    for (Question q in questions) {
      print(q.toYAML());
    }

    if (args.length >= 2 && args[1] == "-t") {
      Map<String, int> topicSizes = getTopicSizes(questions);
      for (String topic in topicSizes.keys) {
        print("- $topic");
      }
    }*/
  });
}

void _printTopics(List<Question> questions) {
  String res = "\n";
  int curr = 0;
  Map<String, int> topicSizes = getTopicSizes(questions);

  for (String topic in topicSizes.keys) {
    int num = topicSizes[topic] ?? 0;

    res += "- $topic: $num (+$curr)\n";
    curr += num;
  }
  print(res);
  print(curr);
}
