import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/palette.dart';
import 'package:roquiz/model/themes.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
    required this.questionText,
    required this.answers,
    // Correct answer
    required this.correctAnswer,
    required this.defaultAnswerColor,
    // Callback that updates the user selected answer
    required this.onTapAnswer,
    // Question index
    this.questionNumber,
    // User selected answer for that question (can be NONE)
    this.userAnswer = -1,
    this.highlightAnswer = false,
    this.alignmentQuestion = Alignment.center,
    this.selectedAnswerColor = Colors.transparent,
    this.correctAnswerColor = Colors.transparent,
    this.correctNotSelectedAnswerColor = Colors.transparent,
    this.wrongAnswerColor = Colors.transparent,
    this.backgroundQuizColor,
  }) : super(key: key);

  final String questionText;
  final List<String> answers;

  final int? questionNumber;
  final Alignment alignmentQuestion;
  final bool highlightAnswer;
  final int userAnswer;
  final int correctAnswer;
  final Function(int)? onTapAnswer;

  final Color defaultAnswerColor;
  final Color selectedAnswerColor;
  final Color correctAnswerColor;
  final Color correctNotSelectedAnswerColor;
  final Color wrongAnswerColor;
  final Color? backgroundQuizColor;

  // Returns the color of the answer identified by #index
  Color? _getColor(int index) {
    // Quiz terminated
    if (!highlightAnswer) {
      // User selected this answer
      if (userAnswer == index) {
        return selectedAnswerColor;
      }
      // User did not select this answer
      else {
        return defaultAnswerColor;
      }
    }
    // Quiz not terminated
    else {
      // This answer is the correct one
      if (correctAnswer == index) {
        // User selected this answer
        if (userAnswer == correctAnswer) {
          return correctAnswerColor;
        }
        // User did not select this answer
        else {
          return correctNotSelectedAnswerColor;
        }
      }
      // This answer is not the correct one
      else {
        // User selected this answer
        if (userAnswer == index) {
          return wrongAnswerColor;
        }
        // User did not select this answer
        else {
          return defaultAnswerColor;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuestionWidgetColors questionWidgetColors =
        Theme.of(context).extension<QuestionWidgetColors>()!;

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: questionWidgetColors.backgroundQuizColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: questionWidgetColors.selectedAnswerColor),
      ),
      child: Column(
        children: [
          Container(
            alignment: alignmentQuestion,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // Question text
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.0,
                      color: questionWidgetColors.textColor,
                    ),
                    children: [
                      TextSpan(
                        text: (questionNumber != null
                            ? "Q$questionNumber) "
                            : ""),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: questionText),
                    ]),
              ),
            ),
          ),
          // ANSWERS
          ...List.generate(
            answers.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: _getColor(index),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  enableFeedback: true,
                  onTap: onTapAnswer != null ? () => onTapAnswer!(index) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      // Answer letter
                      Text("${String.fromCharCode(index + 65)}) ",
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
