import 'package:flutter/material.dart';
import 'package:roquiz/model/utils/grade.dart';

/// A square badge showing a [grade] on a [gradeBase]-point scale: green when
/// passed (>= 60%), a richer green for top marks (>= 90%), red when failed.
/// Grades above [gradeBase] are cum laude (e.g. "30L" on the default 30-point
/// scale) and get a gold gradient, a soft glow and a raised superscript "L".
///
/// [gradeBase] defaults to 30 (the final-exam scale, where above-30 is lode);
/// pass 32 for a quiz-only grade so a perfect 32 reads as "32", not "30L".
///
/// Shared by the history list ([ViewHistory]), the quiz detail
/// ([ViewHistoryQuiz]) and the statistics view so the grade reads the same.
class GradeBadge extends StatelessWidget {
  final double grade;

  /// Top of the grading scale. Grades above it are treated as cum laude.
  final double gradeBase;

  /// Side length of the square badge. The grade label scales with it so the
  /// badge stays legible at different sizes.
  final double size;

  /// When true the badge is rendered muted (partially desaturated), signalling
  /// a *provisional* grade — e.g. a quiz-only grade shown while no written
  /// grade is set, so it doesn't read as a final pass/fail result.
  final bool desaturated;

  const GradeBadge({
    super.key,
    required this.grade,
    this.gradeBase = 30.0,
    this.size = 48.0,
    this.desaturated = false,
  });

  /// A saturation [ColorFilter] (1 = unchanged, 0 = greyscale) using the
  /// standard luminance weights, applied to the whole badge when [desaturated].
  static const ColorFilter _mutedFilter = ColorFilter.matrix(<double>[
    0.578, 0.464, 0.047, 0, 0, // 0.35 saturation
    0.138, 0.904, 0.047, 0, 0,
    0.138, 0.464, 0.487, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  /// Badge fill/text colors for [grade], relative to [gradeBase].
  ({Color background, Color foreground}) _gradeBadgeColors(double grade) {
    final double ratio = grade / gradeBase;
    if (ratio >= 0.9) {
      return (background: const Color(0xFF2E7D32), foreground: Colors.white);
    }
    if (ratio >= 0.6) {
      return (background: const Color(0xFF66BB6A), foreground: Colors.white);
    }
    return (background: const Color(0xFFE57373), foreground: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLode = grade > gradeBase;
    final badge = _gradeBadgeColors(grade);

    final double fontSize = size * (20.0 / 48.0);

    final Widget label = isLode
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(text: gradeBase.toStringAsFixed(0)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Transform.translate(
                    offset: const Offset(1.0, -1.0),
                    child: Text(
                      "L",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 0.6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            getGradeString(grade, gradeBase: gradeBase),
            style: TextStyle(
              color: badge.foreground,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );

    final Widget badgeWidget = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isLode ? null : badge.background,
        gradient: isLode
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFC107), Color(0xFFEF6C00)],
              )
            : null,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: isLode
            ? [
                BoxShadow(
                  color: const Color(0xFFFFC107).withAlpha(140),
                  blurRadius: 8.0,
                  spreadRadius: 0.5,
                ),
              ]
            : null,
      ),
      child: label,
    );

    return desaturated
        ? ColorFiltered(colorFilter: _mutedFilter, child: badgeWidget)
        : badgeWidget;
  }
}
