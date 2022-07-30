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

  final int? questionNumber; // Index of the current question
  final Alignment alignmentQuestion;
  final bool isOver;
  final Answer userAnswer; // User answer for that question (can be NONE)
  final Answer correctAnswer; // Correct answer
  final Function(int)
      onTapAnswer; // Callback which updates the user selected answer

  final Color backgroundQuizColor;
  final Color defaultAnswerColor;
  final Color selectedAnswerColor;
  final Color correctAnswerColor;
  final Color correctNotSelectedAnswerColor;
  final Color wrongAnswerColor;

  Color _getColor(int index) {
    return !isOver && userAnswer == Answer.values[index]
        ? selectedAnswerColor
        : (!isOver
            ? defaultAnswerColor
            : (correctAnswer == Answer.values[index] &&
                    (userAnswer == Answer.NONE || userAnswer != correctAnswer)
                ? correctAnswerColor
                : (correctAnswer == Answer.values[index]
                    ? correctNotSelectedAnswerColor
                    : (userAnswer == Answer.values[index]
                        ? wrongAnswerColor
                        : defaultAnswerColor))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              // Question text
              child: Text(
                  (questionNumber != null ? "Q$questionNumber) " : "") +
                      questionText,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
          // ANSWERS
          ...List.generate(
            answers.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: InkWell(
                enableFeedback: true,
                onTap: onTapAnswer(index),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: _getColor(index),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      // Answer letter
                      Text(Answer.values[index].name + ") ",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Flexible(
                        // Answer text
                        child: Text(answers[index],
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
