import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';

enum QuestionCardMode {
  quiz, // answers are selectable
  quizOver, // answers are not selectable, shows correct (can be selected or not) and wrong answers (if any)
  base, // answers are not selectable (radio buttons disabled), shows the correct answer
  hidden,
  edit,
}

class QuestionCard extends StatefulWidget {
  final QuestionCardMode mode;
  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int?>? onAnswerSelected;
  final bool hideCorrectAnswer;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final bool tapToSelect;

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
    this.isSelected = false,
    this.onSelected,
    this.tapToSelect = false,
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
       onSelected = null,
       tapToSelect = false;

  // Present in view_quiz (when the quiz is still running)
  const QuestionCard.quiz({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quiz,
       hideCorrectAnswer = false,
       isSelected = false,
       onSelected = null,
       tapToSelect = false;

  // Present in view_quiz (when the quiz is over)
  const QuestionCard.quizOver({
    super.key,
    required this.question,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.quizOver,
       onAnswerSelected = null,
       hideCorrectAnswer = false,
       isSelected = false,
       onSelected = null,
       tapToSelect = false;

  // Present in view_edit, in edit mode
  const QuestionCard.hidden({
    super.key,
    required this.question,
    this.selectedAnswer,
  }) : mode = QuestionCardMode.hidden,
       onAnswerSelected = null,
       hideCorrectAnswer = false,
       isSelected = false,
       onSelected = null,
       tapToSelect = false;

  // Present in view_edit, in edit mode
  const QuestionCard.edit({
    super.key,
    required this.question,
    required this.onSelected,
    this.selectedAnswer,
    this.isSelected = false,
    this.tapToSelect = false,
  }) : mode = QuestionCardMode.edit,
       onAnswerSelected = null,
       hideCorrectAnswer = false;

  @override
  State<StatefulWidget> createState() => QuestionCardState();
}

class QuestionCardState extends State<QuestionCard> {
  late bool _isSelected;

  Color _getBorderColor(BuildContext context) {
    switch (widget.mode) {
      case QuestionCardMode.quizOver:
        if (widget.selectedAnswer != null &&
            widget.selectedAnswer == widget.question.correctAnswer) {
          return Colors.green;
        } else {
          return Colors.red;
        }
      case QuestionCardMode.edit:
        if (_isSelected) {
          return Theme.of(context).primaryColor.withAlpha(50);
        }
      default:
    }
    return Colors.grey;
  }

  Color? _getFillColor(BuildContext context) {
    switch (widget.mode) {
      case QuestionCardMode.edit:
        if (_isSelected) {
          return const Color.fromARGB(255, 64, 152, 241).withAlpha(50);
        }
      default:
        return null;
    }
    return null;
  }

  @override
  void initState() {
    _isSelected = widget.isSelected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 2.0, color: _getBorderColor(context)),
          ),
          color: _getFillColor(context),
          // elevation: 10,
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
                    ].contains(widget.mode))
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Q${widget.question.id}.",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                    // Question text
                    Expanded(
                      child: Text(
                        widget.question.body,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                // Answers list
                ...widget.question.answers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final answer = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _AnswerTile(
                      mode: widget.mode,
                      answer: answer,
                      isSelected:
                          widget.selectedAnswer != null &&
                          index == widget.selectedAnswer,
                      isCorrect:
                          !widget.hideCorrectAnswer &&
                          index == widget.question.correctAnswer,
                      onTap: widget.mode == QuestionCardMode.quiz
                          ? () {
                              if (widget.selectedAnswer == index) {
                                widget.onAnswerSelected!(null);
                              } else {
                                widget.onAnswerSelected!(index);
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

        // Show selectable layer
        if (widget.mode == QuestionCardMode.edit)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  splashColor: Colors.transparent,
                  onTap: widget.tapToSelect && widget.onSelected != null
                      ? () {
                          setState(() {
                            _isSelected = !_isSelected;
                          });
                          widget.onSelected!(_isSelected);
                        }
                      : null,
                  onLongPress: !widget.tapToSelect && widget.onSelected != null
                      ? () {
                          setState(() {
                            _isSelected = !_isSelected;
                          });
                          widget.onSelected!(_isSelected);
                        }
                      : null,
                ),
              ),
            ),
          ),

        // Show report error button only if the question is in list
        if (widget.mode == QuestionCardMode.edit)
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

  Color _getFillColor(BuildContext context) {
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
          color: _getFillColor(context),
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
