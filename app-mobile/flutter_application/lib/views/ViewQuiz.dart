import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Quiz.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/model/Themes.dart';
import 'package:roquiz/widget/confirmation_alert.dart';
import 'package:roquiz/widget/icon_button_widget.dart';
import 'package:roquiz/widget/question_widget.dart';

class ViewQuiz extends StatefulWidget {
  const ViewQuiz({Key? key, required this.questions, required this.settings})
      : super(key: key);

  final List<Question> questions;
  final Settings settings;

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  final ScrollController _scrollController = ScrollController();

  final Quiz _quiz = Quiz();

  bool _showTime = true;
  bool _isOver = false;
  int _qIndex = 0;
  int _correctAnswers = 0;

  String _currentQuestion = "";
  List<String> _currentAnswers = [];

  List<Answer> _userAnswers = [];
  int _questionNumber = 0;

  late Timer _timer;
  int _timerCounter = -1;

  int _dragDirectionDX = 0;

  final TextEditingController _writtenGradeController = TextEditingController();
  double? _finalGrade;
  double? _quizGrade;

  void _previousQuestion() {
    setState(() {
      if (_qIndex > 0) _qIndex--;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_qIndex < _questionNumber - 1) _qIndex++;
    });
  }

  void _loadQuestion() {
    setState(() {
      _currentQuestion = _quiz.questions[_qIndex].question;
      _currentAnswers = _quiz.questions[_qIndex].answers;
    });
  }

  void _setUserAnswer(int answer) {
    setState(() {
      _userAnswers[_qIndex] = _userAnswers[_qIndex] != Answer.values[answer]
          ? Answer.values[answer]
          : Answer.NONE;
      if (Answer.values[answer] == _quiz.questions[_qIndex].correctAnswer) {}
    });
  }

  void _endQuiz() {
    setState(() {
      _isOver = true;
      _timer.cancel();
    });
    for (int i = 0; i < _questionNumber; i++) {
      if (_userAnswers[i] == _quiz.questions[i].correctAnswer) {
        _correctAnswers++;
      }
    }
    _quiz.correctAnswer = _correctAnswers;
    _quiz.questions = widget.questions;
    _quizGrade = _quiz.getQuizGrade();

  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCounter > 0) {
          _timerCounter--;
        } else {
          _endQuiz();
        }
      });
    });
  }

  void _resetQuiz() {
    setState(() {
      if (widget.settings.maxQuestionPerTopic) {
        _questionNumber = widget.questions.length;
      } else {
        _questionNumber = widget.settings.questionNumber;
      }

      _userAnswers = [];
      for (int i = 0; i < _questionNumber; i++) {
        _userAnswers.add(Answer.NONE);
      }

      _quiz.resetQuiz(widget.questions, widget.questions.length,
          widget.settings.shuffleAnswers);

      _qIndex = 0;
      _correctAnswers = 0;
      _isOver = false;
      _currentQuestion = _quiz.questions[_qIndex].question;
      _currentAnswers = _quiz.questions[_qIndex].answers;

      _timerCounter = widget.settings.timer * 60;
    });
    _startTimer();
  }

  Color _getTimerColor(ThemeProvider themeProvider) {
    Color res = themeProvider.isDarkMode ? Colors.white : Colors.black;

    if (_timerCounter < widget.settings.timer * 60 / 6) {
      res = themeProvider.isDarkMode ? Colors.yellow : Colors.yellow[700]!;
    }
    if (_timerCounter < widget.settings.timer * 60 / 9) {
      res = themeProvider.isDarkMode ? Colors.orange : Colors.orange[700]!;
    }
    if (_timerCounter < widget.settings.timer * 60 / 18) {
      res = Colors.red;
    }

    return res;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _quiz.resetQuiz(widget.questions, widget.questions.length,
        widget.settings.shuffleAnswers);
    _resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return PopScope(
      canPop: !widget.settings.confirmAlerts,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        ConfirmationAlert.showConfirmationDialog(
          context,
          "Conferma",
          "Sei sicuro di voler uscire dal quiz?",
          onConfirm: () {
            _endQuiz(); // end quiz and stop timer
            Navigator.pop(context);
          },
          onCancel: () {},
        );
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
          _loadQuestion();
          _dragDirectionDX = 0;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Quiz"),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (widget.settings.confirmAlerts) {
                  ConfirmationAlert.showConfirmationDialog(
                    context,
                    "Conferma",
                    "Sei sicuro di voler uscire dal quiz?",
                    onConfirm: () {
                      _endQuiz(); // end quiz and stop timer
                      Navigator.pop(context);
                    },
                    onCancel: () {},
                  );
                } else {
                  _endQuiz();
                  Navigator.pop(context);
                }
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
                      top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "D${_qIndex + 1}/$_questionNumber",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 1),
                      InkWell(
                        onTap: _isOver
                            ? null
                            : () {
                                setState(() {
                                  _showTime = !_showTime;
                                });
                              },
                        child: Opacity(
                          opacity: _showTime || _isOver ? 1.0 : 0.0,
                          child: RichText(
                            maxLines: 1,
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                              children: [
                                const TextSpan(text: 'Time: '),
                                TextSpan(
                                  text:
                                      "${_timerCounter ~/ 60}:${(_timerCounter % 60).toInt() < 10 ? "0${(_timerCounter % 60).toInt()}" : (_timerCounter % 60).toInt()}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: _getTimerColor(themeProvider),
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
                      child: QuestionWidget(
                        questionText: _currentQuestion,
                        answers: _currentAnswers,
                        highlightAnswer: _isOver,
                        userAnswer: _userAnswers[_qIndex],
                        correctAnswer: widget.questions[_qIndex].correctAnswer,
                        onTapAnswer: !_isOver
                            ? (int index) => _setUserAnswer(index)
                            : null,
                        backgroundQuizColor: Colors.cyan.withOpacity(0.1),
                        defaultAnswerColor: Colors.indigo.withOpacity(0.2),
                        selectedAnswerColor: Colors.indigo.withOpacity(0.5),
                        correctAnswerColor:
                            const Color.fromARGB(255, 42, 255, 49)
                                .withOpacity(0.5),
                        correctNotSelectedAnswerColor:
                            const Color.fromARGB(255, 27, 94, 32)
                                .withOpacity(0.8),
                        wrongAnswerColor: Colors.red.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                // Results card
               _isOver
                ? Padding(
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
                          child: Column(
                            children: [
                              Text(
                                "Risposte corrette: $_correctAnswers/$_questionNumber\n"
                                "Risposte errate: ${_questionNumber - _correctAnswers}/$_questionNumber\n"
                                "Voto quiz: ${_quizGrade?.toStringAsFixed(1) ?? "-"}",
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _writtenGradeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Inserisci voto della prova scritta (opzionale)",
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  final written = double.tryParse(_writtenGradeController.text);
                                  if (written != null && _quizGrade != null) {
                                    setState(() {
                                      _finalGrade = ((written * 2) + _quizGrade!) / 3;
                                    });
                                  }
                                },
                                child: const Text("Calcola voto finale"),
                              ),
                              if (_finalGrade != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("Voto finale: ${_finalGrade!.toStringAsFixed(1)}"),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
  : const Text(""),
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
              child: Row(
                children: [
                  // Show previous question
                  IconButtonLongPressWidget(
                    lightPalette: MyThemes.lightIconButtonPalette,
                    darkPalette: MyThemes.darkIconButtonPalette,
                    onUpdate: _qIndex > 0
                        ? () {
                            _previousQuestion();
                            _loadQuestion();
                          }
                        : null,
                    width: 50.0,
                    height: 50.0,
                    icon: Icons.arrow_back_ios_rounded,
                    iconSize: 35,
                  ),
                  const SizedBox(width: 20),
                  // Show next question
                  IconButtonLongPressWidget(
                    lightPalette: MyThemes.lightIconButtonPalette,
                    darkPalette: MyThemes.darkIconButtonPalette,
                    onUpdate: _qIndex < _questionNumber - 1
                        ? () {
                            _nextQuestion();
                            _loadQuestion();
                          }
                        : null,
                    width: 50.0,
                    height: 50.0,
                    icon: Icons.arrow_forward_ios_rounded,
                    iconSize: 35,
                  ),
                  const Spacer(flex: 5),
                  // End/Restart quiz
                  ElevatedButton(
                    onPressed: () {
                      if (_isOver) {
                        _resetQuiz();
                      } else {
                        String unanswered = "";
                        for (int i = 0; i < _userAnswers.length; i++) {
                          if (_userAnswers[i] == Answer.NONE) {
                            unanswered += unanswered.isNotEmpty ? ", " : "";
                            unanswered += "${i + 1}";
                          }
                        }
                        if (unanswered.isNotEmpty) {
                          ConfirmationAlert.showConfirmationDialog(
                            context,
                            "Terminare il quiz?",
                            "Non hai risposto alle seguenti domande: $unanswered",
                            onConfirm: () {
                              _endQuiz();
                            },
                            onCancel: () {},
                          );
                        } else {
                          _endQuiz();
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: 100.0,
                      child: Text(
                        !_isOver ? "Termina" : "Riavvia",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
