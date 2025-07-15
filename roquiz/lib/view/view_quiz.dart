import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';
import 'package:roquiz/model/style/theme_provider.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/question_card_selectable.dart';

class ViewQuiz extends StatefulWidget {
  final List<Question> quizPool;
  final int questionNum;
  final int timer;
  final bool shuffleAnswers;

  const ViewQuiz({
    super.key,
    required this.quizPool,
    required this.questionNum,
    required this.timer,
    required this.shuffleAnswers,
  });

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  final ScrollController _scrollController = ScrollController();

  Timer? _timer;
  int _timerCounter = -1;

  late Quiz _quiz;
  Question? _currentQuestion;
  int _iQuestion = 0;

  bool _showTimer = true;
  bool _isQuizOver = false;

  int _dragDirectionDX = 0;

  void _previousQuestion() {
    setState(() {
      if (_iQuestion > 0) {
        _iQuestion--;
      }
      _currentQuestion = _quiz.questions[_iQuestion];
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_iQuestion < widget.questionNum - 1) {
        _iQuestion++;
      }
      _currentQuestion = _quiz.questions[_iQuestion];
    });
  }

  void _startQuiz() {
    setState(() {
      _quiz = Quiz(
        questions: widget.quizPool,
        questionNum: widget.questionNum,
        shuffleAnswers: widget.shuffleAnswers,
      );
      _currentQuestion = _quiz.questions[0];

      _isQuizOver = false;
      _startTimer(10); //widget.timer * 60);
    });
  }

  void _endQuiz() {
    setState(() {
      _isQuizOver = true;
      _timer?.cancel();
    });
  }

  void _startTimer(int startTime) {
    setState(() {
      _timerCounter = startTime;
    });

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCounter > 0) {
        setState(() {
          _timerCounter--;
        });
      } else {
        _endQuiz();
      }
    });
  }

  String _getTimeString() {
    String minutes = "${_timerCounter ~/ 60}".padLeft(2, '0');
    String seconds = "${_timerCounter % 60}".padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _startQuiz();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, //!widget.settings.confirmAlerts,
      onPopInvokedWithResult: (didPop, Object? result) {
        if (didPop) {
          return;
        }

        // ConfirmationAlert.showConfirmationDialog(
        //   context,
        //   "Conferma",
        //   "Sei sicuro di voler uscire dal quiz?",
        //   onConfirm: () {
        //     _endQuiz(); // end quiz and stop timer
        //     Navigator.pop(context);
        //   },
        //   onCancel: () {},
        // );
      },
      child: GestureDetector(
        onTapDown: (details) {},
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
          // _loadQuestion();
          _dragDirectionDX = 0;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Quiz"),
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
                // if (widget.settings.confirmAlerts) {
                //   ConfirmationAlert.showConfirmationDialog(
                //     context,
                //     "Conferma",
                //     "Sei sicuro di voler uscire dal quiz?",
                //     onConfirm: () {
                //       _endQuiz(); // end quiz and stop timer
                //       Navigator.pop(context);
                //     },
                //     onCancel: () {},
                //   );
                // } else {
                _endQuiz();
                Navigator.pop(context);
                // }
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "D${_iQuestion + 1}/${widget.questionNum}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 1),
                      InkWell(
                        onTap: _isQuizOver
                            ? null
                            : () {
                                setState(() {
                                  _showTimer = !_showTimer;
                                });
                              },
                        child: Opacity(
                          opacity: _showTimer || _isQuizOver ? 1.0 : 0.0,
                          child: RichText(
                            maxLines: 1,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                // color: themeProvider.isDarkMode
                                //     ? Colors.white
                                //     : Colors.black,
                              ),
                              children: [
                                const TextSpan(text: 'Time: '),
                                TextSpan(
                                  text: _getTimeString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    // color: _getTimerColor(themeProvider),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    primary: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _isQuizOver
                          ? QuestionCard(
                              question: _currentQuestion!,
                              selectedAnswer: _quiz.selectedAnswers[_iQuestion],
                            )
                          : QuestionCardSelectable(
                              question: _currentQuestion!,
                              selectedAnswer: _quiz.selectedAnswers[_iQuestion],
                              onAnswerSelected: (int? iAnswer) {
                                setState(() {
                                  _quiz.selectedAnswers[_iQuestion] = iAnswer;
                                });
                              },
                            ),
                    ),
                  ),
                ),
                // Results card
                if (_isQuizOver)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).disabledColor,
                              spreadRadius: 0.5,
                              blurRadius: 2,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "todo",
                            // "Risposte corrette: $_correctAnswers/$_questionNumber\n"
                            // "Risposte errate: ${_questionNumber - _correctAnswers}/$_questionNumber\n"
                            // "Range di voto finale, in base allo scritto: [${(11.33 + _correctAnswers ~/ 3).toInt().toString()}, ${22 + _correctAnswers * 2 ~/ 3}]",
                            maxLines: 4,
                          ),
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
                top: BorderSide(color: Theme.of(context).disabledColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Show previous question
                  IconButton(
                    onPressed: () {
                      _previousQuestion();
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    iconSize: 35,
                  ),
                  const SizedBox(width: 20),
                  // Show next question
                  IconButton(
                    onPressed: () {
                      _nextQuestion();
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    iconSize: 35,
                  ),
                  const SizedBox(width: 20),
                  const Spacer(flex: 5),
                  // End/Restart quiz
                  ElevatedButton(
                    onPressed: () {
                      if (_isQuizOver) {
                        _startQuiz();
                      } else {
                        _endQuiz();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: 100.0,
                      child: Text(
                        !_isQuizOver ? "Termina" : "Riavvia",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
