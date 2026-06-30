import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roquiz/model/utils/grade.dart';

class ResultCard extends StatefulWidget {
  final int correctAnswers;
  final int questionNum;
  final int? writtenGrade;
  final int quizGrade;
  final double? totalGrade;
  final (double, double)? totalGradeRange;
  final String timerString;

  /// Called when the user taps the "set your written grade" hint shown while no
  /// written grade is set. When null the hint isn't shown.
  final VoidCallback? onSetWrittenGrade;

  const ResultCard({
    super.key,
    required this.correctAnswers,
    required this.questionNum,
    this.writtenGrade,
    required this.quizGrade,
    this.totalGrade,
    this.totalGradeRange,
    required this.timerString,
    this.onSetWrittenGrade,
  }) : assert(
         !(totalGrade == null && totalGradeRange == null),
         "At least one of totalGrade and totalGradeRange must be set.",
       ),
       assert(
         !(totalGrade != null && totalGradeRange != null),
         "totalGrade and totalGradeRange cannot be set both at the same time.",
       );

  @override
  State<StatefulWidget> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    String tooltipMessage =
        "Il voto finale è calcolato come segue:\n"
        "(voto_scritto * 2/3) + (voto_quiz * 1/3)\n\n"
        "Entrambe le prove sono in 30esimi, ma è possibile ottenere punti "
        "extra e arrivare a 32. La lode viene assegnata se il totale supera 30.";

    if (widget.writtenGrade == null) {
      tooltipMessage +=
          "\n\nPer avere una valutazione precisa, inserisci il "
          "voto della prova scritta nelle impostazioni.";
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 320.0),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 100 * _controller.value),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: BoxBorder.all(width: 2, color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).disabledColor,
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 70.0,
                          vertical: 25.0,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text("Risposte corrette: ")),
                                  Text(
                                    "${widget.correctAnswers}/${widget.questionNum}",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Voto scritto: ")),
                                  Text(widget.writtenGrade.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Voto quiz: ")),
                                  Text(
                                    "${widget.quizGrade.toString()} (${min(widget.quizGrade / 30 * 100, 100).round()}%)",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Tempo: ")),
                                  Text(widget.timerString),
                                ],
                              ),
                              const SizedBox(height: 15.0),
                              if (widget.totalGrade != null)
                                Text(
                                  "Voto finale: ${getGradeString(widget.totalGrade!)} (${widget.totalGrade!.toStringAsFixed(1)})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              // TODO: style (bold, etc.)
                              if (widget.totalGradeRange != null)
                                Text(
                                  "Range voto finale: [${widget.totalGradeRange!.$1.toStringAsFixed(0)},"
                                  "${widget.totalGradeRange!.$2.toStringAsFixed(0)}]",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              // TODO: style (bold, etc.)
                              if (widget.writtenGrade == null &&
                                  widget.onSetWrittenGrade != null) ...[
                                const SizedBox(height: 12.0),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.0),
                                    onTap: widget.onSetWrittenGrade,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 18.0,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          const SizedBox(width: 6.0),
                                          Flexible(
                                            child: Text(
                                              "Imposta il voto dello scritto "
                                              "per stimare il voto finale.",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Theme.of(
                                                  context,
                                                ).hintColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Tooltip(
                        textAlign: TextAlign.center,
                        margin: EdgeInsets.all(5.0),
                        constraints: BoxConstraints(maxWidth: 300.0),
                        message: tooltipMessage,
                        child: IconButton.filled(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.help, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
