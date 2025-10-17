import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:roquiz/model/utils/grade.dart';

class Grade extends StatefulWidget {
  final double grade;
  final double gradeBase;
  final bool animate; // TODO
  final Function()? onAnimationFinished;
  final Function()? onTapAfterAnimationFinished;

  const Grade({
    super.key,
    required this.grade,
    required this.gradeBase,
    this.animate = true,
    this.onAnimationFinished,
    this.onTapAfterAnimationFinished,
  }) : assert(
         !(!animate && onAnimationFinished != null),
         "Cannot set onAnimationFinished if the animation is disabled",
       );

  @override
  State<StatefulWidget> createState() => GradeState();
}

class GradeState extends State<Grade> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  final double _maxScale = 4.0;
  bool _show = true;
  bool _tapEnabled = false;

  Color _getTextBorderColor(double grade, double gradeBase) {
    final int roundedGrade = grade.round();

    if (roundedGrade / gradeBase > 0.9) {
      return Colors.orange;
    }

    if (roundedGrade / gradeBase > 0.75) {
      return Colors.blueGrey;
    }

    if (roundedGrade / gradeBase >= 0.6) {
      return Colors.brown;
    }

    if (roundedGrade / gradeBase > 0) {
      return Colors.pink;
    }

    return Colors.black;
  }

  Color _getTextColor(double grade, double gradeBase) {
    final int roundedGrade = grade.round();

    if (roundedGrade / gradeBase > 0.9) {
      return Colors.yellow;
    }

    if (roundedGrade / gradeBase > 0.75) {
      return Colors.grey;
    }

    if (roundedGrade / gradeBase >= 0.6) {
      return const Color.fromARGB(255, 192, 126, 5);
    }

    if (roundedGrade / gradeBase > 0) {
      return Colors.redAccent;
    }

    return const Color.fromARGB(255, 50, 50, 50);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animate ? 1500 : 0),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: _maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.fastEaseInToSlowEaseOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _tapEnabled = true;
        });

        if (widget.onAnimationFinished != null) {
          widget.onAnimationFinished!();
        }
      }
    });

    // Start the animation after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _show
        ? Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            // Stroked text as border.
                            Text(
                              getGradeString(
                                widget.grade,
                                gradeBase: widget.gradeBase,
                              ),
                              style: TextStyle(
                                fontSize: 40,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = _getTextBorderColor(
                                    widget.grade,
                                    widget.gradeBase,
                                  ),
                              ),
                            ),
                            // Solid text as fill.
                            Text(
                              getGradeString(
                                widget.grade,
                                gradeBase: widget.gradeBase,
                              ),
                              style: TextStyle(
                                fontSize: 40,
                                color: _getTextColor(
                                  widget.grade,
                                  widget.gradeBase,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: GestureDetector(
                  onTap: _tapEnabled
                      ? () {
                          if (widget.onTapAfterAnimationFinished != null) {
                            widget.onTapAfterAnimationFinished!();
                          }
                          setState(() {
                            _show = false;
                          });
                        }
                      : null,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
