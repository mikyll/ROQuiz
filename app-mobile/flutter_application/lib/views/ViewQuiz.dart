import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Settings.dart';

class ViewQuiz extends StatefulWidget {
  const ViewQuiz(
      {Key? key,
      required this.questions,
      required this.settings,
      required this.resetTopics})
      : super(key: key);

  final List<Question> questions;
  final Settings settings;
  final Function() resetTopics;

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  bool _isOver = false;

  int _qIndex = 0;
  int _correctAnswers = 0;

  String _currentQuestion = "";
  List<String> _currentAnswers = [];

  List<Answer> _userAnswers = [];
  //List<Answer>.filled(maxQuestion, Answer.NONE, growable: true);

  late Timer _timer;
  int _timerCounter = -1;

  int _dragDirectionDX = 0;

  void _previousQuestion() {
    setState(() {
      if (_qIndex > 0) _qIndex--;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_qIndex < widget.settings.questionNumber - 1) _qIndex++;
    });
  }

  void _loadQuestion() {
    setState(() {
      _currentQuestion = widget.questions[_qIndex].question;
      _currentAnswers = widget.questions[_qIndex].answers;
    });
  }

  void _setUserAnswer(int answer) {
    setState(() {
      _userAnswers[_qIndex] = Answer.values[answer];
      if (Answer.values[answer] == widget.questions[_qIndex].correctAnswer) {}
    });
  }

  void _endQuiz() {
    setState(() {
      _isOver = true;
      _timer.cancel();
    });
    for (int i = 0; i < widget.settings.questionNumber; i++) {
      if (_userAnswers[i] == widget.questions[i].correctAnswer) {
        _correctAnswers++;
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCounter > 0) {
          _timerCounter--;
        } else {
          _timer.cancel();
          _endQuiz();
        }
      });
    });
  }

  void _resetQuiz() {
    setState(() {
      _userAnswers = [];
      for (int i = 0; i < widget.settings.questionNumber; i++) {
        _userAnswers.add(Answer.NONE);
      }
      widget.questions.shuffle();

      _qIndex = 0;
      _correctAnswers = 0;
      _isOver = false;
      _currentQuestion = widget.questions[_qIndex].question;
      _currentAnswers = widget.questions[_qIndex].answers;

      _timerCounter = widget.settings.timer * 60;
    });
    _startTimer();
  }

  @override
  void initState() {
    super.initState();

    _resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // this enables us to catch the "hard back" from device
      onWillPop: () async {
        _endQuiz(); // end quiz and stop timer
        widget.resetTopics();
        return true; // "return true" pops the element from the stack (== Navigator.pop())
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            details.delta.dx > 5
                ? _dragDirectionDX = -1
                : (details.delta.dx < -5 ? _dragDirectionDX = 1 : null);
          });
        },
        onPanEnd: (details) {
          _dragDirectionDX > 0
              ? _nextQuestion()
              : (_dragDirectionDX < 0 ? _previousQuestion() : null);
          _loadQuestion();
          _dragDirectionDX = 0;
        },
        child: Scaffold(
          backgroundColor: Colors.indigo[900],
          appBar: AppBar(
            title: const Text("Quiz"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _endQuiz();
                widget.resetTopics();
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AutoSizeText(
                        "Question: ${_qIndex + 1}/${widget.settings.questionNumber}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      AutoSizeText(
                        "Timer: ${_timerCounter ~/ 60}:${(_timerCounter % 60).toInt() < 10 ? "0" + (_timerCounter % 60).toInt().toString() : (_timerCounter % 60).toInt().toString()}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // QUIZ
                  Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // QUESTION
                            child: Text(_currentQuestion,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16)),
                          ),
                        ),
                        // ANSWERS
                        ...List.generate(
                          _currentAnswers.length,
                          (index) => InkWell(
                            enableFeedback: true,
                            onTap: () {
                              if (!_isOver) {
                                _setUserAnswer(index);
                              }
                            },
                            child: Column(children: [
                              const SizedBox(height: 5),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: !_isOver &&
                                            _userAnswers[_qIndex] ==
                                                Answer.values[index]
                                        ? Colors.cyan[900]
                                        : (!_isOver
                                            ? Colors.cyan
                                            : (widget.questions[_qIndex]
                                                            .correctAnswer ==
                                                        Answer.values[index] &&
                                                    (_userAnswers[_qIndex] ==
                                                            Answer.NONE ||
                                                        _userAnswers[_qIndex] !=
                                                            widget
                                                                .questions[
                                                                    _qIndex]
                                                                .correctAnswer)
                                                ? Colors.green[900]
                                                : (widget.questions[_qIndex]
                                                            .correctAnswer ==
                                                        Answer.values[index]
                                                    ? Colors.green
                                                    : (_userAnswers[_qIndex] ==
                                                            Answer.values[index]
                                                        ? Colors.red
                                                        : Colors.cyan)))),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    // current answers
                                    Text(Answer.values[index].name + ") ",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Flexible(
                                      child: Text(_currentAnswers[index],
                                          style: const TextStyle(fontSize: 14)),
                                    ),
                                  ]),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isOver
                      ? Text(
                          "Risposte corrette: $_correctAnswers/${widget.settings.questionNumber}, Risposte errate: ${widget.settings.questionNumber - _correctAnswers}.\nRange di voto finale, in base allo scritto: [${(11.33 + _correctAnswers ~/ 3).toInt().toString()}, ${22 + _correctAnswers * 2 ~/ 3}]")
                      : const Text(""),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [
            Row(
              children: [
                InkWell(
                  enableFeedback: true,
                  onTap: () {
                    _previousQuestion();
                    _loadQuestion();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  enableFeedback: true,
                  onTap: () {
                    _nextQuestion();
                    _loadQuestion();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 50, // fix: fit <->
                    height: 50,
                    decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(flex: 5),
                InkWell(
                  enableFeedback: true,
                  onTap: () {
                    !_isOver ? _endQuiz() : _resetQuiz();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Text(!_isOver ? "Termina" : "Riavvia",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
