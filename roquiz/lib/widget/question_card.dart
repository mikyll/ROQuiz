import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<Question>? onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Text(question.body, style: Theme.of(context).textTheme.headline),
            const SizedBox(height: 16),

            // Answers list
            ...question.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: AnswerTile(
                  answer: answer,
                  isSelected: index == question.selectedAnswerIndex,
                  onTap: () {
                    // Create a new question with the selected answer
                    final updatedQuestion = Question(
                      body: question.body,
                      answers: question.answers,
                      selectedAnswerIndex: index,
                    );

                    if (onAnswerSelected != null) {
                      onAnswerSelected!(updatedQuestion);
                    }
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
