import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/question_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Test TXT parser', () {
    test('Single question', () {
      const String fileContent = '''
@ Addition ==========
What is 2+2?
A. 3
B. 4
C. 5
B''';

      final questions = parseQuestionsFromTxt(fileContent);

      expect(questions.length, 1);
      expect(questions[0].id, 0);
      expect(questions[0].answers.length, 3);
      expect(questions[0].correctAnswer, 1);
      expect(questions[0].answers[0], "3");
      expect(questions[0].answers[1], "4");
      expect(questions[0].answers[2], "5");
      expect(questions[0].answers[questions[0].correctAnswer], "4");
      expect(questions[0].topic, "Addition");
    });

    test('Multiple questions have sequential 0-based ids', () {
      const String fileContent = '''
@ Math ==========
What is 2+2?
A. 3
B. 4
B
What is 2*3?
A. 5
B. 6
B''';

      final questions = parseQuestionsFromTxt(fileContent);

      expect(questions.length, 2);
      expect(questions[0].id, 0);
      expect(questions[1].id, 1);
    });

    test('No topic', () {
      const String fileContent = '''
What is 2+2?
A. 3
B. 4
C. 5
B''';

      final questions = parseQuestionsFromTxt(fileContent);
      expect(questions[0].topic, null);
    });

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

    test('Exception: empty file', () {
      expect(
        () => parseQuestionsFromTxt("   \n  \n"),
        throwsA(isA<FormatException>()),
      );
    });

    test('Exception: missing correct answer', () {
      const String fileContent = '''
What is 2+2?
A. 3
B. 4''';
      expect(
        () => parseQuestionsFromTxt(fileContent),
        throwsA(isA<FormatException>()),
      );
    });

    test('Exception: wrong answer letter/order', () {
      const String fileContent = '''
What is 2+2?
A. 3
C. 4
B''';
      expect(
        () => parseQuestionsFromTxt(fileContent),
        throwsA(isA<FormatException>()),
      );
    });

    test('Exception: duplicated topic', () {
      const String fileContent = '''
@ Math ==========
What is 2+2?
A. 3
B. 4
B
@ Math ==========
What is 2*3?
A. 5
B. 6
B''';
      expect(
        () => parseQuestionsFromTxt(fileContent),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Test YAML parser', () {
    test('Single question (int correct_answer)', () {
      const String fileContent = '''
- body: "What is 2+2?"
  topic: "Addition"
  answers:
    - "3"
    - "4"
    - "5"
  correct_answer: 1
''';

      final questions = parseQuestionsFromYaml(fileContent);

      expect(questions.length, 1);
      expect(questions[0].id, 0);
      expect(questions[0].body, "What is 2+2?");
      expect(questions[0].topic, "Addition");
      expect(questions[0].answers, ["3", "4", "5"]);
      expect(questions[0].correctAnswer, 1);
      expect(questions[0].isCustom, null);
    });

    test('custom flag is parsed', () {
      const String fileContent = '''
- body: "What is 2+2?"
  answers:
    - "3"
    - "4"
  correct_answer: 1
  custom: true
''';

      final questions = parseQuestionsFromYaml(fileContent);
      expect(questions[0].isCustom, true);
    });

    test('Exception: not a list', () {
      const String fileContent = 'body: "not a list"';
      expect(
        () => parseQuestionsFromYaml(fileContent),
        throwsA(isA<FormatException>()),
      );
    });

    test('Exception: element is not a map', () {
      const String fileContent = '''
- "just a string"
''';
      expect(
        () => parseQuestionsFromYaml(fileContent),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('inferQuestionFormat', () {
    const String txt = '''
What is 2+2?
A. 3
B. 4
B''';

    const String yaml = '''
- body: "What is 2+2?"
  answers:
    - "3"
    - "4"
  correct_answer: 1
''';

    test('detects txt', () {
      expect(inferQuestionFormat(txt), QuestionFormat.txt);
    });

    test('detects yaml', () {
      expect(inferQuestionFormat(yaml), QuestionFormat.yaml);
    });

    test('returns null for garbage', () {
      expect(inferQuestionFormat("!!! not a question file !!!"), null);
    });

    test('returns null for empty', () {
      expect(inferQuestionFormat(""), null);
    });
  });

  group('getTopicSizes', () {
    test('counts questions per topic', () {
      final questions = [
        Question(
          id: 0,
          body: "q0",
          topic: "A",
          answers: ["x", "y"],
          correctAnswer: 0,
        ),
        Question(
          id: 1,
          body: "q1",
          topic: "A",
          answers: ["x", "y"],
          correctAnswer: 0,
        ),
        Question(
          id: 2,
          body: "q2",
          topic: "B",
          answers: ["x", "y"],
          correctAnswer: 0,
        ),
      ];

      expect(getTopicSizes(questions), {"A": 2, "B": 1});
    });

    test('returns empty when questions have no topic', () {
      final questions = [
        Question(
          id: 0,
          body: "q0",
          topic: null,
          answers: ["x", "y"],
          correctAnswer: 0,
        ),
      ];

      expect(getTopicSizes(questions), isEmpty);
    });
  });
}
