import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';

enum QuestionCardMode {
  quiz, // answers are selectable
  quizOver, // answers are not selectable, shows correct (can be selected or not) and wrong answers (if any)
  base, // answers are not selectable (radio buttons disabled), shows the correct answer
  hidden,
  edit,
}

class QuestionCard extends StatelessWidget {
  final QuestionCardMode mode;
  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int?>? onAnswerSelected;
  final bool hideCorrectAnswer;

  // Constructors(or separate files?):
  // - quiz
  // - questions list
  // - questions editor
  const QuestionCard({
    super.key,
    required this.mode,
    required this.question,
    this.selectedAnswer,
    this.onAnswerSelected,
    this.hideCorrectAnswer = false,
  });

  // Present in view_questions
  const QuestionCard.base({
    super.key,
    required this.question,
    this.hideCorrectAnswer = false,
  }) : mode = QuestionCardMode.base,
       selectedAnswer = null,
       onAnswerSelected = null;

  // Present in view_quiz (when the quiz is still running)
  const QuestionCard.quiz({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quiz,
       hideCorrectAnswer = false;

  // Present in view_quiz (when the quiz is over)
  const QuestionCard.quizOver({
    super.key,
    required this.question,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quizOver,
       onAnswerSelected = null,
       hideCorrectAnswer = false;

  // Present in view_edit, in edit mode
  const QuestionCard.hidden({
    super.key,
    required this.question,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.hidden,
       onAnswerSelected = null,
       hideCorrectAnswer = false;

  // Present in view_edit, in edit mode
  const QuestionCard.edit({
    super.key,
    required this.question,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quizOver,
       onAnswerSelected = null,
       hideCorrectAnswer = false;

  Color _getBorderColor() {
    if (mode == QuestionCardMode.quizOver) {
      if (selectedAnswer != null && selectedAnswer == question.correctAnswer) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 2.0, color: _getBorderColor()),
          ),
          elevation: 10,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add question number only if not in Quiz
                    if ([
                      QuestionCardMode.base,
                      QuestionCardMode.hidden,
                      QuestionCardMode.edit,
                    ].contains(mode))
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Q${question.id}.",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                    // Question text
                    Expanded(
                      child: Text(
                        question.body,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                // Answers list
                ...question.answers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final answer = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _AnswerTile(
                      mode: mode,
                      answer: answer,
                      isSelected:
                          selectedAnswer != null && index == selectedAnswer,
                      isCorrect:
                          !hideCorrectAnswer && index == question.correctAnswer,
                      onTap: mode == QuestionCardMode.quiz
                          ? () {
                              if (selectedAnswer == index) {
                                onAnswerSelected!(null);
                              } else {
                                onAnswerSelected!(index);
                              }
                            }
                          : null,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Show report error button only if the question is in list
        if ([QuestionCardMode.edit].contains(mode))
          Positioned(
            top: 25,
            right: 25,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              style: IconButton.styleFrom(backgroundColor: Colors.transparent),
              icon: Icon(Icons.report, size: 30, color: Colors.red),
              onPressed: () {
                // Add your button action here
              },
            ),
          ),
      ],
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final QuestionCardMode mode;
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback? onTap;

  const _AnswerTile({
    required this.mode,
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
    this.onTap,
  });

  Color _getColor(BuildContext context) {
    switch (mode) {
      case QuestionCardMode.hidden:
        return Colors.grey.shade300;

      case QuestionCardMode.quiz:
        if (isSelected) {
          return Theme.of(context).primaryColor.withAlpha(50);
        }
        break;

      case QuestionCardMode.quizOver:
        if (isSelected && !isCorrect) {
          return Colors.red.withAlpha(200);
        }
        if (isSelected && isCorrect) {
          return Colors.green.shade400.withAlpha(200);
        }
        if (!isSelected && isCorrect) {
          return Colors.green.shade900.withAlpha(200);
        }
        break;

      case QuestionCardMode.base:
      case QuestionCardMode.edit:
        if (isCorrect) {
          return Colors.green.shade400.withAlpha(200);
        }
    }

    return Colors.transparent;
  }

  Color _getBorderColor(BuildContext context) {
    switch (mode) {
      case QuestionCardMode.hidden:
        return Colors.grey.shade300;

      case QuestionCardMode.quiz:
        if (isSelected) {
          return Theme.of(context).primaryColor.withAlpha(50);
        }
        break;

      case QuestionCardMode.quizOver:
        if (isSelected && !isCorrect) {
          return Colors.red.withAlpha(200);
        }
        if (isSelected && isCorrect) {
          return Colors.green.shade400.withAlpha(200);
        }
        if (!isSelected && isCorrect) {
          return Colors.green.shade900.withAlpha(200);
        }
        break;

      case QuestionCardMode.base:
      case QuestionCardMode.edit:
        if (isCorrect) {
          return Colors.green.shade400.withAlpha(200);
        }
    }

    return Colors.grey.shade300;
  }

  Color _getRadioButtonColor(BuildContext context) {
    if (mode == QuestionCardMode.quizOver) {
      return Colors.grey.withAlpha(150);
    }
    if (isSelected) {
      return Theme.of(context).primaryColor;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: _getColor(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _getBorderColor(context)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if ([
              QuestionCardMode.quiz,
              QuestionCardMode.quizOver,
            ].contains(mode))
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: _getRadioButtonColor(context),
              ),
            const SizedBox(width: 12),
            Expanded(child: Text(answer)),
          ],
        ),
      ),
    );
  }
}
