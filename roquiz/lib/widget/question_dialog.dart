import 'package:flutter/material.dart';
import 'package:roquiz/model/utils/utils.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionDialog extends StatefulWidget {
  // TODO: topics list? check
  final List<String>? topicsList;
  final void Function(Question) onSubmit;
  final List<Question> questions;
  final Question? question;

  const QuestionDialog({
    super.key,
    required this.onSubmit,
    required this.questions,
    this.topicsList,
    this.question,
  });

  @override
  State<StatefulWidget> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _bodyController = TextEditingController();

  String? _topic;
  List<String> _answers = [""];
  int? _correctAnswer;

  Question? _getQuestion() {
    Question? question;

    question = Question(
      body: _bodyController.text,
      topic: _topic,
      answers: _answers,
      correctAnswer: _correctAnswer!,
    );

    return question;
  }

  // String? _validateQuestion(Question question) {
  //   if (isQuestionBodyDuplicate(widget.questions, question)) {
  //     return "Esiste già una domanda con questo corpo.";
  //   }

  //   return null;
  // }

  String? _validateBody(String? value) {
    if (value == null || value.isEmpty) {
      return "Il corpo della domanda dev'essere non vuoto";
    }

    if (isQuestionBodyDuplicate(widget.questions, value)) {
      return "Esiste già una domanda con questo corpo.";
    }

    return null;
  }

  String? _validateAnswer(String? value) {
    // TODO: validate:
    // - no empty body
    // - ok topic
    // - at least 2 answers
    // - selected correct answer

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.topicsList != null && widget.topicsList!.isNotEmpty) {
      _topic = widget.topicsList!.first;
    }
    if (widget.question != null) {
      _bodyController.text = widget.question!.body;
      _topic = widget.question!.topic;
      _answers = List.from(widget.question!.answers);
      _correctAnswer = widget.question!.correctAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                    widget.question != null
                        ? "Modifica Domanda"
                        : "Nuova Domanda",
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
          constraints: BoxConstraints(
            // TODO
            // maxHeight: windowSize.height * 1 / 4,
            maxWidth: 400.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.0,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  key: GlobalKey(),
                  validator: _validateBody,
                  controller: _bodyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Corpo"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorMaxLines: 2,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 4,
                ),
                if (_topic != null)
                  DropdownButtonFormField(
                    value: _topic,
                    items: widget.topicsList!.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Argomento"),
                    ),
                    onChanged: (topic) {
                      setState(() {
                        _topic = topic;
                      });
                    },
                  ),

                SingleChildScrollView(
                  controller: _scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10.0,
                    children: List.generate(_answers.length, (index) {
                      bool isAnswer = _answers[index].isNotEmpty;

                      return Row(
                        children: [
                          Opacity(
                            opacity: isAnswer ? 1.0 : 0.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_correctAnswer == index) {
                                    _correctAnswer = null;
                                    return;
                                  }

                                  _correctAnswer = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  _correctAnswer != null &&
                                          _correctAnswer! == index
                                      ? Icons.radio_button_on
                                      : Icons.radio_button_off,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              key: GlobalKey(),
                              initialValue: _answers[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Risposta ${index + 1}"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),

                              onChanged: (value) {
                                setState(() {
                                  _answers[index] = value;
                                });
                              },
                              // TODO: on change, if not empty, add new empty answer
                            ),
                          ),
                          SizedBox(width: 10),

                          Opacity(
                            opacity: isAnswer ? 1.0 : 0.0,
                            child: InkWell(
                              child: Icon(Icons.close),
                              onTap: () {
                                if (_answers.length > 2) {
                                  setState(() {
                                    _answers.removeAt(index);

                                    if (_correctAnswer == index) {
                                      _correctAnswer = null;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                ElevatedButton.icon(
                  label: Icon(Icons.add),
                  onPressed: () {
                    if (_answers.length < 6) {
                      setState(() {
                        _answers.add("");
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              // if (_formKey.currentState == null ||
              //     !_formKey.currentState!.validate()) {
              //   return;
              // }

              // TODO: call validate
              if (_bodyController.text.isEmpty) {
                print("Empty Body");
                return;
              }

              if (_answers.length < 2) {
                print("Not enough Answers");
                return;
              }

              for (String a in _answers) {
                if (a.isEmpty) {
                  print("Empty Answer");
                  return;
                }
              }

              if (_correctAnswer == null ||
                  _correctAnswer! < 0 ||
                  _correctAnswer! > _answers.length - 1) {
                print("Wrong correct Answer");
                return;
              }

              Question? q = _getQuestion();

              if (q == null) {
                print("error");
              }

              // TODO
              if (q != null) {
                widget.onSubmit(q);
              }

              Navigator.pop(context);
            },
            child: Text(
              "Conferma",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}
