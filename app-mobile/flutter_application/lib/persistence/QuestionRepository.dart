import 'package:flutter/services.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'dart:io';
import 'dart:convert';

class QuestionRepository {
  static const int DEFAULT_ANSWER_NUMBER = 5;

  List<Question> questions = [];
  List<String> topics = [];
  List<int> qNumPerTopic = [];
  bool topicsPresent = false;

  String error = "";

  Future<void> loadFile(String filePath) async {
    int numPerTopic = 0, totQuest = 0;
    String fileText = await rootBundle.loadString(filePath);

    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(fileText);

    // the question file can be subdivided by topics (i == line #)
    for (int i = 0; i < lines.length; i++) {
      // if the first line starts with '@', then the file has topics
      if (i == 0 && lines[i].startsWith("@")) {
        topicsPresent = true;

        topics.add(lines[i].substring(1).replaceAll("=", ""));

        continue;
      }

      // next question
      if (lines[i].isNotEmpty) {
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

        Question q = Question(lines[i]);

        for (int j = 0; j < DEFAULT_ANSWER_NUMBER; j++) {
          i++;
          List<String> splitted = lines[i].split(". ");
          if (splitted.length < 2 || splitted[1].isEmpty) {
            throw FileSystemException(
                "Riga ${i + 1}: risposta ${String.fromCharCode((j + 65))} formata male");
          }

          q.addAnswer(splitted[1]);
        }
        i++;

        if (lines[i].length != 1) {
          throw FileSystemException("Riga ${i + 1}: risposta corretta assente");
        }

        int asciiValue = lines[i].codeUnitAt(0);
        int value = asciiValue - 65;
        if (value < 0 || value > DEFAULT_ANSWER_NUMBER - 1) {
          throw FileSystemException(
              "Riga ${i + 1}: risposta corretta non valida");
        }

        questions.add(q);
        q.setCorrectAnswerFromInt(value);
        totQuest++;

        if (topicsPresent) numPerTopic++;
      }
    }

    if (topicsPresent) {
      qNumPerTopic.add(numPerTopic);

      // test
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

  @override
  String toString() {
    String res = "";
    for (int i = 0; i < questions.length; i++) {
      res += "Q${i + 1}) " + questions[i].question + "\n";

      for (int j = 0; j < questions[i].answers.length; j++) {
        res +=
            Answer.values[j].toString() + ". " + questions[i].answers[j] + "\n";
      }
      res += "\n";
    }

    return res;
  }
}
