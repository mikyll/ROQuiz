import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roquiz/model/utils/utils.dart';

class ResultCard extends StatelessWidget {
  final int correctAnswers;
  final int questionNum;
  final int? writtenGrade;
  final int quizGrade;
  final double? totalGrade;
  final (double, double)? totalGradeRange;
  final String timerString;

  const ResultCard({
    super.key,
    required this.correctAnswers,
    required this.questionNum,
    this.writtenGrade,
    required this.quizGrade,
    this.totalGrade,
    this.totalGradeRange,
    required this.timerString,
  }) : assert(
         !(totalGrade == null && totalGradeRange == null),
         "At least one of totalGrade and totalGradeRange must be set.",
       ),
       assert(
         !(totalGrade != null && totalGradeRange != null),
         "totalGrade and totalGradeRange cannot be set both at the same time.",
       );

  @override
  Widget build(BuildContext context) {
    String tooltipMessage =
        "Il voto finale è calcolato come segue:\n"
        "(voto_scritto * 2/3) + (voto_quiz * 1/3)\n\n"
        "Entrambe le prove sono in 30esimi, ma è possibile ottenere punti "
        "extra e arrivare a 32. La lode viene assegnata se il totale supera 30.";

    if (writtenGrade == null) {
      tooltipMessage +=
          "\n\nPer avere una valutazione precisa, inserisci il "
          "voto della prova scritta nelle impostazioni.";
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 320.0),
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
                        Text("$correctAnswers/$questionNum"),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Voto scritto: ")),
                        Text(writtenGrade.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Voto quiz: ")),
                        Text(
                          "${quizGrade.toString()} (${min(quizGrade / 30 * 100, 100).round()}%)",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Tempo: ")),
                        Text(timerString),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    if (totalGrade != null)
                      Text(
                        "Voto finale: ${getGradeString(totalGrade!)} (${totalGrade!.toStringAsFixed(1)})",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    // TODO: style (bold, etc.)
                    if (totalGradeRange != null)
                      Text(
                        "Range voto finale: [${totalGradeRange!.$1.toStringAsFixed(0)},${totalGradeRange!.$2.toStringAsFixed(0)}]",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    // TODO: style (bold, etc.)
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
  }
}
