import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/utils/device.dart';
import 'package:roquiz/model/utils/navigation.dart';
import 'package:roquiz/widget/report_templates/report_template.dart';
import 'package:roquiz/widget/report_templates/report_correct_answer.dart';
import 'package:roquiz/widget/report_templates/report_question_body.dart';
import 'package:roquiz/widget/report_templates/report_wrong_answer.dart';

class ReportQuestionDialog extends StatefulWidget {
  final Question question;
  final int id;

  const ReportQuestionDialog({
    super.key,
    required this.question,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => _ReportQuestionDialogState();
}

class _ReportQuestionDialogState extends State<ReportQuestionDialog> {
  static const Map<String, String> _issueTemplates = {
    "correct-answer": "Errore nella risposta corretta",
    "question-body": "Corpo domanda errato",
    "answers": "Risposte errate",
  };

  String _selectedTemplate = "correct-answer";

  // One key per template so each keeps its own State while the dropdown swaps
  // which one is shown; the current template's State is read back on confirm.
  final Map<String, GlobalKey> _templateKeys = {
    for (final String k in _issueTemplates.keys) k: GlobalKey(),
  };

  final TextEditingController _controllerComment = TextEditingController();
  String _appVersion = "";
  String _errorText = "";

  // Whether the current template has any edits worth reporting; drives the
  // Conferma button's enabled state. Reset when the template is switched.
  bool _canConfirm = false;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() => _appVersion = info.version);
      }
    });
  }

  @override
  void dispose() {
    _controllerComment.dispose();
    super.dispose();
  }

  void _onEditsChanged(bool hasEdits) {
    if (hasEdits != _canConfirm) {
      setState(() => _canConfirm = hasEdits);
    }
  }

  Widget _buildTemplate() {
    final Key key = _templateKeys[_selectedTemplate]!;
    switch (_selectedTemplate) {
      case "question-body":
        return ReportQuestionBody(
          key: key,
          question: widget.question,
          onEditsChanged: _onEditsChanged,
        );
      case "answers":
        return ReportWrongAnswer(
          key: key,
          question: widget.question,
          onEditsChanged: _onEditsChanged,
        );
      case "correct-answer":
      default:
        return ReportCorrectAnswer(
          key: key,
          question: widget.question,
          onEditsChanged: _onEditsChanged,
        );
    }
  }

  String _buildIssueUrl(ReportData data) {
    final Map<String, String> params = {
      "template": data.templateFile,
      "title": "[Segnalazione Domanda]: ${data.titleSuffix} Q${widget.id + 1}",
      "app-version": "v$_appVersion",
      "question-id": "${widget.question.id}",
      ...data.params,
      "comment": _controllerComment.text,
    };
    final String query = params.entries
        .map((e) => "${e.key}=${Uri.encodeQueryComponent(e.value)}")
        .join("&");
    return "https://github.com/mikyll/ROQuiz/issues/new?$query";
  }

  void _confirm() {
    final ReportTemplateController controller =
        _templateKeys[_selectedTemplate]!.currentState
            as ReportTemplateController;

    final String err = controller.validate();
    if (err.isNotEmpty) {
      setState(() => _errorText = err);
      return;
    }
    setState(() => _errorText = "");

    openUrl(_buildIssueUrl(controller.collect()));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size windowSize = getLogicalSize();

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(width: 2.0, color: Colors.grey),
      ),
      alignment: Alignment.center,
      // Remove default padding
      titlePadding: EdgeInsets.zero,
      title: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Segnala Domanda Q${widget.id + 1}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedTemplate,
                    items: _issueTemplates.entries
                        .map<DropdownMenuItem<String>>(
                          (entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Template"),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedTemplate = value;
                        _errorText = "";
                        // Fresh template starts with no edits.
                        _canConfirm = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              child: const Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: windowSize.height * 1 / 2,
          maxWidth: 400.0,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 15.0,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: _buildTemplate(),
                ),
                TextFormField(
                  controller: _controllerComment,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Commento"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hint: Text(
                      "Scrivi qui eventuali informazioni aggiuntive (es. motivazione della riposta).",
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  minLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 12.0,
        left: 24.0,
        right: 24.0,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            Opacity(
              opacity: _errorText.isNotEmpty ? 1.0 : 0.0,
              child: Text(
                _errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Tooltip(
              waitDuration: const Duration(milliseconds: 500),
              textAlign: TextAlign.center,
              margin: const EdgeInsets.all(5.0),
              constraints: const BoxConstraints(maxWidth: 300.0),
              richMessage: const TextSpan(
                children: [
                  TextSpan(
                    text: "NB",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ": per fare una segnalazione è necessario avere un account GitHub.",
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _canConfirm ? _confirm : null,
                child: const Text(
                  "Conferma",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
