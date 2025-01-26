import 'package:flutter/material.dart';
import 'package:roquiz/model/constants.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/view/view_questions.dart';
import 'package:roquiz/widget/quiz/topic.dart';

class ViewTopics extends StatefulWidget {
  const ViewTopics({
    super.key,
    required this.questionRepository,
    required this.selectedTopics,
    required this.numQuizQuestions,
    required this.updateQuizValues,
  });

  final QuestionRepository questionRepository;
  final Map<String, bool> selectedTopics;
  final int numQuizQuestions;
  final void Function() updateQuizValues;

  @override
  State<StatefulWidget> createState() => ViewTopicsState();
}

class ViewTopicsState extends State<ViewTopics> {
  Map<String, List<Question>> _questions = {};
  Map<String, bool> _selectedTopics = {};

  void _toggleTopic(String topic) {
    setState(() {
      _selectedTopics[topic] = !_selectedTopics[topic]!;
    });
  }

  bool _isDefault() {
    for (bool value in _selectedTopics.values) {
      if (!value) return false;
    }
    return true;
  }

  void _resetDefaults() {
    setState(() {
      _selectedTopics = {for (var value in _selectedTopics.keys) value: true};
    });
  }

  List<Question> _getSelectedQuestions({String? topic}) {
    List<Question> questions = [];

    if (topic != null) {
      questions = _questions[topic]!;
      return questions;
    }

    for (String topic in _selectedTopics.keys) {
      if (_selectedTopics[topic]!) {
        questions.addAll(_questions[topic]!);
      }
    }

    return questions;
  }

  bool _canBeDeselected(String topic) {
    // TODO: update for full topics
    return !_selectedTopics[topic]! ||
        (_getSelectedQuestions().length - _questions[topic]!.length >
            widget.numQuizQuestions);
  }

  @override
  void initState() {
    super.initState();

    _questions = widget.questionRepository.getGroupedQuestions();
    _selectedTopics = widget.selectedTopics;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
      },
      // TODO: PopScope?
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Argomenti"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
            ),
            onPressed: () {
              widget.updateQuizValues();
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.white),
                overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
                backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewQuestions(
                      title:
                          "Lista domande (${widget.questionRepository.getQuestions().length})",
                      questions: widget.questionRepository.getQuestions(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopicsInfoWidget(
                    textWeight: FontWeight.bold,
                    label: "Pool Domande: ",
                    value:
                        "${_getSelectedQuestions().length} / ${widget.questionRepository.getQuestions().length}",
                    color: Color(0x593f51b5),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewQuestions(
                            title:
                                "Lista domande (${_getSelectedQuestions().length})",
                            questions: _getSelectedQuestions(),
                          ),
                        ),
                      );
                    },
                  ),
                  TopicsInfoWidget(
                    label: "Domande per Quiz: ",
                    value:
                        "${widget.numQuizQuestions} / ${_getSelectedQuestions().length}",
                    color: Color(0x593f51b5),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.questionRepository.getTopics().length,
                      itemBuilder: (_, index) {
                        String topic = _questions.keys.toList()[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TopicWidget(
                            checkBoxValue: _selectedTopics[topic]!,
                            onCheckBoxChanged: _canBeDeselected(topic)
                                ? (_) {
                                    _toggleTopic(topic);
                                  }
                                : null,
                            onPressedButton: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewQuestions(
                                            title: topic,
                                            questions: _getSelectedQuestions(
                                                topic: topic),
                                          )));
                            },
                            text: widget.questionRepository.getTopics()[index],
                            questionNum: _questions[topic]!.length,
                            textSize: 20.0,
                            lightTextColor: Colors.black,
                            darkTextColor: Colors.white,
                            disabled: !_canBeDeselected(topic),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(color: Theme.of(context).disabledColor),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              heightFactor: 1,
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.refresh,
                    size: 40.0,
                  ),
                  onPressed: _isDefault()
                      ? null
                      : () {
                          _resetDefaults();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  label: const Text(
                    "Ripristina",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
