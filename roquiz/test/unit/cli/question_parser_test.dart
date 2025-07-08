import 'package:roquiz/cli/questions_parser.dart';
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
      expect(questions[0].id, 1);
      expect(questions[0].answers.length, 3);
      expect(questions[0].correctAnswer, 1);
      expect(questions[0].answers[0], "3");
      expect(questions[0].answers[1], "4");
      expect(questions[0].answers[2], "5");
      expect(questions[0].answers[questions[0].correctAnswer], "4");
      expect(questions[0].topic, "Addition");
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
  });

  // group('Test YAML parser', () {});

  // group('Test CLI (main)', () {});
}
