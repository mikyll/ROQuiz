import 'package:roquiz/model/quiz/quiz_completed.dart';

/// Label used for questions that carry no [Question.topic].
const String kNoTopicLabel = "Senza argomento";

/// Ordered grade buckets for the distribution histogram. Anything above 30 is
/// cum laude ("30L"); the rest are bucketed by rounded grade.
const List<String> kGradeBucketLabels = ["<18", "18-23", "24-27", "28-30", "30L"];

String _bucketFor(double grade) {
  if (grade > 30.0) return "30L";
  final int r = grade.round();
  if (r < 18) return "<18";
  if (r <= 23) return "18-23";
  if (r <= 27) return "24-27";
  return "28-30";
}

/// One grade recorded at a point in time, for the trend chart.
class GradePoint {
  final DateTime timestamp;
  final double grade;

  const GradePoint(this.timestamp, this.grade);
}

/// A single bar of the grade-distribution histogram.
class GradeBucket {
  final String label;
  final int count;

  const GradeBucket(this.label, this.count);
}

/// How accurately the user answered the questions of one topic, aggregated
/// across every recorded attempt.
class TopicAccuracy {
  final String topic;
  final int correct;
  final int total;

  const TopicAccuracy(this.topic, this.correct, this.total);

  /// Fraction of answered-correctly questions, in `[0, 1]`.
  double get accuracy => total > 0 ? correct / total : 0.0;
}

/// Aggregated statistics over a list of completed quizzes. Pure data: computed
/// once from the history and read by the Statistiche view. All averages are
/// over quizzes (not over questions) unless noted.
class QuizStatistics {
  final int quizCount;
  final double averageGrade;
  final double bestGrade;

  /// Mean per-quiz score (correct / questions), in `[0, 1]`.
  final double averageScore;

  /// Fraction of quizzes graded `>= 18`, in `[0, 1]`.
  final double passRate;

  /// Total / mean time spent, in seconds.
  final int totalTimeSpent;
  final double averageTimeSpent;

  /// Number of attempts graded above 30 (cum laude).
  final int lodeCount;

  /// Grade per attempt, oldest first.
  final List<GradePoint> gradeTrend;

  /// Histogram counts, in [kGradeBucketLabels] order.
  final List<GradeBucket> gradeDistribution;

  /// Per-topic accuracy, worst-first.
  final List<TopicAccuracy> topicAccuracies;

  const QuizStatistics({
    required this.quizCount,
    required this.averageGrade,
    required this.bestGrade,
    required this.averageScore,
    required this.passRate,
    required this.totalTimeSpent,
    required this.averageTimeSpent,
    required this.lodeCount,
    required this.gradeTrend,
    required this.gradeDistribution,
    required this.topicAccuracies,
  });

  bool get isEmpty => quizCount == 0;

  factory QuizStatistics.from(List<QuizCompleted> quizzes) {
    if (quizzes.isEmpty) {
      return const QuizStatistics(
        quizCount: 0,
        averageGrade: 0,
        bestGrade: 0,
        averageScore: 0,
        passRate: 0,
        totalTimeSpent: 0,
        averageTimeSpent: 0,
        lodeCount: 0,
        gradeTrend: [],
        gradeDistribution: [],
        topicAccuracies: [],
      );
    }

    double gradeSum = 0;
    double bestGrade = 0;
    double scoreSum = 0;
    int passCount = 0;
    int totalTime = 0;
    int lodeCount = 0;

    final Map<String, int> bucketCounts = {
      for (final label in kGradeBucketLabels) label: 0,
    };
    // Insertion-ordered so topics keep a stable order before the worst-first sort.
    final Map<String, int> topicCorrect = {};
    final Map<String, int> topicTotal = {};

    for (final QuizCompleted quiz in quizzes) {
      final double grade = quiz.grade;
      gradeSum += grade;
      if (grade > bestGrade) bestGrade = grade;
      if (quiz.questions.isNotEmpty) {
        scoreSum += quiz.correctAnswers / quiz.questions.length;
      }
      if (grade >= 18) passCount++;
      if (grade > 30.0) lodeCount++;
      totalTime += quiz.timeSpent;
      bucketCounts[_bucketFor(grade)] = bucketCounts[_bucketFor(grade)]! + 1;

      for (int i = 0; i < quiz.questions.length; i++) {
        final String topic = quiz.questions[i].topic ?? kNoTopicLabel;
        topicTotal[topic] = (topicTotal[topic] ?? 0) + 1;
        if (quiz.selectedAnswers[i] == quiz.questions[i].correctAnswer) {
          topicCorrect[topic] = (topicCorrect[topic] ?? 0) + 1;
        }
      }
    }

    // Trend oldest-first (history is stored newest-first).
    final List<GradePoint> trend = [
      for (final quiz in quizzes.reversed)
        GradePoint(quiz.timestamp, quiz.grade),
    ];

    final List<TopicAccuracy> topics = [
      for (final entry in topicTotal.entries)
        TopicAccuracy(entry.key, topicCorrect[entry.key] ?? 0, entry.value),
    ]..sort((a, b) => a.accuracy.compareTo(b.accuracy));

    return QuizStatistics(
      quizCount: quizzes.length,
      averageGrade: gradeSum / quizzes.length,
      bestGrade: bestGrade,
      averageScore: scoreSum / quizzes.length,
      passRate: passCount / quizzes.length,
      totalTimeSpent: totalTime,
      averageTimeSpent: totalTime / quizzes.length,
      lodeCount: lodeCount,
      gradeTrend: trend,
      gradeDistribution: [
        for (final label in kGradeBucketLabels)
          GradeBucket(label, bucketCounts[label]!),
      ],
      topicAccuracies: topics,
    );
  }
}
