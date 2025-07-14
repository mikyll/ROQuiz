import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionCardSelectable extends StatelessWidget {
  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int?> onAnswerSelected;

  // Constructors(or separate files?):
  // - quiz
  // - questions list
  // - questions editor
  const QuestionCardSelectable({
    super.key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
            // Question text
            Text(
              question.body,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Answers list
            ...question.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _AnswerTile(
                  answer: answer,
                  isSelected: selectedAnswer != null && index == selectedAnswer,
                  onTap: () {
                    if (selectedAnswer == index) {
                      onAnswerSelected(null);
                    } else {
                      onAnswerSelected(index);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnswerTile({
    required this.answer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(50)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor.withAlpha(50)
                : Colors.grey.shade300,
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
            Expanded(
              child: Text(
                answer,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
