import 'package:roquiz/model/quiz/question_parser.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:test/test.dart';

/// Guards the save path used to persist user-edited questions: the working set
/// is serialized with [Question.toYaml] and must parse back identically via
/// [parseQuestionsFromYaml]. A lossy round-trip would silently corrupt or drop
/// edits on the next launch (the repository falls back to the bundled asset
/// when its saved copy can't be parsed).
void main() {
  String serialize(List<Question> questions) =>
      questions.map((q) => q.toYaml()).join("\n");

  void expectRoundTrips(List<Question> original) {
    final reparsed = parseQuestionsFromYaml(serialize(original));
    expect(reparsed.length, original.length);
    for (int i = 0; i < original.length; i++) {
      expect(reparsed[i].body, original[i].body, reason: "body #$i");
      expect(reparsed[i].topic, original[i].topic, reason: "topic #$i");
      expect(reparsed[i].answers, original[i].answers, reason: "answers #$i");
      expect(
        reparsed[i].correctAnswer,
        original[i].correctAnswer,
        reason: "correctAnswer #$i",
      );
      // null/false both mean "default"; only the custom flag must survive.
      expect(
        reparsed[i].isCustom == true,
        original[i].isCustom == true,
        reason: "isCustom #$i",
      );
    }
  }

  group('Question YAML round-trip', () {
    test('plain content', () {
      expectRoundTrips([
        Question(
          id: 0,
          topic: "Math",
          body: "What is 2+2?",
          answers: ["3", "4", "5"],
          correctAnswer: 1,
        ),
      ]);
    });

    test('custom flag survives', () {
      expectRoundTrips([
        Question(
          id: 0,
          topic: "Math",
          body: "A user-added question",
          answers: ["yes", "no"],
          correctAnswer: 0,
          isCustom: true,
        ),
        Question(
          id: 1,
          topic: "Math",
          body: "A default question",
          answers: ["yes", "no"],
          correctAnswer: 1,
        ),
      ]);
    });

    test('answer containing a colon-space (map-like)', () {
      expectRoundTrips([
        Question(
          id: 0,
          topic: "Programmazione Matematica",
          body: "Cos'è un intorno?",
          answers: [
            "Una funzione N: F -> 2^F",
            "Ciò non è possibile: solo le matrici quadrate sono unimodulari",
            "Nessuna di queste",
          ],
          correctAnswer: 0,
        ),
      ]);
    });

    test('quotes, colons and special chars in topic/body/answers', () {
      expectRoundTrips([
        Question(
          id: 0,
          topic: 'Topic: with "quotes"',
          body: 'He said "hello": now what?',
          answers: [
            '- starts with a dash',
            '#hashtag start',
            'has: colon and "quotes"',
            "trailing space ",
          ],
          correctAnswer: 2,
        ),
      ]);
    });
  });
}
