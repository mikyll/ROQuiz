import 'package:roquiz/model/quiz/quiz_completed.dart';

/// Label used for questions that carry no [Question.topic].
const String kNoTopicLabel = "Senza argomento";

/// Ordered grade buckets for the distribution histogram, on the quiz-grade
/// scale (0–32; a perfect score reaches 32, so the top bucket is "31-32").
const List<String> kGradeBucketLabels = ["<18", "18-23", "24-27", "28-30", "31-32"];

String _bucketFor(int grade) {
  if (grade < 18) return "<18";
  if (grade <= 23) return "18-23";
  if (grade <= 27) return "24-27";
  if (grade <= 30) return "28-30";
  return "31-32";
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
/// once from the history and read by the Statistiche view.
///
/// The headline grade metrics are based on the **quiz-only grade** (0–32),
/// which every quiz has, so they stay comparable regardless of whether a
/// written grade was set. The estimated **final** exam grade
/// ([calculateTotalGrade]) is only meaningful when a written grade was
/// recorded, so it is summarised separately over that subset (see
/// [gradedQuizCount] / [averageFinalGrade]). All averages are over quizzes
/// (not over questions) unless noted.
class QuizStatistics {
  final int quizCount;

  /// Mean / best quiz-only grade (0–32).
  final double averageQuizGrade;
  final int bestQuizGrade;

  /// Mean per-quiz score (correct / questions), in `[0, 1]`.
  final double averageScore;

  /// Fraction of quizzes with a quiz grade `>= 18`, in `[0, 1]`.
  final double passRate;

  /// Total / mean time spent, in seconds.
  final int totalTimeSpent;
  final double averageTimeSpent;

  /// Number of quizzes answered perfectly (quiz grade 32 / all correct).
  final int perfectCount;

  /// How many quizzes had a written grade recorded, and the mean / best
  /// estimated *final* grade over just those. Zero when none.
  final int gradedQuizCount;
  final double averageFinalGrade;
  final double bestFinalGrade;

  /// Quiz grade per attempt, oldest first.
  final List<GradePoint> gradeTrend;

  /// Histogram counts, in [kGradeBucketLabels] order.
  final List<GradeBucket> gradeDistribution;

  /// Per-topic accuracy, worst-first.
  final List<TopicAccuracy> topicAccuracies;

  const QuizStatistics({
    required this.quizCount,
    required this.averageQuizGrade,
    required this.bestQuizGrade,
    required this.averageScore,
    required this.passRate,
    required this.totalTimeSpent,
    required this.averageTimeSpent,
    required this.perfectCount,
    required this.gradedQuizCount,
    required this.averageFinalGrade,
    required this.bestFinalGrade,
    required this.gradeTrend,
    required this.gradeDistribution,
    required this.topicAccuracies,
  });

  bool get isEmpty => quizCount == 0;

  factory QuizStatistics.from(List<QuizCompleted> quizzes) {
    if (quizzes.isEmpty) {
      return const QuizStatistics(
        quizCount: 0,
        averageQuizGrade: 0,
        bestQuizGrade: 0,
        averageScore: 0,
        passRate: 0,
        totalTimeSpent: 0,
        averageTimeSpent: 0,
        perfectCount: 0,
        gradedQuizCount: 0,
        averageFinalGrade: 0,
        bestFinalGrade: 0,
        gradeTrend: [],
        gradeDistribution: [],
        topicAccuracies: [],
      );
    }

    int gradeSum = 0;
    int bestQuizGrade = 0;
    double scoreSum = 0;
    int passCount = 0;
    int totalTime = 0;
    int perfectCount = 0;

    int gradedCount = 0;
    double finalGradeSum = 0;
    double bestFinalGrade = 0;

    final Map<String, int> bucketCounts = {
      for (final label in kGradeBucketLabels) label: 0,
    };
    // Insertion-ordered so topics keep a stable order before the worst-first sort.
    final Map<String, int> topicCorrect = {};
    final Map<String, int> topicTotal = {};

    for (final QuizCompleted quiz in quizzes) {
      final int quizGrade = quiz.quizGrade;
      gradeSum += quizGrade;
      if (quizGrade > bestQuizGrade) bestQuizGrade = quizGrade;
      if (quiz.questions.isNotEmpty) {
        scoreSum += quiz.correctAnswers / quiz.questions.length;
      }
      if (quizGrade >= 18) passCount++;
      if (quiz.questions.isNotEmpty &&
          quiz.correctAnswers == quiz.questions.length) {
        perfectCount++;
      }
      totalTime += quiz.timeSpent;
      bucketCounts[_bucketFor(quizGrade)] =
          bucketCounts[_bucketFor(quizGrade)]! + 1;

      // Final grade only makes sense when a written grade was recorded; then
      // [QuizCompleted.grade] is the estimated total.
      if (quiz.writtenGrade != null) {
        gradedCount++;
        final double finalGrade = quiz.grade;
        finalGradeSum += finalGrade;
        if (finalGrade > bestFinalGrade) bestFinalGrade = finalGrade;
      }

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
        GradePoint(quiz.timestamp, quiz.quizGrade.toDouble()),
    ];

    final List<TopicAccuracy> topics = [
      for (final entry in topicTotal.entries)
        TopicAccuracy(entry.key, topicCorrect[entry.key] ?? 0, entry.value),
    ]..sort((a, b) => a.accuracy.compareTo(b.accuracy));

    return QuizStatistics(
      quizCount: quizzes.length,
      averageQuizGrade: gradeSum / quizzes.length,
      bestQuizGrade: bestQuizGrade,
      averageScore: scoreSum / quizzes.length,
      passRate: passCount / quizzes.length,
      totalTimeSpent: totalTime,
      averageTimeSpent: totalTime / quizzes.length,
      perfectCount: perfectCount,
      gradedQuizCount: gradedCount,
      averageFinalGrade: gradedCount > 0 ? finalGradeSum / gradedCount : 0,
      bestFinalGrade: bestFinalGrade,
      gradeTrend: trend,
      gradeDistribution: [
        for (final label in kGradeBucketLabels)
          GradeBucket(label, bucketCounts[label]!),
      ],
      topicAccuracies: topics,
    );
  }
}
