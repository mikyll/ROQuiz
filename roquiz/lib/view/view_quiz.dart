import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';
import 'package:roquiz/model/style/theme_provider.dart';
import 'package:roquiz/widget/question_card.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _writtenGradeKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _writtenGradeController = TextEditingController();
  int _dragDirectionDX = 0;

  Timer? _timer;
  int _timerCounter = -1;
  bool _showTimer = true;

  late Quiz _quiz;
  bool _isQuizOver = false;
  int _iQuestion = 0;

  int _correctAnswers = 0;
  int? _writtenGrade;
  int _quizGrade = 0;
  double _totalGrade = -1;

  void _previousQuestion() {
    setState(() {
      if (_iQuestion > 0) {
        _iQuestion--;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_iQuestion < widget.questionNum - 1) {
        _iQuestion++;
      }
    });
  }

  void _startQuiz() {
    setState(() {
      _quiz = Quiz(
        questions: widget.quizPool,
        questionNum: widget.questionNum,
        shuffleAnswers: widget.shuffleAnswers,
      );
      _iQuestion = 0;
      _isQuizOver = false;

      // TODO
      // _startTimer(widget.timer * 60);
      _startTimer(10);
    });
  }

  bool isGradeValid(int? grade) {
    return grade != null && grade >= 0 && grade <= 32;
  }

  int _calculateQuizGrade(int numQuestions, int numCorrectAnswers) {
    return (numQuestions > 0
        ? (numCorrectAnswers / numQuestions * 16 * 2).round()
        : 0);
  }

  double _calculateTotalGrade(int writtenGrade, int quizGrade) {
    return writtenGrade * 2 / 3 + quizGrade / 3;
  }

  void _endQuiz() {
    setState(() {
      _isQuizOver = true;
      _timer?.cancel();

      _correctAnswers = _quiz.countCorrectAnswers();
      _quizGrade = _calculateQuizGrade(widget.questionNum, _correctAnswers);

      // Calculate if user had already entered the written grade
      if (_writtenGrade != null) {
        _totalGrade = _calculateTotalGrade(_writtenGrade!, _quizGrade);
      }
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
    String hours = "${_timerCounter ~/ 3600}".padLeft(2, '0');
    String minutes = "${_timerCounter ~/ 60}".padLeft(2, '0');
    String seconds = "${_timerCounter % 60}".padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _startQuiz();
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 20.0,
                        right: 20.0,
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
                              ? QuestionCard.quizOver(
                                  question: _quiz.questions[_iQuestion],
                                  selectedAnswer:
                                      _quiz.selectedAnswers[_iQuestion],
                                )
                              : QuestionCard.quiz(
                                  question: _quiz.questions[_iQuestion],
                                  selectedAnswer:
                                      _quiz.selectedAnswers[_iQuestion],
                                  onAnswerSelected: (int? iAnswer) {
                                    setState(() {
                                      _quiz.selectedAnswers[_iQuestion] =
                                          iAnswer;
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Risposte corrette: $_correctAnswers/${widget.questionNum}\n"
                                        "Risposte errate: ${widget.questionNum - _correctAnswers}\n"
                                        "Voto quiz: $_quizGrade",
                                        maxLines: 4,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      key: _writtenGradeKey,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Il voto dev'essere non nullo.";
                                        }

                                        final int? grade = int.tryParse(value);
                                        if (!isGradeValid(grade)) {
                                          return "Il voto dev'essere compreso tra 0 e 32.";
                                        }

                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _totalGrade = -1;
                                          _writtenGrade = int.tryParse(
                                            _writtenGradeController.text,
                                          );
                                        });
                                      },
                                      onFieldSubmitted: (value) {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          setState(() {
                                            _totalGrade = _calculateTotalGrade(
                                              _writtenGrade!,
                                              _quizGrade,
                                            );
                                          });
                                        }
                                      },
                                      textInputAction: TextInputAction.none,
                                      controller: _writtenGradeController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: "Voto della prova scritta",
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          setState(() {
                                            _totalGrade = _calculateTotalGrade(
                                              _writtenGrade!,
                                              _quizGrade,
                                            );
                                          });
                                        }
                                      },
                                      child: const Text("Calcola voto finale"),
                                    ),
                                    Opacity(
                                      opacity:
                                          _writtenGrade == null ||
                                              _totalGrade == -1
                                          ? 0.0
                                          : 1.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: "Voto finale: "),
                                              TextSpan(
                                                text:
                                                    "${min(_totalGrade.round(), 30)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (_totalGrade > 30.5)
                                                TextSpan(
                                                  text: "L",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              TextSpan(
                                                text:
                                                    " (${_totalGrade.toStringAsFixed(1)})",
                                              ),
                                            ],
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
