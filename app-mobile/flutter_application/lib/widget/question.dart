import 'package:flutter/material.dart';
import 'package:roquiz/model/Answer.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
    this.questionNumber,
    required this.questionText,
    this.alignmentQuestion = Alignment.center,
    required this.answers,
    required this.isOver,
    required this.userAnswer,
    required this.correctAnswer,
    required this.onTapAnswer, // funzione vuota di default / null?
    required this.backgroundQuizColor,
    required this.defaultAnswerColor,
    this.selectedAnswerColor = Colors.transparent,
    required this.correctAnswerColor,
    required this.correctNotSelectedAnswerColor,
    this.wrongAnswerColor = Colors.transparent,
  }) : super(key: key);

  final String questionText;
  final List<String> answers;

  final int? questionNumber;
  final Alignment alignmentQuestion;
  final bool isOver;
  final Answer userAnswer;
  final Answer correctAnswer;
  final Function(int) onTapAnswer;

  final Color backgroundQuizColor;
  final Color defaultAnswerColor;
  final Color selectedAnswerColor;
  final Color correctAnswerColor;
  final Color correctNotSelectedAnswerColor;
  final Color wrongAnswerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: backgroundQuizColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selectedAnswerColor)),
      child: Column(
        children: [
          Container(
            alignment: alignmentQuestion,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // QUESTION
              child: Text(
                  (questionNumber != null ? "Q$questionNumber) " : "") +
                      questionText,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
          // ANSWERS
          ...List.generate(
            answers.length,
            (index) => InkWell(
              enableFeedback: true,
              onTap: onTapAnswer(index),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: !isOver && userAnswer == Answer.values[index]
                            ? selectedAnswerColor
                            : (!isOver
                                ? defaultAnswerColor
                                : (correctAnswer == Answer.values[index] &&
                                        (userAnswer == Answer.NONE ||
                                            userAnswer != correctAnswer)
                                    ? correctAnswerColor
                                    : (correctAnswer == Answer.values[index]
                                        ? correctNotSelectedAnswerColor
                                        : (userAnswer == Answer.values[index]
                                            ? wrongAnswerColor
                                            : defaultAnswerColor)))),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        // current answers
                        Text(Answer.values[index].name + ") ",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(answers[index],
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
