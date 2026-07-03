import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/report_templates/report_template.dart';

/// Report an error in the question body: the reporter edits the body text to
/// propose a correction.
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
    return TextFormField(
      controller: _bodyController,
      onChanged: (value) {
        if (_errorText.isNotEmpty) {
          setState(() => _errorText = "");
        }
        widget.onEditsChanged(value != widget.question.body);
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: const Text("Corpo Domanda"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hint: const Text("Correggi il testo della domanda."),
        errorText: _errorText.isEmpty ? null : _errorText,
      ),
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 8,
    );
  }
}
