import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';
import 'package:test/test.dart';

Question _q(int id) => Question(
  id: id,
  body: "Q$id",
  topic: "T",
  answers: const ["a", "b", "c"],
  correctAnswer: 0,
);

void main() {
  group('countBlankAnswers', () {
    test('counts only the unanswered (null) questions', () {
      final Quiz quiz = Quiz.fromSnapshot(
        questions: [_q(1), _q(2), _q(3), _q(4)],
        selectedAnswers: [0, null, 2, null],
      );
      expect(quiz.countBlankAnswers(), 2);
    });

    test('is zero when every question is answered', () {
      final Quiz quiz = Quiz.fromSnapshot(
        questions: [_q(1), _q(2)],
        selectedAnswers: [1, 0],
      );
      expect(quiz.countBlankAnswers(), 0);
    });
  });

  group('Quiz constructor', () {
    test('uses the whole pool when questionNum exceeds it, without throwing', () {
      final Quiz quiz = Quiz(
        questions: [_q(1), _q(2), _q(3)],
        questionNum: 10,
        shuffleAnswers: false,
      );
      expect(quiz.questions.length, 3);
      expect(quiz.selectedAnswers.length, 3);
    });

    test('truncates to questionNum when the pool is larger', () {
      final Quiz quiz = Quiz(
        questions: [_q(1), _q(2), _q(3), _q(4), _q(5)],
        questionNum: 3,
        shuffleAnswers: false,
      );
      expect(quiz.questions.length, 3);
      expect(quiz.selectedAnswers.length, 3);
    });

    test('does not throw with shuffleAnswers and an oversized questionNum', () {
      // Growable answer lists (not const) so the shuffle is legal, isolating
      // the former RangeError from the loop bound.
      Question qm(int id) => Question(
        id: id,
        body: "Q$id",
        topic: "T",
        answers: ["a", "b", "c"],
        correctAnswer: 0,
      );
      expect(
        () => Quiz(
          questions: [qm(1), qm(2)],
          questionNum: 8,
          shuffleAnswers: true,
        ),
        returnsNormally,
      );
    });
  });
}
