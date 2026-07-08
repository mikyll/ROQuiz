import 'package:roquiz/model/quiz/question_parser.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:test/test.dart';

void main() {
  group('Values', () {
    test('Correct question', () {
      Question question = Question(
        id: 1,
        body: "What is 2+2?",
        topic: "Addition",
        answers: ["3", "4", "5"],
        correctAnswer: 1,
      );

      expect(question.id, 1);
      expect(question.answers.length, 3);
      expect(question.correctAnswer, 1);
      expect(question.answers[0], "3");
      expect(question.answers[1], "4");
      expect(question.answers[2], "5");
      expect(question.answers[question.correctAnswer], "4");
      expect(question.topic, "Addition");
      expect(
        question.toString().trim(),
        '''
Topic: Addition
Q1: What is 2+2?
A. 3
B. 4
C. 5
B
'''
            .trim(),
      );
      expect(
        question.toYaml().trim(),
        '''
- body: "What is 2+2?"
  topic: "Addition"
  answers:
    - "3"
    - "4"
    - "5"
  correct_answer: 1
'''
            .trim(),
      );
    });

    test('Correct question with no topic', () {
      Question question = Question(
        id: 1,
        body: "What is 2+2?",
        topic: null,
        answers: ["3", "4", "5"],
        correctAnswer: 1,
      );

      expect(question.id, 1);
      expect(question.answers.length, 3);
      expect(question.correctAnswer, 1);
      expect(question.answers[0], "3");
      expect(question.answers[1], "4");
      expect(question.answers[2], "5");
      expect(question.answers[question.correctAnswer], "4");
      expect(question.topic, null);
      expect(
        question.toString().trim(),
        '''
Q1: What is 2+2?
A. 3
B. 4
C. 5
B
'''
            .trim(),
      );
      expect(
        question.toYaml().trim(),
        '''
- body: "What is 2+2?"
  answers:
    - "3"
    - "4"
    - "5"
  correct_answer: 1
'''
            .trim(),
      );
    });

    test('Second constructor', () {
      Question question = Question(
        id: 1,
        body: "What is 2+2?",
        topic: null,
        answers: ["3", "4", "5"],
        correctAnswer: 1,
      );

      expect(question.id, 1);
      expect(question.answers.length, 3);
      expect(question.correctAnswer, 1);
      expect(question.answers[0], "3");
      expect(question.answers[1], "4");
      expect(question.answers[2], "5");
      expect(question.answers[question.correctAnswer], "4");
      expect(question.topic, null);
    });
  });

  group('Exceptions', () {
    // invalid ID

    test('Exception: topic error', () {
      const String fileContent = '''
What is 2+2?
A. 3
B. 4
C. 5
B

@ Multiplication ==========
What is 2*3?
A. 3
B. 4
C. 5
D. 6
E. 7
D''';
      expect(
        () => parseQuestionsFromTxt(fileContent),
        throwsA(isA<FormatException>()),
      );
    });

    // empty body

    // not enough answers

    // invalid ID
  });
}
