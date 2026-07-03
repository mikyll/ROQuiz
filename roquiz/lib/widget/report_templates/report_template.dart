import 'package:flutter/material.dart';

/// Data a report template produces for building the GitHub issue URL.
class ReportData {
  /// GitHub issue-template file name (e.g. "report_correct_answer.it.yaml").
  final String templateFile;

  /// Human-readable suffix appended to the issue title.
  final String titleSuffix;

  /// Template-specific query parameters (raw, un-encoded values).
  final Map<String, String> params;

  const ReportData({
    required this.templateFile,
    required this.titleSuffix,
    required this.params,
  });
}

/// Implemented by every report-template widget's [State] so the hosting
/// `ReportQuestionDialog` can validate the form and collect its issue data
/// through one uniform interface.
mixin ReportTemplateController {
  /// Validates the form, updating any inline error UI, and returns the error
  /// message to show the user (empty string when the form is valid).
  String validate();

  /// Collects the report data. Only called after [validate] returns "".
  ReportData collect();
}

/// Read-only display of a question body, shared by the templates that report a
/// different part of the question (correct answer, wrong answers) and therefore
/// show the body only for context.
class ReadOnlyQuestionBody extends StatelessWidget {
  final String body;

  const ReadOnlyQuestionBody({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: body,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Domanda"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      minLines: 1,
      maxLines: 5,
      readOnly: true,
      enabled: false,
      showCursor: false,
    );
  }
}
