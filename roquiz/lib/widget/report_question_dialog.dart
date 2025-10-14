import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/utils/navigation.dart';
import 'package:roquiz/widget/separator.dart';

class ReportQuestionDialog extends StatefulWidget {
  final Question question;
  final int? id;

  const ReportQuestionDialog({super.key, required this.question, this.id});

  @override
  State<StatefulWidget> createState() => _ReportQuestionDialogState();
}

class _ReportQuestionDialogState extends State<ReportQuestionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _correctAnswerKey = GlobalKey();

  final Map<String, String> issueTemplates = {
    "correct-answer": "Risposta corretta",
    // TODO
    //"question-body": "Corpo domanda",
    //"answer": "Risposta singola",
  };

  int? _newCorrectAnswer;
  final TextEditingController _controllerComment = TextEditingController(
    text: "",
  );

  @override
  Widget build(BuildContext context) {
    String appVersion = "";
    PackageInfo.fromPlatform().then((value) {
      appVersion = value.version;
    });

    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(width: 2.0, color: Colors.grey),
        ),
        alignment: Alignment.center,
        titlePadding: EdgeInsets.all(0),
        title: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Segnala Domanda Q${widget.id}",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          constraints: BoxConstraints(maxHeight: 500, maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: "correct-answer",
                    items: issueTemplates.entries.map<DropdownMenuItem<String>>(
                      (MapEntry<String, String> entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      },
                    ).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Template"),
                    ),
                    onChanged: (_) {
                      // TODO: set widget below
                    },
                  ),
                  SizedBox(height: 10.0),
                  Separator(text: "Nuova Risposta Corretta", size: 16.0),
                  SizedBox(height: 10.0),
                  FormField(
                    key: _correctAnswerKey,
                    validator: (value) {
                      if (_newCorrectAnswer == null) {
                        print("error");
                        return "Selezionare la nuova risposta corretta";
                      }

                      return null;
                    },
                    builder: (FormFieldState<dynamic> field) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10.0,
                        children: [
                          ...List.generate(widget.question.answers.length, (
                            index,
                          ) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: widget.question.correctAnswer == index
                                      ? null
                                      : () {
                                          setState(() {
                                            if (_newCorrectAnswer == index) {
                                              _newCorrectAnswer = null;
                                              return;
                                            }

                                            _newCorrectAnswer = index;
                                          });
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      widget.question.correctAnswer == index ||
                                              _newCorrectAnswer == index
                                          ? Icons.radio_button_on
                                          : Icons.radio_button_off,
                                      color:
                                          widget.question.correctAnswer == index
                                          ? Colors.grey
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
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: _newCorrectAnswer == index
                                            ? BorderSide(
                                                color: Colors.green,
                                                width: 2.0,
                                              )
                                            : BorderSide(width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: _newCorrectAnswer == index
                                            ? BorderSide(
                                                color: Colors.green,
                                                width: 2.0,
                                              )
                                            : BorderSide(),
                                      ),

                                      label: Text(
                                        "Risposta ${index + 1}",
                                        style: TextStyle(
                                          color: _newCorrectAnswer == index
                                              ? Colors.green
                                              : null,
                                        ),
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                    maxLines: 1,
                                    readOnly: true,
                                    showCursor: false,
                                    onTapAlwaysCalled: true,
                                    onTap:
                                        widget.question.correctAnswer == index
                                        ? null
                                        : () {
                                            setState(() {
                                              if (_newCorrectAnswer == index) {
                                                _newCorrectAnswer = null;
                                                return;
                                              }

                                              _newCorrectAnswer = index;
                                            });
                                          },
                                  ),
                                ),
                              ],
                            );
                          }),
                          if (field.hasError)
                            Text(
                              field.errorText!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20.0),

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
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            spacing: 10.0,
            children: [
              Text.rich(
                TextSpan(
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
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState == null ||
                      !_formKey.currentState!.validate()) {
                    return;
                  }

                  String repoIssueUrl = "mikyll/ROQuiz/issues/new";
                  String issueTemplate = "report_correct_answer.it.yaml";

                  String queryUrl =
                      "https://github.com/$repoIssueUrl?template=$issueTemplate"
                      "&title=[Segnalazione Domanda]: Errore nella Risposta Corretta Q${widget.id}"
                      "&app-version=v$appVersion&question-body=${widget.question.body}"
                      "&answer-to-be-corrected=${String.fromCharCode(65 + widget.question.correctAnswer)}. ${widget.question.answers[widget.question.correctAnswer]}"
                      "&correct-answer=${String.fromCharCode(65 + _newCorrectAnswer!)}. ${widget.question.answers[_newCorrectAnswer!]}&comment=${_controllerComment.text}";
                  openUrl(queryUrl);

                  Navigator.pop(context);
                },
                child: Text(
                  "Conferma",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
