import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/report_templates/report_template.dart';

/// Report an error in which answer is marked correct: the reporter picks the
/// answer that *should* be correct.
class ReportCorrectAnswer extends StatefulWidget {
  final Question question;

  /// Called whenever the "has edits" state changes (true once a new correct
  /// answer is selected), so the host can enable/disable its confirm button.
  final ValueChanged<bool> onEditsChanged;

  const ReportCorrectAnswer({
    super.key,
    required this.question,
    required this.onEditsChanged,
  });

  @override
  State<ReportCorrectAnswer> createState() => _ReportCorrectAnswerState();
}

class _ReportCorrectAnswerState extends State<ReportCorrectAnswer>
    with ReportTemplateController {
  int? _newCorrectAnswer;
  String _errorText = "";

  @override
  String validate() {
    final String err = _newCorrectAnswer == null
        ? "Selezionare la nuova risposta corretta"
        : "";
    setState(() => _errorText = err);
    return err;
  }

  @override
  ReportData collect() {
    final Question q = widget.question;
    return ReportData(
      templateFile: "report_correct_answer.it.yaml",
      titleSuffix: "Errore nella Risposta Corretta",
      params: {
        "question-body": q.body,
        "answer-to-be-corrected":
            "${String.fromCharCode(65 + q.correctAnswer)}. ${q.answers[q.correctAnswer]}",
        "correct-answer":
            "${String.fromCharCode(65 + _newCorrectAnswer!)}. ${q.answers[_newCorrectAnswer!]}",
      },
    );
  }

  void _select(int i) {
    setState(() {
      _errorText = "";
      _newCorrectAnswer = _newCorrectAnswer == i ? null : i;
    });
    widget.onEditsChanged(_newCorrectAnswer != null);
  }

  @override
  Widget build(BuildContext context) {
    final Question q = widget.question;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 15.0,
      children: [
        ReadOnlyQuestionBody(body: q.body),
        InputDecorator(
          decoration: InputDecoration(
            labelText: 'Risposta Corretta',
            labelStyle: TextStyle(color: _errorText.isEmpty ? null : Colors.red),
            enabledBorder: _errorText.isEmpty
                ? null
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.0,
              children: List.generate(q.answers.length, (index) {
                final bool isCurrent = q.correctAnswer == index;
                final bool isSelected = _newCorrectAnswer == index;
                return Row(
                  children: [
                    InkWell(
                      onTap: isCurrent ? null : () => _select(index),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          isCurrent || isSelected
                              ? Icons.radio_button_on
                              : Icons.radio_button_off,
                          color: isCurrent
                              ? Colors.grey.withAlpha(100)
                              : isSelected
                              ? Colors.green
                              : null,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        initialValue: q.answers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: isSelected
                              ? const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 2.0),
                                )
                              : null,
                          enabledBorder: isSelected
                              ? const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 2.0),
                                )
                              : null,
                          label: Text(
                            "Risposta ${index + 1}",
                            style:
                                TextStyle(color: isSelected ? Colors.green : null),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        readOnly: true,
                        enabled: !isCurrent,
                        showCursor: false,
                        onTapAlwaysCalled: true,
                        onTap: isCurrent ? null : () => _select(index),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
