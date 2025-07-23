import 'package:flutter/material.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/widget/topics_widget.dart';

import 'ViewQuestions.dart';

class ViewTopics extends StatefulWidget {
  const ViewTopics({
    super.key,
    required this.qRepo,
    required this.settings,
    required this.updateQuizPool,
    required this.selectedTopics,
  });

  final QuestionRepository qRepo;
  final Settings settings;
  final Function(int) updateQuizPool;

  final List<bool> selectedTopics;

  @override
  State<StatefulWidget> createState() => ViewTopicsState();
}

class ViewTopicsState extends State<ViewTopics> {
  final List<bool> _enabledTopics =
      []; // current state of checkboxes (enabled/disabled). If disabled it cannot be selected
  int _currentQuizPool = 0;
  int _selectedTopicsNum = 0;

  // Check if a topic can be selected/deselected.
  // NB: a topic cannot be deselected if the remaining topics do not add up for
  // the pool minimum questions number.
  bool _isEnabled(int index) {
    if (widget.settings.maxQuestionPerTopic) {
      return _selectedTopicsNum > 1 || _enabledTopics[index];
    }
    return _enabledTopics[index] || !widget.selectedTopics[index];
  }

  void _selectTopic(int index) {
    setState(() {
      widget.selectedTopics[index] = !widget.selectedTopics[index];
      _updatePool();
      _updateEnabledTopics();
    });
  }

  void _resetTopics() {
    setState(() {
      for (int i = 0; i < widget.selectedTopics.length; i++) {
        widget.selectedTopics[i] = true;
      }
    });
  }

  bool _isDefault() {
    for (int i = 0; i < widget.selectedTopics.length; i++) {
      if (!widget.selectedTopics[i]) return false;
    }

    return true;
  }

  void _updateEnabledTopics() {
    print(
        "MAX: ${widget.settings.maxQuestionPerTopic}, selectedNum: $_selectedTopicsNum");
    setState(() {
      _selectedTopicsNum = 0;
      for (int i = 0; i < _enabledTopics.length; i++) {
        _enabledTopics[i] = true;

        // la checkbox dell'argomento è abilitata (ovvero è possibile deselezionarlo)
        // solo se, deselezionandolo, nel pool risultante rimarrebbero comunque
        // abbastanza domande per il pool (num domande >= pool)
        if (widget.selectedTopics[i]) {
          _enabledTopics[i] = _currentQuizPool - widget.qRepo.qNumPerTopic[i] >=
              widget.settings.questionNumber;
          _selectedTopicsNum++;
        }
      }
    });
  }

  int _getPoolSize() {
    int res = 0;
    for (int i = 0; i < widget.selectedTopics.length; i++) {
      res += widget.selectedTopics[i] ? widget.qRepo.qNumPerTopic[i] : 0;
    }
    return res;
  }

  void _updatePool() {
    setState(() {
      int res = 0;
      for (int i = 0; i < _enabledTopics.length; i++) {
        res += widget.selectedTopics[i] ? widget.qRepo.qNumPerTopic[i] : 0;
      }
      _currentQuizPool = res;
    });
  }

  List<Question> _getTopicQuestions(int iTopic) {
    List<Question> res = [];
    String topic = widget.qRepo.topics[iTopic];

    for (int i = 0; i < widget.qRepo.questions.length; i++) {
      if (widget.qRepo.questions[i].topic == topic) {
        res.add(widget.qRepo.questions[i]);
      }
    }

    return res;
  }

  List<Question> _getPoolFromSelected() {
    List<Question> res = [];
    for (int i = 0, j = 0; i < widget.selectedTopics.length; i++) {
      if (widget.selectedTopics[i]) {
        for (int k = 0;
            k < widget.qRepo.getQuestionNumPerTopic()[i];
            j++, k++) {
          res.add(widget.qRepo.getQuestions()[j]);
        }
      } else {
        j += widget.qRepo.getQuestionNumPerTopic()[i];
      }
    }

    return res;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentQuizPool = _getPoolSize();
      _selectedTopicsNum = 0;
      for (int i = 0; i < widget.selectedTopics.length; i++) {
        _enabledTopics.add(widget.selectedTopics[i]);

        if (widget.selectedTopics[i]) {
          _selectedTopicsNum++;
        }
      }

      _updateEnabledTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        widget.updateQuizPool(_currentQuizPool);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Argomenti"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              widget.updateQuizPool(_currentQuizPool);
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewQuestions(
                              title:
                                  "Lista domande (${widget.qRepo.questions.length})",
                              questions: widget.qRepo.questions,
                            )));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopicsInfoWidget(
                text: "Domande Totali: ",
                value: widget.qRepo.questions.length,
                color: Colors.indigo.withOpacity(0.35),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewQuestions(
                                title:
                                    "Lista domande (${widget.qRepo.questions.length})",
                                questions: widget.qRepo.questions,
                              )));
                },
              ),
              TopicsInfoWidget(
                text: "Pool Corrente: ",
                textWeight: FontWeight.bold,
                value: _currentQuizPool,
                color: Colors.indigo.withOpacity(0.35),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewQuestions(
                                title:
                                    "Pool corrente (${_getPoolFromSelected().length})",
                                questions: _getPoolFromSelected(),
                              )));
                },
              ),
              TopicsInfoWidget(
                text: "Domande per Quiz: ",
                value: widget.settings.maxQuestionPerTopic
                    ? _currentQuizPool
                    : widget.settings.questionNumber,
                color: Colors.indigo.withOpacity(0.35),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.qRepo.getTopics().length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: TopicWidget(
                      onTap: _isEnabled(index)
                          ? () {
                              _selectTopic(index);
                            }
                          : null,
                      checkBoxValue: widget.selectedTopics[index],
                      onCheckBoxChanged: _isEnabled(index)
                          ? (_) {
                              _selectTopic(index);
                            }
                          : null,
                      onPressedButton: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewQuestions(
                                      title: widget.qRepo.topics[index],
                                      questions: _getTopicQuestions(index),
                                    )));
                      },
                      text: widget.qRepo.topics[index],
                      questionNum: widget.qRepo.getQuestionNumPerTopic()[index],
                      textSize: 20.0,
                      lightTextColor: Colors.black,
                      darkTextColor: Colors.white,
                      disabled: !_isEnabled(index),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                  top: BorderSide(color: Theme.of(context).disabledColor))),
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
                          _resetTopics();
                          _updatePool();
                          _updateEnabledTopics();
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
