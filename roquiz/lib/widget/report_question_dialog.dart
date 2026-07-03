import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/utils/device.dart';
import 'package:roquiz/model/utils/navigation.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _correctAnswerKey = GlobalKey();

  final Map<String, String> issueTemplates = {
    "correct-answer": "Errore nella risposta corretta",
    // TODO
    //"question-body": "Corpo domanda",
    //"answer": "Risposta singola",
  };

  int? _newCorrectAnswer;
  final TextEditingController _controllerComment = TextEditingController(
    text: "",
  );

  String _errorText = "";

  String _validateCorrectAnswer() {
    // Missing correct answer
    if (_newCorrectAnswer == null) {
      return "Selezionare la nuova risposta corretta";
    }

    return "";
  }

  bool _validateReport() {
    setState(() {
      _errorText = _validateCorrectAnswer();
    });
    if (_errorText.isNotEmpty) {
      return false;
    }

    return true;
  }

  void _selectCorrectAnswer(int iAnswer) {
    setState(() {
      _errorText = "";

      if (_newCorrectAnswer == iAnswer) {
        _newCorrectAnswer = null;
        return;
      }

      _newCorrectAnswer = iAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    String appVersion = "";
    PackageInfo.fromPlatform().then((value) {
      appVersion = value.version;
    });
    final Size windowSize = getLogicalSize();

    return Form(
      key: _formKey,
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(width: 2.0, color: Colors.grey),
        ),
        alignment: Alignment.center,
        // Remove default padding
        titlePadding: EdgeInsets.all(0),
        title: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 0.0,
                left: 12.0,
                right: 12.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Segnala Domanda Q${widget.id + 1}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 24.0),
                    child: DropdownButtonFormField(
                      value: "correct-answer",
                      items: issueTemplates.entries
                          .map<DropdownMenuItem<String>>((
                            MapEntry<String, String> entry,
                          ) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          })
                          .toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Template"),
                      ),
                      onChanged: (_) {
                        // TODO: set widget below
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
                child: Icon(Icons.close),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      key: GlobalKey(),
                      initialValue: widget.question.body,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Domanda"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      readOnly: true,
                      enabled: false,
                      showCursor: false,
                    ),
                  ),
                  FormField(
                    key: _correctAnswerKey,
                    validator: (_) {
                      return _validateCorrectAnswer();
                    },
                    builder: (FormFieldState<dynamic> field) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Risposta Corretta',
                            labelStyle: TextStyle(
                              color: _errorText.isEmpty ? null : Colors.red,
                            ),
                            enabledBorder: _errorText.isEmpty
                                ? null
                                : OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10.0,
                              children: [
                                //Separator(text: "Nuova Risposta Corretta", size: 16.0),
                                ...List.generate(
                                  widget.question.answers.length,
                                  (index) {
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap:
                                              widget.question.correctAnswer ==
                                                  index
                                              ? null
                                              : () {
                                                  _selectCorrectAnswer(index);
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              widget.question.correctAnswer ==
                                                          index ||
                                                      _newCorrectAnswer == index
                                                  ? Icons.radio_button_on
                                                  : Icons.radio_button_off,
                                              color:
                                                  widget
                                                          .question
                                                          .correctAnswer ==
                                                      index
                                                  ? Colors.grey.withAlpha(100)
                                                  : _newCorrectAnswer == index
                                                  ? Colors.green
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            key: GlobalKey(),
                                            initialValue:
                                                widget.question.answers[index],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              focusedBorder:
                                                  _newCorrectAnswer == index
                                                  ? OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.green,
                                                        width: 2.0,
                                                      ),
                                                    )
                                                  : null,

                                              enabledBorder:
                                                  _newCorrectAnswer == index
                                                  ? OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.green,
                                                        width: 2.0,
                                                      ),
                                                    )
                                                  : null,

                                              label: Text(
                                                "Risposta ${index + 1}",
                                                style: TextStyle(
                                                  color:
                                                      _newCorrectAnswer == index
                                                      ? Colors.green
                                                      : null,
                                                ),
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            minLines: 1,
                                            maxLines: 3,
                                            readOnly: true,
                                            enabled:
                                                widget.question.correctAnswer !=
                                                index,
                                            showCursor: false,
                                            onTapAlwaysCalled: true,
                                            onTap:
                                                widget.question.correctAnswer ==
                                                    index
                                                ? null
                                                : () {
                                                    _selectCorrectAnswer(index);
                                                  },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  TextFormField(
                    key: GlobalKey(),
                    validator: null,
                    controller: _controllerComment,
                    decoration: InputDecoration(
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
        contentPadding: EdgeInsets.only(
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
                  style: TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),

              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                textAlign: TextAlign.center,
                margin: EdgeInsets.all(5.0),
                constraints: BoxConstraints(maxWidth: 300.0),
                richMessage: TextSpan(
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
                  onPressed: () {
                    if (!_validateReport()) {
                      return;
                    }

                    String repoIssueUrl = "mikyll/ROQuiz/issues/new";
                    String issueTemplate = "report_correct_answer.it.yaml";

                    String queryUrl =
                        "https://github.com/$repoIssueUrl?template=$issueTemplate"
                        "&title=[Segnalazione Domanda]: Errore nella Risposta Corretta Q${widget.id}"
                        "&app-version=v$appVersion"
                        "&question-id=${widget.question.id}&question-body=${widget.question.body}"
                        "&answer-to-be-corrected=${String.fromCharCode(65 + widget.question.correctAnswer)}. ${widget.question.answers[widget.question.correctAnswer]}"
                        "&correct-answer=${String.fromCharCode(65 + _newCorrectAnswer!)}. ${widget.question.answers[_newCorrectAnswer!]}&comment=${_controllerComment.text}";
                    openUrl(queryUrl);

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Conferma",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
