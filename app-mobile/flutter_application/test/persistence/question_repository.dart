import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:test/test.dart';

void main() {
  group("Load QuestionRepository from file (.txt)", () {
    WidgetsFlutterBinding.ensureInitialized();

    test("Correct", () async {
      // Load questions file
      String content = await rootBundle.loadString("assets/domande.txt");
      expect(content.trim().isNotEmpty, true);

      final QuestionRepository qRepo = QuestionRepository();
      qRepo.parseFromTxt(content);

      expect(qRepo.error, "");
      expect(qRepo.questions.isNotEmpty, true);
      expect(qRepo.questions.length, greaterThanOrEqualTo(100));
      expect(qRepo.topics.length, 6);
    });

    test("Empty file", () async {
      String content = "";

      final QuestionRepository qRepo = QuestionRepository();

      expect(
          () => qRepo.parseFromTxt(content), throwsA(isA<FormatException>()));
      expect(() {
        return qRepo.parseFromTxt(content);
      }, throwsA(isA<FormatException>()));
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(
              predicate((e) => e.toString() == 'FormatException: File vuoto')));
    });

    test("Questions with no topic", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
C. Answer 3
D. Answer 4
E. Answer 5
C

Question 2
A. Answer 1
B. Answer 2
C. Answer 3
D. Answer 4
E. Answer 5
D
      """;

      final QuestionRepository qRepo = QuestionRepository();
      qRepo.parseFromTxt(content);

      expect(qRepo.questions.length, 2);
      expect(qRepo.topics.length, 0);
    });

    test("Questions with different number of answers", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
A

Question 2
A. Answer 1
B. Answer 2
C. Answer 3
B
      """;

      final QuestionRepository qRepo = QuestionRepository();
      qRepo.parseFromTxt(content);

      expect(qRepo.questions.length, 2);
      expect(qRepo.topics.length, 0);
    });

    test("Questions with topic error", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
A

@ topic-name =================
Question 2
A. Answer 1
B. Answer 2
B
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains(
                  "errore argomenti! E' stato trovato un argomento ma sono gia' presenti domande senza"))));
    });

    test("File end before reading all answers", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
C. Answer 3
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains(
                  "fine del file prima della lettura di tutte le risposte"))));
    });

    test("Empty answer line", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
C. Answer 3

Question 2
A. Answer 1
B. Answer 2
A
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains("risposta vuota"))));
    });

    test("Wrong answer format", () async {
      String content = """
Question 1
A Answer 1
B. Answer 2
C. Answer 3
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains("formattata male"))));
    });

    test("Wrong answer format (2)", () async {
      String content = """
Question 1
A A.nswer 1
B. Answer 2
C. Answer 3
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains("formattata male"))));
    });

    test("End of file before correct answer", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
C. Answer 3
D. Answer 4
E. Answer 5
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains(
                  "fine del file prima della lettura della risposta corretta"))));
    });

    test("Missing correct answer", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
C. Answer 3
D. Answer 4
E. Answer 5

Question 1
A. Answer 1
B. Answer 2
C. Answer 3
A
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains("risposta corretta assente"))));
    });

    test("Not enough answers", () async {
      String content = """
Question 1
A. Answer 1
A
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains("non sono ammesse domande con meno di"))));
    });

    test("Invalid correct answer (out of range)", () async {
      String content = """
Question 1
A. Answer 1
B. Answer 2
C. Answer 3
D. Answer 4
F
      """;

      final QuestionRepository qRepo = QuestionRepository();
      expect(
          () => qRepo.parseFromTxt(content),
          throwsA(predicate((e) =>
              e is FormatException &&
              e.toString().contains(
                  "la risposta corretta dev'essere una delle risposte presenti"))));
    });
  });
}
