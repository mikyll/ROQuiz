import 'package:flutter/services.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class QuestionRepository {
  static const int DEFAULT_ANSWER_NUMBER = 5;

  List<String> questions = [];
  List<List<String>> answers = [];
  List<Answer> correctAnswers = [];
  List<String> topics = [];
  List<int> qNumPerTopic = [];
  bool topicsPresent = false;
  int numPerTopic = 0;
  int lineNum = 0;

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
      String fileText = await rootBundle.loadString("assets/domande.txt");
      // print(fileText); // test

      LineSplitter ls = LineSplitter();
      List<String> lines = ls.convert(fileText);

      // the question file is subdivided by topics
      for (int i = 0; i < lines.length; i++) {
        if (i == 0 && lines[i].startsWith("@")) {
          topicsPresent = true;

          topics.add(lines[i].substring(1).replaceAll("=", ""));

          continue;
        }

        // next questions
        if (i > 0 && !lines[i].isEmpty) {
          // next topic
          if (topicsPresent && lines[i].startsWith("@")) {
            qNumPerTopic.add(numPerTopic);
            numPerTopic = 0;

            topics.add(lines[i].substring(1).replaceAll("=", ""));
            i++;
          } else if (lines[i].startsWith("@")) {
            throw FileSystemException(
                "$i divisione per argomenti non rilevata (non è presente l'argomento per le prime domande), ma ne è stato trovato uno comunque");
          }

          questions.add(lines[i]);

          for(int j = 0; j < DEFAULT_ANSWER_NUMBER; j++, lineNum++) {
            answers[i][j] = lines[i]
          }
        }


        lineNum++;
      }

      /*final file = await _localFile;
      final lines = await file
          .openRead()
          .map(utf8.decode)
          .transform(LineSplitter())
          .forEach((l) {
        print(l);
      });*/
    } catch (e) {
      print("Exception: $e");
      return;
    }
  }

  Future<List<String>> getQuestions() async {
    return questions;
  }

  Future<List<List<String>>> getAnswers() async {
    return answers;
  }

  Future<List<Answer>> getCorrectAnswers() async {
    return correctAnswers;
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
