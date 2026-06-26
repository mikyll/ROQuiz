import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/completed_quiz_repository.dart';
import 'package:roquiz/model/utils/statistics.dart';
import 'package:roquiz/model/utils/time.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/grade_badge.dart';

class ViewStatistics extends StatelessWidget {
  final CompletedQuizRepository completedQuizRepository;

  const ViewStatistics({super.key, required this.completedQuizRepository});

  String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/"
      "${d.month.toString().padLeft(2, '0')}/${d.year}";

  @override
  Widget build(BuildContext context) {
    final QuizStatistics stats = QuizStatistics.from(
      completedQuizRepository.quizList,
    );

    return Scaffold(
      appBar: ConstrainedAppBar(
        maxWidth: 500.0,
        title: const Text("Statistiche"),
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: stats.isEmpty
                ? _buildEmptyState(context)
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildSummary(context, stats),
                      const SizedBox(height: 16.0),
                      _buildFinalGrade(context, stats),
                      const SizedBox(height: 16.0),
                      _SectionCard(
                        title: "Andamento voti quiz",
                        subtitle: stats.gradeTrend.length > 1
                            ? "dal ${_formatDate(stats.gradeTrend.first.timestamp)} "
                                  "al ${_formatDate(stats.gradeTrend.last.timestamp)}"
                            : null,
                        child: _TrendChart(points: stats.gradeTrend),
                      ),
                      const SizedBox(height: 16.0),
                      _SectionCard(
                        title: "Distribuzione voti quiz",
                        child: _DistributionChart(
                          buckets: stats.gradeDistribution,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _SectionCard(
                        title: "Argomenti deboli",
                        subtitle: "Precisione per argomento, dal più debole",
                        child: _TopicAccuracyList(
                          topics: stats.topicAccuracies,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64.0,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Nessun quiz completato",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4.0),
          Text(
            "Completa un quiz per vedere le tue statistiche.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, QuizStatistics stats) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.center,
      children: [
        _StatTile(
          label: "Quiz svolti",
          value: Text(
            "${stats.quizCount}",
            style: _valueStyle(context),
          ),
        ),
        _StatTile(
          label: "Voto quiz medio",
          value: Text(
            stats.averageQuizGrade.toStringAsFixed(1),
            style: _valueStyle(context),
          ),
        ),
        _StatTile(
          label: "Voto quiz migliore",
          value: GradeBadge(
            grade: stats.bestQuizGrade.toDouble(),
            gradeBase: 32.0,
            size: 40.0,
          ),
        ),
        _StatTile(
          label: "Risposte corrette",
          value: Text(
            "${(stats.averageScore * 100).round()}%",
            style: _valueStyle(context),
          ),
        ),
        _StatTile(
          label: "Quiz superati",
          value: Text(
            "${(stats.passRate * 100).round()}%",
            style: _valueStyle(context),
          ),
        ),
        _StatTile(
          label: "Quiz perfetti",
          value: Text(
            "${stats.perfectCount}",
            style: _valueStyle(context),
          ),
        ),
        _StatTile(
          label: "Tempo totale",
          value: Text(
            getTimeString(stats.totalTimeSpent),
            style: _valueStyle(context),
          ),
        ),
        _StatTile(
          label: "Tempo medio",
          value: Text(
            getTimeString(stats.averageTimeSpent.round()),
            style: _valueStyle(context),
          ),
        ),
      ],
    );
  }

  /// The estimated final exam grade, summarised over the quizzes that recorded
  /// a written grade. When none did, shows a hint pointing to the setting.
  Widget _buildFinalGrade(BuildContext context, QuizStatistics stats) {
    if (stats.gradedQuizCount == 0) {
      return _SectionCard(
        title: "Voto finale",
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).hintColor,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                "Imposta il voto dello scritto nelle impostazioni per "
                "stimare il voto finale.",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          ],
        ),
      );
    }

    return _SectionCard(
      title: "Voto finale",
      subtitle:
          "su ${stats.gradedQuizCount} "
          "quiz con voto scritto",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                stats.averageFinalGrade.toStringAsFixed(1),
                style: _valueStyle(context),
              ),
              const SizedBox(height: 6.0),
              Text("Medio", style: TextStyle(color: Theme.of(context).hintColor)),
            ],
          ),
          Column(
            children: [
              GradeBadge(grade: stats.bestFinalGrade, size: 40.0),
              const SizedBox(height: 6.0),
              Text(
                "Migliore",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _valueStyle(BuildContext context) => TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.primary,
  );
}

/// Small fixed-width metric card: a bold value over a muted label.
class _StatTile extends StatelessWidget {
  final String label;
  final Widget value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 40.0, child: Center(child: value)),
          const SizedBox(height: 6.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}

/// A titled card wrapping one chart/section.
class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2.0),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
          const SizedBox(height: 16.0),
          child,
        ],
      ),
    );
  }
}

/// Grade-over-time line chart (grades on a fixed 0–32 scale, with a dashed
/// reference line at the pass mark 18).
class _TrendChart extends StatelessWidget {
  final List<GradePoint> points;

  const _TrendChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: CustomPaint(
        size: Size.infinite,
        painter: _TrendPainter(
          grades: [for (final p in points) p.grade],
          lineColor: Theme.of(context).colorScheme.primary,
          passLineColor: Theme.of(context).hintColor,
          labelColor: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<double> grades;
  final Color lineColor;
  final Color passLineColor;
  final Color labelColor;

  static const double _maxGrade = 32.0;
  static const double _passGrade = 18.0;
  static const double _leftPad = 24.0;

  _TrendPainter({
    required this.grades,
    required this.lineColor,
    required this.passLineColor,
    required this.labelColor,
  });

  double _yFor(double grade, double height) =>
      height - (grade / _maxGrade) * height;

  @override
  void paint(Canvas canvas, Size size) {
    final double plotWidth = size.width - _leftPad;
    final double height = size.height;

    // Y-axis labels + faint gridlines at 0, 18 (pass) and 32.
    final Paint grid = Paint()
      ..color = passLineColor.withAlpha(60)
      ..strokeWidth = 1.0;
    for (final double g in [0.0, _passGrade, _maxGrade]) {
      final double y = _yFor(g, height);
      canvas.drawLine(Offset(_leftPad, y), Offset(size.width, y), grid);
      _drawLabel(canvas, g.toStringAsFixed(0), Offset(0, y - 6), labelColor);
    }

    if (grades.isEmpty) return;

    Offset pointAt(int i) {
      final double x = grades.length == 1
          ? _leftPad + plotWidth / 2
          : _leftPad + plotWidth * (i / (grades.length - 1));
      return Offset(x, _yFor(grades[i], height));
    }

    // Line through the points.
    if (grades.length > 1) {
      final Path path = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
      for (int i = 1; i < grades.length; i++) {
        path.lineTo(pointAt(i).dx, pointAt(i).dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = lineColor
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }

    // Dots.
    final Paint dot = Paint()..color = lineColor;
    for (int i = 0; i < grades.length; i++) {
      canvas.drawCircle(pointAt(i), 3.0, dot);
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, Color color) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10.0),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.grades != grades || old.lineColor != lineColor;
}

/// Vertical-bar histogram of the grade buckets.
class _DistributionChart extends StatelessWidget {
  final List<GradeBucket> buckets;

  const _DistributionChart({required this.buckets});

  @override
  Widget build(BuildContext context) {
    final int maxCount = buckets.fold<int>(
      0,
      (m, b) => b.count > m ? b.count : m,
    );

    return SizedBox(
      height: 160.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final bucket in buckets)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _bar(context, bucket, maxCount),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context, GradeBucket bucket, int maxCount) {
    final double factor = maxCount > 0 ? bucket.count / maxCount : 0.0;
    final Color color;
    if (bucket.label == "<18") {
      color = const Color(0xFFE57373); // fail
    } else if (bucket.label == "31-32") {
      color = const Color(0xFF2E7D32); // top score
    } else {
      color = Theme.of(context).colorScheme.primary;
    }

    return Column(
      children: [
        Text(
          "${bucket.count}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: factor == 0 ? 0.0 : factor,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Text(bucket.label, style: const TextStyle(fontSize: 11.0)),
      ],
    );
  }
}

/// List of per-topic accuracy rows, each a label, fraction and progress bar.
class _TopicAccuracyList extends StatelessWidget {
  final List<TopicAccuracy> topics;

  const _TopicAccuracyList({required this.topics});

  Color _accuracyColor(double accuracy) {
    if (accuracy >= 0.9) return const Color(0xFF2E7D32);
    if (accuracy >= 0.6) return const Color(0xFF66BB6A);
    return const Color(0xFFE57373);
  }

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) {
      return Text(
        "Nessun dato disponibile",
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    }

    return Column(
      children: [
        for (final topic in topics)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        topic.topic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "${topic.correct}/${topic.total} "
                      "(${(topic.accuracy * 100).round()}%)",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: LinearProgressIndicator(
                    value: topic.accuracy,
                    minHeight: 8.0,
                    backgroundColor: Theme.of(context).dividerColor,
                    color: _accuracyColor(topic.accuracy),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
