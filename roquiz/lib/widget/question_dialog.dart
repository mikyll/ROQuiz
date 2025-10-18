import 'package:flutter/material.dart';
import 'package:roquiz/model/utils/device.dart';
import 'package:roquiz/model/utils/question.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionDialog extends StatefulWidget {
  final List<Question> questions;
  final List<String>? topics;
  final void Function(Question) onSubmit;
  final Question? question;
  final int minAnswers;
  final int maxAnswers;

  const QuestionDialog({
    super.key,
    required this.questions,
    this.topics,
    this.question,
    required this.onSubmit,
    this.minAnswers = 2,
    this.maxAnswers = 6,
  });

  @override
  State<StatefulWidget> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _answersKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String? _topic;
  final TextEditingController _bodyController = TextEditingController();
  final List<TextEditingController> _answerControllers = [
    TextEditingController(text: ""),
  ];
  int? _correctAnswer;
  String? _errorText;
  bool _errorBody = false;
  bool _errorAnswers = false;

  Question? _getQuestion() {
    final List<String> answers = _getAnswers(
      _answerControllers,
      removeEmpty: true,
    );

    Question? question;
    int id = getFirstAvailableId(widget.questions, _topic);

    question = Question(
      id: id,
      body: _bodyController.text,
      topic: _topic,
      answers: answers,
      correctAnswer: _correctAnswer!,
    );

    return question;
  }

  String? _validateBody(String? value, {bool checkDuplicates = true}) {
    if (value == null || value.isEmpty) {
      return "Il corpo della domanda dev'essere non vuoto";
    }

    if (checkDuplicates && isQuestionBodyDuplicate(widget.questions, value)) {
      return "Esiste già una domanda con questo corpo.";
    }

    return null;
  }

  String? _validateAnswers(
    List<String> answers,
    int? correctAnswer, {
    bool checkDuplicates = true,
  }) {
    if (answers.length - _numEmptyAnswers() < widget.minAnswers) {
      return "Devono essere presenti almeno ${widget.minAnswers} risposte non vuote";
    }

    if (answers.length - _numEmptyAnswers() > widget.maxAnswers) {
      return "Non possono esserci più di ${widget.minAnswers} risposte";
    }

    if (checkDuplicates) {
      for (int i = 0; i < answers.length; i++) {
        if (isAnswerDuplicate(answers, answers[i])) {
          return "La risposta ${i + 1} '${answers[i]}' è duplicata";
        }
      }
    }

    if (correctAnswer == null) {
      return "La risposta corretta non è stata selezionata";
    }

    if (correctAnswer < 0 || correctAnswer >= answers.length) {
      return "La risposta corretta dev'essere nel range [0, ${answers.length - 1}]";
    }

    // TODO?

    return null;
  }

  List<String> _getAnswers(
    List<TextEditingController> controllers, {
    bool removeEmpty = false,
  }) {
    final List<String> answers = [];
    for (TextEditingController c in controllers) {
      if (removeEmpty && c.text.isEmpty) {
        continue;
      }
      answers.add(c.text);
    }
    return answers;
  }

  int _numEmptyAnswers() {
    int emptyAnswers = 0;
    for (TextEditingController c in _answerControllers) {
      if (c.text.isEmpty) {
        emptyAnswers++;
      }
    }
    return emptyAnswers;
  }

  @override
  void initState() {
    super.initState();

    if (widget.topics != null && widget.topics!.isNotEmpty) {
      _topic = widget.topics!.first;
    }
    if (widget.question != null) {
      _bodyController.text = widget.question!.body;
      _topic = widget.question!.topic;
      _correctAnswer = widget.question!.correctAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.question != null
                        ? "Modifica Domanda"
                        : "Nuova Domanda",
                    style: TextStyle(fontWeight: FontWeight.w500),
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
            maxHeight: windowSize.height * 2 / 5,
            maxWidth: 400.0,
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.0,
                children: [
                  SizedBox(height: 10),
                  if (_topic != null)
                    DropdownButtonFormField(
                      value: _topic,
                      items: widget.topics!.map<DropdownMenuItem<String>>((
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
                  TextFormField(
                    controller: _bodyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Corpo",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: !_errorBody ? null : Colors.red,
                      ),
                      enabledBorder: !_errorBody
                          ? null
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 4,
                    onChanged: (value) {
                      setState(() {
                        if (_errorBody) {
                          _errorText = null;
                          _errorBody = false;
                        }
                      });
                    },
                  ),

                  FormField(
                    key: _answersKey,
                    builder: (FormFieldState<dynamic> field) {
                      return SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Risposte",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                              color: !_errorAnswers ? null : Colors.red,
                            ),
                            enabledBorder: !_errorAnswers
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
                              spacing: 10.0,
                              children: List.generate(_answerControllers.length, (
                                index,
                              ) {
                                return Row(
                                  children: [
                                    InkWell(
                                      onTap:
                                          _answerControllers[index].text.isEmpty
                                          ? null
                                          : () {
                                              setState(() {
                                                if (_errorAnswers) {
                                                  _errorText = null;
                                                  _errorAnswers = false;
                                                }
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
                                          color:
                                              _answerControllers[index]
                                                  .text
                                                  .isEmpty
                                              ? Colors.grey.withAlpha(100)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (index < _answerControllers.length)
                                      Flexible(
                                        child: TextFormField(
                                          controller: _answerControllers[index],
                                          minLines: 1,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text(
                                              "Risposta ${index + 1}",
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (_errorAnswers) {
                                                _errorText = null;
                                                _errorAnswers = false;
                                              }
                                              _answerControllers[index].text =
                                                  value;
                                              if (value.isEmpty &&
                                                  _correctAnswer == index) {
                                                _correctAnswer = null;
                                              }

                                              // Checks before adding a new empty answer
                                              if (_numEmptyAnswers() > 0) {
                                                return;
                                              }
                                              if (_answerControllers.length >=
                                                  widget.maxAnswers) {
                                                return;
                                              }

                                              _answerControllers.add(
                                                TextEditingController(text: ""),
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap:
                                          _answerControllers.length > 1 &&
                                              (_answerControllers[index]
                                                      .text
                                                      .isNotEmpty ||
                                                  _numEmptyAnswers() > 1)
                                          ? () {
                                              setState(() {
                                                if (_errorAnswers) {
                                                  _errorText = null;
                                                  _errorAnswers = false;
                                                }

                                                if (_correctAnswer == index) {
                                                  _correctAnswer = null;
                                                }

                                                _answerControllers.removeAt(
                                                  index,
                                                );

                                                if (_numEmptyAnswers() == 0) {
                                                  _answerControllers.add(
                                                    TextEditingController(
                                                      text: "",
                                                    ),
                                                  );
                                                }
                                              });
                                            }
                                          : null,
                                      child: Icon(
                                        Icons.delete,
                                        color:
                                            _answerControllers.length > 1 &&
                                                (_answerControllers[index]
                                                        .text
                                                        .isNotEmpty ||
                                                    _numEmptyAnswers() > 1)
                                            ? null
                                            : Colors.grey.withAlpha(100),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            children: [
              Opacity(
                opacity: _errorText != null ? 1.0 : 0.0,
                child: Text(
                  "$_errorText",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Remove extra empty answers
                    for (int i = 0; i < _answerControllers.length; i++) {
                      if (_answerControllers[i].text.isEmpty &&
                          i != _answerControllers.length - 1) {
                        _answerControllers.removeAt(i);
                        if (_correctAnswer != null && _correctAnswer! > i) {
                          _correctAnswer = _correctAnswer! - 1;
                        }
                      }
                    }

                    _errorText = _validateBody(_bodyController.text);
                    if (_errorText != null) {
                      _errorBody = true;
                      return;
                    }

                    _errorText = _validateAnswers(
                      _getAnswers(_answerControllers),
                      _correctAnswer,
                    );
                    if (_errorText != null) {
                      _errorAnswers = true;
                      return;
                    }

                    // TODO
                    Question? q = _getQuestion();
                    if (q != null) {
                      widget.onSubmit(q);
                    }

                    Navigator.pop(context);
                  });
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
