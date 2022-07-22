import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';

import 'ViewQuestions.dart';

class ViewTopics extends StatefulWidget {
  ViewTopics(
      {Key? key,
      required this.qRepo,
      required this.settings,
      required this.updateQuizPool,
      required this.selectedTopics})
      : super(key: key);

  final QuestionRepository qRepo;
  final Settings settings;
  final Function(int) updateQuizPool;

  List<bool> selectedTopics;

  @override
  State<StatefulWidget> createState() => ViewTopicsState();
}

class ViewTopicsState extends State<ViewTopics> {
  List<bool> _enabledTopics =
      []; // current state of checkboxes (enabled/disabled). If disabled it cannot be selected
  int _currentQuizPool = 0;

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

  void _updateEnabledTopics() {
    setState(() {
      for (int i = 0; i < _enabledTopics.length; i++) {
        // se il numero del pool meno queste è minore del numero di domande nel quiz
        _enabledTopics[i] = true;

        if (widget.selectedTopics[i]) {
          _enabledTopics[i] = _currentQuizPool - widget.qRepo.qNumPerTopic[i] >=
              widget.settings.questionNumber;
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentQuizPool = _getPoolSize();
      for (int i = 0; i < widget.selectedTopics.length; i++) {
        _enabledTopics.add(widget.selectedTopics[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.updateQuizPool(_currentQuizPool);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          title: const Text("Argomenti"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              widget.updateQuizPool(_currentQuizPool);
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                        color: Colors.indigo[700],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Domande Totali: ",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        )),
                  ),
                  Container(
                      color: Colors.indigo[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.qRepo.questions.length}",
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      )),
                ]),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                        color: Colors.indigo[700],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Dimensione Pool Corrente: ",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        )),
                  ),
                  Container(
                      color: Colors.indigo[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("$_currentQuizPool",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      )),
                ]),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                        color: Colors.indigo[700],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Domande per Quiz: ",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        )),
                  ),
                  Container(
                      color: Colors.indigo[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.settings.questionNumber}",
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      )),
                ]),
              ),
              const SizedBox(height: 25),
              ...List.generate(
                widget.qRepo.getTopics().length,
                (index) => InkWell(
                  enableFeedback: true,
                  onTap: () {
                    if (_enabledTopics[index] ||
                        !widget.selectedTopics[index]) {
                      _selectTopic(index);
                    }
                  },
                  child: Column(children: [
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            activeColor: Color(0xFF00FFCB)
                                .withOpacity(_enabledTopics[index] ? 1.0 : 0.5),
                            checkColor: Colors.black
                                .withOpacity(_enabledTopics[index] ? 1.0 : 0.5),
                            value: widget.selectedTopics[index],
                            onChanged: (_) => _enabledTopics[index] ||
                                    !widget.selectedTopics[index]
                                ? _selectTopic(index)
                                : null),
                        Expanded(
                          child: Text(
                              "${widget.qRepo.topics[index]} (${widget.qRepo.qNumPerTopic[index]})",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(
                                      _enabledTopics[index] ? 1.0 : 0.5))),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewQuestions(
                                        qRepo: widget.qRepo, iTopic: index)));
                          },
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                enableFeedback: true,
                onTap: () {
                  _resetTopics();
                  _updatePool();
                  _updateEnabledTopics();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 160,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Ripristina",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
