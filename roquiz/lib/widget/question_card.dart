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

  // const QuestionCard.quiz({
  //   super.key,
  //   required this.question,
  //   this.selectedAnswer,
  // });

  // const QuestionCard.quizOver({
  //   super.key,
  //   required this.question,
  //   this.selectedAnswer,
  // });

  // const QuestionCard.base({
  //   super.key,
  //   required this.question,
  //   this.selectedAnswer,
  // });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 2.0, color: Colors.grey),
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

  Color? _getColor(bool isSelected, bool isCorrect) {
    Color? color;

    switch (mode) {
      case QuestionCardMode.base:
        // TODO
        break;

      case QuestionCardMode.quiz:
        // TODO
        break;
      default:
    }

    if (isSelected && !isCorrect) {
      color = Colors.red.withAlpha(200);
    }
    if (isSelected && isCorrect) {
      color = Colors.green.shade400.withAlpha(200);
    }
    if (!isSelected && isCorrect) {
      color = Colors.green.shade900.withAlpha(200);
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: _getColor(isSelected, isCorrect),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getColor(isSelected, isCorrect) ?? Colors.grey.shade300,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(answer)),
          ],
        ),
      ),
    );
  }
}
