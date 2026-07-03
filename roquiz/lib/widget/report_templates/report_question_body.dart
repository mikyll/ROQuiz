import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/report_templates/report_template.dart';

/// Report an error in the question body: the reporter edits the body text to
/// propose a correction. The answers are shown greyed out for context, with the
/// correct one selected and highlighted green.
class ReportQuestionBody extends StatefulWidget {
  final Question question;

  /// Called whenever the "has edits" state changes (true once the body text
  /// differs from the original), so the host can enable/disable its confirm
  /// button.
  final ValueChanged<bool> onEditsChanged;

  const ReportQuestionBody({
    super.key,
    required this.question,
    required this.onEditsChanged,
  });

  @override
  State<ReportQuestionBody> createState() => _ReportQuestionBodyState();
}

class _ReportQuestionBodyState extends State<ReportQuestionBody>
    with ReportTemplateController {
  late final TextEditingController _bodyController = TextEditingController(
    text: widget.question.body,
  );
  String _errorText = "";

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  String validate() {
    final String err = _bodyController.text.trim().isEmpty
        ? "Il corpo della domanda non può essere vuoto"
        : "";
    setState(() => _errorText = err);
    return err;
  }

  @override
  ReportData collect() {
    return ReportData(
      templateFile: "report_question_body.it.yaml",
      titleSuffix: "Errore nel Corpo della Domanda",
      params: {
        "question-body": widget.question.body,
        "corrected-body": _bodyController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Question q = widget.question;
    final bool edited = _bodyController.text != q.body;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 15.0,
      children: [
        TextFormField(
          controller: _bodyController,
          onChanged: (value) {
            setState(() => _errorText = "");
            widget.onEditsChanged(value != widget.question.body);
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: edited
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  )
                : null,
            enabledBorder: edited
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  )
                : null,
            label: Text(
              "Corpo Domanda",
              style: TextStyle(color: edited ? Colors.red : null),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hint: const Text("Correggi il testo della domanda."),
            errorText: _errorText.isEmpty ? null : _errorText,
          ),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 8,
        ),
        InputDecorator(
          decoration: const InputDecoration(labelText: 'Risposte'),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.0,
              children: List.generate(q.answers.length, (index) {
                final bool isCorrect = q.correctAnswer == index;
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        isCorrect
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                        color: isCorrect
                            ? Colors.green.shade700
                            : Colors.grey.withAlpha(100),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        initialValue: q.answers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          disabledBorder: isCorrect
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green.shade700, width: 2.0),
                                )
                              : null,
                          label: Text(
                            "Risposta ${index + 1}",
                            style: TextStyle(
                                color: isCorrect ? Colors.green.shade700 : null),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        readOnly: true,
                        enabled: false,
                        showCursor: false,
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
