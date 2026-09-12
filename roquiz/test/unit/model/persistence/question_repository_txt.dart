// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:roquiz/model/persistence/question_repository.dart';
// import 'package:test/test.dart';

// void main() {
//   group("Load QuestionRepository from file:", () {
//     WidgetsFlutterBinding.ensureInitialized();

//     test("Correct", () async {
//       // Load questions file
//       final QuestionRepository qRepo = QuestionRepository();
//       qRepo.load().then((_) {
//         expect(qRepo.error, "");
//         expect(qRepo.getQuestions().isNotEmpty, true);
//         expect(qRepo.getQuestions().length, greaterThanOrEqualTo(100));
//         expect(qRepo.getTopics().length, 6);
//       });
//     });

//     test("Empty file", () async {
//       String content = "";

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(isA<FormatException>()),
//       );
//       expect(() {
//         return QuestionRepository.parseFromTxt(content);
//       }, throwsA(isA<FormatException>()));
//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate((e) => e.toString() == 'FormatException: File vuoto'),
//         ),
//       );
//     });

//     test("Questions with no topic", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3
// D. Answer 4
// E. Answer 5
// C

// Question 2
// A. Answer 1
// B. Answer 2
// C. Answer 3
// D. Answer 4
// E. Answer 5
// D
//       """;

//       final QuestionRepository qRepo = QuestionRepository();
//       qRepo.loadFromTxt(content);

//       expect(qRepo.getQuestions().length, 2);
//       expect(qRepo.getTopics().length, 0);
//     });

//     test("Questions with different number of answers", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// A

// Question 2
// A. Answer 1
// B. Answer 2
// C. Answer 3
// B
//       """;

//       final QuestionRepository qRepo = QuestionRepository();
//       qRepo.loadFromTxt(content);

//       expect(qRepo.getQuestions().length, 2);
//       expect(qRepo.getTopics().length, 0);
//     });

//     test("Questions with topic error", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// A

// @ topic-name =================
// Question 2
// A. Answer 1
// B. Answer 2
// B
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains(
//                   "errore argomenti! E' stato trovato un argomento ma sono gia' presenti domande senza",
//                 ),
//           ),
//         ),
//       );
//     });

//     test("File end before reading all answers", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains(
//                   "fine del file prima della lettura di tutte le risposte",
//                 ),
//           ),
//         ),
//       );
//     });

//     test("Empty answer line", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3

// Question 2
// A. Answer 1
// B. Answer 2
// A
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException && e.toString().contains("risposta vuota"),
//           ),
//         ),
//       );
//     });

//     test("Wrong answer format", () async {
//       String content = """
// Question 1
// A Answer 1
// B. Answer 2
// C. Answer 3
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains("formattata male"),
//           ),
//         ),
//       );
//     });

//     test("Wrong answer format (2)", () async {
//       String content = """
// Question 1
// A A.nswer 1
// B. Answer 2
// C. Answer 3
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains("formattata male"),
//           ),
//         ),
//       );
//     });

//     test("End of file before correct answer", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3
// D. Answer 4
// E. Answer 5
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains(
//                   "fine del file prima della lettura della risposta corretta",
//                 ),
//           ),
//         ),
//       );
//     });

//     test("Missing correct answer", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3
// D. Answer 4
// E. Answer 5

// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3
// A
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains("risposta corretta assente"),
//           ),
//         ),
//       );
//     });

//     test("Not enough answers", () async {
//       String content = """
// Question 1
// A. Answer 1
// A
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains("non sono ammesse domande con meno di"),
//           ),
//         ),
//       );
//     });

//     test("Invalid correct answer (out of range)", () async {
//       String content = """
// Question 1
// A. Answer 1
// B. Answer 2
// C. Answer 3
// D. Answer 4
// F
//       """;

//       expect(
//         () => QuestionRepository.parseFromTxt(content),
//         throwsA(
//           predicate(
//             (e) =>
//                 e is FormatException &&
//                 e.toString().contains(
//                   "la risposta corretta dev'essere una delle risposte presenti",
//                 ),
//           ),
//         ),
//       );
//     });
//   });
// }
