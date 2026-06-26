import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/statistics.dart';
import 'package:test/test.dart';

/// Builds a completed quiz from per-question topics/correct-indices and the
/// user's selections. `correctAnswers` is derived to stay consistent with the
/// selections (so the grade matches what the answers imply).
QuizCompleted _makeQuiz({
  required List<String?> topics,
  required List<int> correctIndices,
  required List<int?> selected,
  required DateTime timestamp,
  int timeSpent = 60,
}) {
  final questions = [
    for (int i = 0; i < topics.length; i++)
      Question(
        id: i + 1,
        body: "Q$i body",
        topic: topics[i],
        answers: const ["a", "b", "c"],
        correctAnswer: correctIndices[i],
      ),
  ];
  int correct = 0;
  for (int i = 0; i < selected.length; i++) {
    if (selected[i] == correctIndices[i]) correct++;
  }
  return QuizCompleted.fromSnapshot(
    questions: questions,
    selectedAnswers: selected,
    timestamp: timestamp,
    timeSpent: timeSpent,
    correctAnswers: correct,
  );
}

void main() {
  group('QuizStatistics.from', () {
    test('empty history yields an empty stats object', () {
      final stats = QuizStatistics.from([]);

      expect(stats.isEmpty, isTrue);
      expect(stats.quizCount, 0);
      expect(stats.gradeTrend, isEmpty);
      expect(stats.gradeDistribution, isEmpty);
      expect(stats.topicAccuracies, isEmpty);
    });

    test('aggregates grades, score, time and lode across quizzes', () {
      // Older quiz: all 3 correct -> grade 32 (lode). Newer quiz: 1/3 -> grade 11.
      final older = _makeQuiz(
        topics: const ["A", "A", "B"],
        correctIndices: const [0, 0, 0],
        selected: const [0, 0, 0],
        timestamp: DateTime(2026, 1, 1),
        timeSpent: 60,
      );
      final newer = _makeQuiz(
        topics: const ["A", "A", "B"],
        correctIndices: const [0, 0, 0],
        selected: const [0, 1, 1],
        timestamp: DateTime(2026, 1, 2),
        timeSpent: 120,
      );

      // Stored newest-first, like the repository.
      final stats = QuizStatistics.from([newer, older]);

      expect(stats.quizCount, 2);
      expect(stats.averageGrade, closeTo((32 + 11) / 2, 0.001));
      expect(stats.bestGrade, 32);
      expect(stats.averageScore, closeTo((1.0 + 1 / 3) / 2, 0.001));
      expect(stats.passRate, 0.5); // only the grade-32 quiz passes
      expect(stats.lodeCount, 1);
      expect(stats.totalTimeSpent, 180);
      expect(stats.averageTimeSpent, 90);
    });

    test('trend is chronological (oldest first)', () {
      final older = _makeQuiz(
        topics: const ["A"],
        correctIndices: const [0],
        selected: const [0],
        timestamp: DateTime(2026, 1, 1),
      );
      final newer = _makeQuiz(
        topics: const ["A"],
        correctIndices: const [0],
        selected: const [1],
        timestamp: DateTime(2026, 1, 2),
      );

      final stats = QuizStatistics.from([newer, older]);

      expect(stats.gradeTrend.first.timestamp, DateTime(2026, 1, 1));
      expect(stats.gradeTrend.first.grade, 32); // older, all correct
      expect(stats.gradeTrend.last.timestamp, DateTime(2026, 1, 2));
      expect(stats.gradeTrend.last.grade, 0); // newer, none correct
    });

    test('distribution buckets are ordered and counted', () {
      final lode = _makeQuiz(
        topics: const ["A"],
        correctIndices: const [0],
        selected: const [0], // grade 32 -> 30L
        timestamp: DateTime(2026, 1, 1),
      );
      final fail = _makeQuiz(
        topics: const ["A", "A", "A"],
        correctIndices: const [0, 0, 0],
        selected: const [0, 1, 1], // 1/3 -> grade 11 -> <18
        timestamp: DateTime(2026, 1, 2),
      );

      final stats = QuizStatistics.from([fail, lode]);

      expect(
        stats.gradeDistribution.map((b) => b.label).toList(),
        kGradeBucketLabels,
      );
      Map<String, int> counts = {
        for (final b in stats.gradeDistribution) b.label: b.count,
      };
      expect(counts["<18"], 1);
      expect(counts["30L"], 1);
      expect(counts["24-27"], 0);
    });

    test('topic accuracy aggregates across quizzes, worst-first', () {
      final q1 = _makeQuiz(
        topics: const ["A", "A", "B"],
        correctIndices: const [0, 0, 0],
        selected: const [0, 0, 0], // A: 2/2, B: 1/1
        timestamp: DateTime(2026, 1, 1),
      );
      final q2 = _makeQuiz(
        topics: const ["A", "A", "B"],
        correctIndices: const [0, 0, 0],
        selected: const [0, 1, 1], // A: 1/2, B: 0/1
        timestamp: DateTime(2026, 1, 2),
      );

      final stats = QuizStatistics.from([q2, q1]);

      // B (1/3 ~ 0.33) is weaker than A (3/4 = 0.75), so it sorts first.
      expect(stats.topicAccuracies.first.topic, "B");
      expect(stats.topicAccuracies.first.correct, 1);
      expect(stats.topicAccuracies.first.total, 2);
      expect(stats.topicAccuracies.last.topic, "A");
      expect(stats.topicAccuracies.last.correct, 3);
      expect(stats.topicAccuracies.last.total, 4);
    });

    test('questions without a topic group under the no-topic label', () {
      final q = _makeQuiz(
        topics: const [null, null],
        correctIndices: const [0, 0],
        selected: const [0, 1],
        timestamp: DateTime(2026, 1, 1),
      );

      final stats = QuizStatistics.from([q]);

      expect(stats.topicAccuracies.length, 1);
      expect(stats.topicAccuracies.first.topic, kNoTopicLabel);
      expect(stats.topicAccuracies.first.correct, 1);
      expect(stats.topicAccuracies.first.total, 2);
    });
  });
}
