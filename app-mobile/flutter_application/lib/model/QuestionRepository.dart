import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class QuestionRepository {
  static const int DEFAULT_ANSWER_NUMBER = 5;

  List<Question> questions = [];
  List<String> topics = [];
  List<int> qNumPerTopic = [];
  bool topicsPresent = false;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/assets/domande.txt');
  }

  Future<void> loadFile() async {
    try {
      int numPerTopic = 0, totQuest = 0;
      String fileText = await rootBundle.loadString("assets/domande.txt");
      // print(fileText); // test

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
            throw FileSystemException(
                "Riga ${i + 1}: risposta corretta assente");
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
        print("Argomenti: ");
        for (int i = 0; i < qNumPerTopic.length; i++) {
          print("- ${topics[i]} (num domande: ${qNumPerTopic[i].toString()})");
        }
      }
    } catch (e) {
      print("Exception: $e");
      return;
    }
  }

  Future<List<Question>> getQuestions() async {
    return questions;
  }

  Future<List<String>> getTopics() async {
    return topics;
  }

  Future<List<int>> getQuestionNumPerTopic() async {
    return qNumPerTopic;
  }

  /*late List<Question> questions;
  late List<String> topics;
  late List<int> questionsPerTopic; // how many questions are in a topic

  QuestionRepository(String filename) {
    final file = File(filename);
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(LineSplitter());
      try {
        await for (String l in lines) {
          
        }
      }
      catch (e) {
        print("Error: $e");
      }
  }*/

}
