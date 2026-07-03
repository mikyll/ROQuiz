import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/report_templates/report_template.dart';

/// Report an error in one or more answers: the reporter edits any answer text
/// to propose a correction. The circles only mark the (non-selectable) correct
/// answer for context; edited answers are highlighted.
class ReportWrongAnswer extends StatefulWidget {
  final Question question;

  /// Called whenever the "has edits" state changes (true once at least one
  /// answer text differs from the original), so the host can enable/disable its
  /// confirm button.
  final ValueChanged<bool> onEditsChanged;

  const ReportWrongAnswer({
    super.key,
    required this.question,
    required this.onEditsChanged,
  });

  @override
  State<ReportWrongAnswer> createState() => _ReportWrongAnswerState();
}

class _ReportWrongAnswerState extends State<ReportWrongAnswer>
    with ReportTemplateController {
  late final List<TextEditingController> _controllers = List.generate(
    widget.question.answers.length,
    (i) => TextEditingController(text: widget.question.answers[i]),
  );
  String _errorText = "";

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool _isEdited(int i) => _controllers[i].text != widget.question.answers[i];

  bool get _hasEdits => List.generate(
    _controllers.length,
    _isEdited,
  ).any((edited) => edited);

  void _onChanged() {
    setState(() => _errorText = "");
    widget.onEditsChanged(_hasEdits);
  }

  @override
  String validate() {
    final String err = _hasEdits ? "" : "Modificare almeno una risposta errata";
    setState(() => _errorText = err);
    return err;
  }

  @override
  ReportData collect() {
    final Question q = widget.question;
    final String wrong = List.generate(q.answers.length, (i) => i)
        .where(_isEdited)
        .map((i) {
          final String letter = String.fromCharCode(65 + i);
          return "$letter. ${q.answers[i]} -> ${_controllers[i].text}";
        })
        .join(" | ");

    return ReportData(
      templateFile: "report_wrong_answer.it.yaml",
      titleSuffix: "Errore in una o più Risposte",
      params: {
        "question-body": q.body,
        "wrong-answers": wrong,
      },
    );
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
            labelText: 'Risposte Errate',
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
                final bool isCorrect = q.correctAnswer == index;
                final bool edited = _isEdited(index);
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        isCorrect
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                        color: Colors.grey.withAlpha(100),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _controllers[index],
                        onChanged: (_) => _onChanged(),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: edited
                              ? const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                )
                              : null,
                          enabledBorder: edited
                              ? const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                )
                              : null,
                          label: Text(
                            "Risposta ${index + 1}",
                            style: TextStyle(color: edited ? Colors.red : null),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 3,
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
