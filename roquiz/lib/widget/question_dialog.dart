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

  String? _topic;
  List<String> _answers = ["", ""];
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
              child: Text(
                widget.question != null ? "Modifica Domanda" : "Nuova Domanda",
                textAlign: TextAlign.center,
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
          constraints: BoxConstraints(maxWidth: 400, minWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.0,
              children: [
                TextFormField(
                  key: GlobalKey(),
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
                      return Row(
                        children: [
                          InkWell(
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
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
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
              // TODO: validate

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
