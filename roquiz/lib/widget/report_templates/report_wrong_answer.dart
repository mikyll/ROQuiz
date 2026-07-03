import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/report_templates/report_template.dart';

/// Report an error in one or more answers: the reporter flags the wrong
/// answers (checkbox) and can edit each flagged answer to propose a correction.
class ReportWrongAnswer extends StatefulWidget {
  final Question question;

  /// Called whenever the "has edits" state changes (true once at least one
  /// answer is flagged), so the host can enable/disable its confirm button.
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
  final Set<int> _flagged = {};
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

  void _toggle(int i) {
    setState(() {
      _errorText = "";
      if (!_flagged.remove(i)) {
        _flagged.add(i);
      }
    });
    widget.onEditsChanged(_flagged.isNotEmpty);
  }

  @override
  String validate() {
    final String err =
        _flagged.isEmpty ? "Selezionare almeno una risposta errata" : "";
    setState(() => _errorText = err);
    return err;
  }

  @override
  ReportData collect() {
    final Question q = widget.question;
    final List<int> sorted = _flagged.toList()..sort();
    final String wrong = sorted.map((i) {
      final String letter = String.fromCharCode(65 + i);
      final String original = q.answers[i];
      final String corrected = _controllers[i].text;
      return corrected != original
          ? "$letter. $original -> $corrected"
          : "$letter. $original";
    }).join(" | ");

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
                final bool flagged = _flagged.contains(index);
                return Row(
                  children: [
                    InkWell(
                      onTap: () => _toggle(index),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          flagged
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: flagged ? Colors.red : null,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: flagged
                              ? const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                )
                              : null,
                          enabledBorder: flagged
                              ? const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                )
                              : null,
                          label: Text(
                            "Risposta ${index + 1}",
                            style: TextStyle(color: flagged ? Colors.red : null),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        readOnly: !flagged,
                        showCursor: flagged,
                        onTapAlwaysCalled: true,
                        onTap: flagged ? null : () => _toggle(index),
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
