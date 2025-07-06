import 'package:flutter/material.dart';
import 'package:roquiz/cli/questions_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Test TXT parser', () {
    test('Single question', () {
      const String fileContent = '''
What is 2+2?
A. 3
B. 4
C. 5
D. 6
E. 7
B''';

      final questions = parseQuestionsFromTxt(fileContent, 5);

      expect(questions.length, 1);
      expect(questions[0].getId(), 1);
      expect(questions[0].getId(), 1);
    });

    test('Missing body', () {
      const String fileContent = '''

A''';
    });
  });

  group('Test YAML parser', () {});

  group('Test CLI (main)', () {});
}
