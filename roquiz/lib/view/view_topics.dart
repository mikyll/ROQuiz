import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';

class ViewTopics extends StatefulWidget {
  final int quizPool;
  final Map<String, List<Question>> questionsPerTopic;
  final Map<String, bool> selectedTopics;
  final Function(Map<String, bool>) toggleTopic;

  const ViewTopics({
    super.key,
    required this.quizPool,
    required this.questionsPerTopic,
    required this.selectedTopics,
    required this.toggleTopic,
  });

  @override
  State<StatefulWidget> createState() => ViewTopicsState();
}

class ViewTopicsState extends State<ViewTopics> {
  late Map<String, bool> _selectedTopics;

  // Check if selected topics have default values (used to enable/disable "Reset" button)
  bool _isDefault() {
    for (String topic in _selectedTopics.keys) {
      if (!_selectedTopics[topic]!) {
        return false;
      }
    }
    return true;
  }

  // Reset selected topics to default values (all selected)
  void _resetSelectedTopics() {
    setState(() {
      for (String topic in _selectedTopics.keys) {
        _selectedTopics[topic] = true;
      }
    });
  }

  List<Question> _selectedQuestions() {
    List<Question> result = [];

    for (String topic in _selectedTopics.keys) {
      if ((_selectedTopics[topic] ?? false) &&
          widget.questionsPerTopic[topic] != null) {
        result.addAll(widget.questionsPerTopic[topic]!);
      }
    }

    return result;
  }

  bool _isDisabled(String topic) {
    if (!_selectedTopics.keys.contains(topic)) {
      return false;
    }

    // Topic is disabled only if:
    // - the current topic is not deselected
    // - deselecting the topic will still leave enough questions for the quiz pool
    int numCurrent = _selectedQuestions().length;
    int numDeselecting = widget.questionsPerTopic[topic]!.length;

    return !_selectedTopics[topic]! ||
        (numCurrent - numDeselecting) >= widget.quizPool;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedTopics = widget.selectedTopics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        // todo
      },
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Quiz pool: ${widget.quizPool}\nSelected: ${_selectedQuestions().length}",
                    ),
                    // TopicsInfoWidget(
                    //   text: "Domande Totali: ",
                    //   value: widget.qRepo.questions.length,
                    //   color: Colors.indigo.withOpacity(0.35),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ViewQuestions(
                    //           title:
                    //               "Lista domande (${widget.qRepo.questions.length})",
                    //           questions: widget.qRepo.questions,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // TopicsInfoWidget(
                    //   text: "Pool Corrente: ",
                    //   textWeight: FontWeight.bold,
                    //   value: _currentQuizPool,
                    //   color: Colors.indigo.withOpacity(0.35),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ViewQuestions(
                    //           title:
                    //               "Pool corrente (${_getPoolFromSelected().length})",
                    //           questions: _getPoolFromSelected(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // TopicsInfoWidget(
                    //   text: "Domande per Quiz: ",
                    //   value: widget.settings.maxQuestionPerTopic
                    //       ? _currentQuizPool
                    //       : widget.settings.questionNumber,
                    //   color: Colors.indigo.withOpacity(0.35),
                    // ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.questionsPerTopic.length,
                        itemBuilder: (_, index) {
                          String topic = _selectedTopics.keys.elementAt(index);
                          return _TopicTile(
                            topic: topic,
                            isSelected: _selectedTopics[topic]!,
                            onTap: _isDisabled(topic)
                                ? (value) {
                                    setState(() {
                                      _selectedTopics[topic] = value ?? true;
                                      widget.toggleTopic(_selectedTopics);
                                    });
                                  }
                                : null,
                            questionNum:
                                widget.questionsPerTopic[topic]?.length ?? -1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                  icon: const Icon(Icons.refresh, size: 40.0),
                  onPressed: _isDefault()
                      ? null
                      : () {
                          _resetSelectedTopics();
                          // _resetTopics();
                          // _updatePool();
                          // _updateEnabledTopics();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  label: const Text(
                    "Ripristina",
                    maxLines: 1,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

class _TopicTile extends StatelessWidget {
  final String topic;
  final int questionNum;
  final bool isSelected;
  final Function(bool?)? onTap;

  const _TopicTile({
    required this.topic,
    required this.isSelected,
    required this.onTap,
    required this.questionNum,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap != null
            ? () {
                onTap!(!isSelected);
              }
            : null,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  topic,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: onTap == null ? Colors.grey : null,
                  ),
                ),
              ),
            ),
            Container(
              color: null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "($questionNum)",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: onTap == null ? Colors.grey : null,
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(value: isSelected, onChanged: onTap),
            ),
          ],
        ),
      ),
    );
  }
}
