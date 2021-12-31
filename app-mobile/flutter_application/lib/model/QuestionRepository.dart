import 'package:flutter/services.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class QuestionRepository {
  late List<String> questions;
  late List<List<String>> answers;
  late List<Answer> correctAnswers;

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
      print(fileText);
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
