import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/hidden_text.dart';
import 'package:roquiz/widget/report_question_dialog.dart';

enum QuestionCardMode {
  quiz, // answers are selectable
  quizOver, // answers are not selectable, shows correct (can be selected or not) and wrong answers (if any)
  base, // answers are not selectable (radio buttons disabled), shows the correct answer
  edit,
}

class QuestionCard extends StatelessWidget {
  final QuestionCardMode mode;
  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int?>? onAnswerSelected;
  final bool hideCorrectAnswer;
  final bool isSelected;
  final bool tapToSelect;
  final VoidCallback? onSelected;

  const QuestionCard({
    super.key,
    required this.mode,
    required this.question,
    this.selectedAnswer,
    this.onAnswerSelected,
    this.hideCorrectAnswer = false,
    this.isSelected = false,
    this.tapToSelect = false,
    this.onSelected,
  });

  // Present in view_questions
  const QuestionCard.base({
    super.key,
    required this.question,
    this.hideCorrectAnswer = false,
  }) : mode = QuestionCardMode.base,
       selectedAnswer = null,
       onAnswerSelected = null,
       isSelected = false,
       tapToSelect = false,
       onSelected = null;

  // Present in view_quiz (when the quiz is still running)
  const QuestionCard.quiz({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quiz,
       hideCorrectAnswer = false,
       isSelected = false,
       tapToSelect = false,
       onSelected = null;

  // Present in view_quiz (when the quiz is over)
  const QuestionCard.quizOver({
    super.key,
    required this.question,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quizOver,
       onAnswerSelected = null,
       hideCorrectAnswer = false,
       isSelected = false,
       tapToSelect = false,
       onSelected = null;

  // Present in view_edit, in edit mode
  const QuestionCard.edit({
    super.key,
    required this.question,
    this.selectedAnswer,
    this.isSelected = false,
    this.hideCorrectAnswer = false,
    this.tapToSelect = false,
    this.onSelected,
  }) : mode = QuestionCardMode.edit,
       onAnswerSelected = null;

  Color _getBorderColor(BuildContext context) {
    switch (mode) {
      case QuestionCardMode.quizOver:
        if (selectedAnswer != null &&
            selectedAnswer == question.correctAnswer) {
          return Colors.green;
        } else {
          return Colors.red;
        }
      case QuestionCardMode.edit:
        if (isSelected) {
          return const Color.fromARGB(255, 64, 152, 241);
        }
      default:
    }
    return Colors.grey;
  }

  Color? _getFillColor(BuildContext context) {
    switch (mode) {
      case QuestionCardMode.edit:
        if (isSelected) {
          // Blend the translucent tint over the card's opaque surface so it
          // reads the same light blue as the history list, regardless of the
          // (darker) page background behind the card.
          return Color.alphaBlend(
            const Color.fromARGB(255, 64, 152, 241).withAlpha(50),
            Theme.of(context).cardColor,
          );
        }
      default:
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _getBorderColor(context);
    final Color? fillColor = _getFillColor(context);

    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 2.0, color: borderColor),
          ),
          color: fillColor,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add question number only if not in Quiz
                    if (mode != QuestionCardMode.quiz)
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          "Q${question.id + 1}. ",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Question text
                    Expanded(
                      child: Text(
                        question.body,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    const SizedBox(width: 30),
                    if (mode == QuestionCardMode.base) HiddenText(),
                  ],
                ),
                // Answers list
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: List.generate(question.answers.length, (index) {
                      final answer = question.answers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _AnswerTile(
                          mode: mode,
                          answer: answer,
                          isSelected:
                              selectedAnswer != null && index == selectedAnswer,
                          isCorrect:
                              !hideCorrectAnswer &&
                              index == question.correctAnswer,
                          isCardSelected: isSelected,
                          hideCorrectAnswer: hideCorrectAnswer,
                          onTap: mode == QuestionCardMode.quiz
                              ? () => onAnswerSelected?.call(
                                  selectedAnswer == index ? null : index,
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show selectable layer
        if (mode == QuestionCardMode.edit)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  splashColor: Colors.transparent,
                  onTap: tapToSelect && onSelected != null
                      ? () {
                          onSelected!();
                        }
                      : null,
                  onLongPress: !tapToSelect && onSelected != null
                      ? () {
                          onSelected!();
                        }
                      : null,
                ),
              ),
            ),
          ),

        // Selection check icon (same as in the history list, where the
        // ListTile tints its trailing icon with colorScheme.primary).
        if (mode == QuestionCardMode.edit && isSelected)
          Positioned(
            top: 15,
            right: 15,
            child: IgnorePointer(
              child: Icon(
                Icons.check_circle,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

        // NB: needs to be on top of the stack. Custom questions are
        // user-specific, so they can't be reported upstream.
        if (mode == QuestionCardMode.base && question.isCustom != true)
          Positioned(
            top: 15,
            right: 15,
            child: IconButton(
              padding: EdgeInsets.all(5.0),
              constraints: BoxConstraints(),
              style: IconButton.styleFrom(backgroundColor: Colors.transparent),
              icon: Icon(Icons.report, size: 30, color: Colors.red),
              hoverColor: Color(0x50BBBBBB),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReportQuestionDialog(
                      question: question,
                      id: question.id,
                    );
                  },
                );
              },
            ),
          ),

        // Custom questions can't be reported; in their place, mark them as
        // user-added with a greyed pencil where the report button would be.
        if (mode == QuestionCardMode.base && question.isCustom == true)
          Positioned(
            top: 15,
            right: 15,
            child: Tooltip(
              message: "Domanda personalizzata",
              waitDuration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.edit,
                  size: 30,
                  color: Colors.grey.withAlpha(150),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final QuestionCardMode mode;
  final String answer;
  final bool isCardSelected;
  final bool isSelected;
  final bool isCorrect;
  final bool hideCorrectAnswer;
  final VoidCallback? onTap;

  const _AnswerTile({
    required this.mode,
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
    this.onTap,
    this.isCardSelected = false,
    this.hideCorrectAnswer = false,
  });

  Color _getFillColor(BuildContext context) {
    switch (mode) {
      case QuestionCardMode.quiz:
        if (isSelected) {
          // colorScheme.primary (not primaryColor): in dark mode primaryColor
          // resolves to the surface color, so the tint would vanish.
          return Theme.of(context).colorScheme.primary.withAlpha(50);
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
        if (!hideCorrectAnswer && isCorrect) {
          return Colors.green.shade400.withAlpha(200);
        }
    }

    return Colors.transparent;
  }

  Color _getBorderColor(BuildContext context) {
    switch (mode) {
      case QuestionCardMode.quiz:
        if (isSelected) {
          // Solid (not the translucent fill color) and colorScheme.primary so
          // the border stays visible against the card — in dark mode especially.
          return Theme.of(context).colorScheme.primary;
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
        if (!hideCorrectAnswer && isCorrect) {
          return Colors.green.shade400.withAlpha(200);
        }
        if (isCardSelected) {
          return Theme.of(context).focusColor; // TODO: fix this one
        }
    }

    return Colors.grey.shade300;
  }

  Color _getRadioButtonColor(BuildContext context) {
    if (mode == QuestionCardMode.quizOver) {
      return Colors.grey.withAlpha(150);
    }
    if (isSelected) {
      return Theme.of(context).colorScheme.primary;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final Color fillColor = _getFillColor(context);
    final Color borderColor = _getBorderColor(context);
    final Color radioColor = _getRadioButtonColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
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
                color: radioColor,
              ),
            if (mode == QuestionCardMode.base) HiddenText(text: "- "),
            const SizedBox(width: 12),
            Expanded(child: Text(answer, style: TextStyle(fontSize: 14.0))),

            if (mode == QuestionCardMode.base) HiddenText(),
          ],
        ),
      ),
    );
  }
}
