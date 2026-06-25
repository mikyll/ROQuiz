import 'package:flutter/material.dart';
import 'package:roquiz/model/utils/grade.dart';

/// A square badge showing a [grade] on a 30-point scale: green when passed
/// (>= 18), a richer green for top marks (>= 27), red when failed. Cum laude
/// (grade > 30, i.e. "30L") gets a gold gradient, a soft glow and a raised
/// superscript "L".
///
/// Shared by the history list ([ViewHistory]) and the quiz detail
/// ([ViewHistoryQuiz]) so the grade reads the same in both places.
class GradeBadge extends StatelessWidget {
  final double grade;

  /// Side length of the square badge. The grade label scales with it so the
  /// badge stays legible at different sizes.
  final double size;

  const GradeBadge({super.key, required this.grade, this.size = 48.0});

  /// Badge fill/text colors for [grade], on a 30-point scale.
  ({Color background, Color foreground}) _gradeBadgeColors(double grade) {
    const double gradeBase = 30.0;
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
    final bool isLode = grade > 30.0;
    final badge = _gradeBadgeColors(grade);

    final double fontSize = size * (20.0 / 48.0);

    final Widget label = isLode
        ? Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "30"),
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
            getGradeString(grade),
            style: TextStyle(
              color: badge.foreground,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );

    return Container(
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
  }
}
