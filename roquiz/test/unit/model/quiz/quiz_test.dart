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
}
