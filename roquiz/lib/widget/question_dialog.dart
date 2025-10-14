import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';

class QuestionDialog extends StatefulWidget {
  // TODO: topics list
  final List<String>? topicsList;
  final void Function(Question) onSubmit;
  final Question? question;

  const QuestionDialog({
    super.key,
    required this.onSubmit,
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

  String? _body;
  String? _topic;
  List<String> _answers = [""];
  int? _correctAnswer;

  Question? getQuestion() {
    Question? question;

    try {
      question = Question(
        body: _bodyController.text,
        topic: _topic,
        answers: _answers,
        correctAnswer: _correctAnswer!,
      );
    } catch (_) {}

    return question;
  }

  String? validateBody(String? value) {
    if (value!.isEmpty) {
      return "Il corpo della domanda dev'essere non vuoto";
    }

    return "";
  }

  String? validateAnswer(String? value) {
    // TODO: validate:
    // - no empty body
    // - ok topic
    // - at least 2 answers
    // - selected correct answer

    return "";
  }

  @override
  void initState() {
    super.initState();

    if (widget.topicsList != null) {
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
          constraints: BoxConstraints(maxHeight: 500, maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.0,
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    key: GlobalKey(),
                    validator: validateBody,
                    controller: _bodyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Corpo"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      onChanged: (_) {},
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
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              // TODO: call validate

              // TODO
              //widget.onSubmit();

              //if (validateBody(value))

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
