import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/completed_quiz_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/device.dart';
import 'package:roquiz/model/utils/grade.dart';
import 'package:roquiz/model/utils/time.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/grade.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/result_card.dart';

import 'package:flutter/foundation.dart';

class ViewQuiz extends StatefulWidget {
  final List<Question> quizPool;
  final int questionNum;
  final int timer;
  final bool shuffleAnswers;
  final CompletedQuizRepository completedQuizRepository;

  const ViewQuiz({
    super.key,
    required this.quizPool,
    required this.questionNum,
    required this.timer,
    required this.shuffleAnswers,
    required this.completedQuizRepository,
  });

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _writtenGradeController = TextEditingController();

  final List<ConfettiController> _confettiControllers = List.generate(5, (
    index,
  ) {
    return ConfettiController(duration: Duration(milliseconds: 250));
  });

  late List<ConfettiWidget> _confettiWidgets = [];

  int _dragDirectionDX = 0;

  Timer? _timer;
  int _timerCounter = -1;
  bool _showTimer = true;

  late Quiz _quiz;
  bool _isQuizOver = false;
  int _iQuestion = 0;

  int _correctAnswers = 0;
  int _quizGrade = 0;
  double? _totalGrade;
  (double, double)? _totalGradeRange;

  // TODO
  bool _showResultCard = false;
  bool _showConfetti = false;
  bool _showGrade = false;

  // TODO: test (remove this)
  bool _maxQuizGrade = false;

  // This indicates that the confetti animation was already played for this quiz run
  bool _confettiPlayed = false;

  Color? _getTimerColor() {
    // TODO: yellow, orange, red colors when time is low

    return null;
  }

  bool _canPlayConfetti(List<ConfettiController> controllers) {
    for (ConfettiController c in controllers) {
      if (c.state == ConfettiControllerState.playing) {
        return false;
      }
    }
    return true;
  }

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

  /// Debug helper for the AppBar max-grade switch: selects the correct answer
  /// for every question when [correct] is true, or clears all selections when
  /// false. Re-applied in [_startQuiz] so the toggle carries across restarts.
  void _setAllAnswersCorrect(bool correct) {
    for (int i = 0; i < _quiz.selectedAnswers.length; i++) {
      _quiz.selectedAnswers[i] = correct
          ? _quiz.questions[i].correctAnswer
          : null;
    }
  }

  void _startQuiz() {
    setState(() {
      _quiz = Quiz(
        questions: widget.quizPool,
        questionNum: widget.questionNum,
        shuffleAnswers: widget.shuffleAnswers,
      );
      // Carry the debug max-grade toggle across restarts: a fresh quiz starts
      // with empty selections, so re-select the correct answers if it's on.
      if (_maxQuizGrade) {
        _setAllAnswersCorrect(true);
      }
      _iQuestion = 0;
      _isQuizOver = false;

      _confettiPlayed = false;
      _showGrade = false;
      _showResultCard = false;

      _totalGrade = null;
      _totalGradeRange = null;

      for (ConfettiController c in _confettiControllers) {
        c.stop();
      }

      _startTimer(widget.timer * 60);
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
        _endQuiz(null);
      }
    });
  }

  void _endQuiz(int? writtenGrade) {
    // Idempotent: the quiz can be ended only once per run. Without this guard
    // ending it (Termina/timeout) and then leaving via the back button would
    // run the grading and save the quiz to history twice (duplicate entries).
    if (_isQuizOver) {
      return;
    }

    setState(() {
      _isQuizOver = true;
      _timer?.cancel();

      _correctAnswers = _quiz.countCorrectAnswers();
      _quizGrade = calculateQuizGrade(widget.questionNum, _correctAnswers);

      // Calculate if user had already entered the written grade
      if (writtenGrade != null) {
        _totalGrade = calculateTotalGrade(writtenGrade, _quizGrade);

        if (!_confettiPlayed &&
            _totalGrade! > 30.0 &&
            _canPlayConfetti(_confettiControllers)) {
          for (ConfettiController c in _confettiControllers) {
            c.play();
          }

          setState(() {
            _confettiPlayed = true;
          });
        }

        setState(() {
          _showGrade = true;
        });
      } else {
        _totalGradeRange = calculateTotalGradeRange(_quizGrade);
      }
      setState(() {
        _showResultCard = true;
      });
    });

    _saveQuizToHistory(writtenGrade);
  }

  void _saveQuizToHistory(int? writtenGrade) {
    final QuizCompleted completed = QuizCompleted.fromSnapshot(
      questions: _quiz.questions,
      selectedAnswers: _quiz.selectedAnswers,
      timestamp: DateTime.now(),
      timeSpent: widget.timer * 60 - _timerCounter,
      correctAnswers: _correctAnswers,
      writtenGrade: writtenGrade,
    );

    widget.completedQuizRepository.add(completed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    _writtenGradeController.dispose();
    for (ConfettiController c in _confettiControllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _confettiWidgets = List.generate(_confettiControllers.length, (index) {
      final int max = _confettiControllers.length;
      final double tot = 30.0;
      final double offset = 7.5;

      final double directionStep = (tot - offset * 2) / (max - 1).toDouble();
      final double particlesMultiplier = index - (max / 2.0);

      return ConfettiWidget(
        confettiController: _confettiControllers[index],
        blastDirectionality: BlastDirectionality.explosive,
        // NB: -pi / 2 is upwards
        blastDirection: -pi * (offset + directionStep * index) / tot,
        emissionFrequency: 0.20,
        numberOfParticles: (20 - (5 * particlesMultiplier).abs()).round(),
        maxBlastForce: 50,
        minBlastForce: 20,
        gravity: 0.3,
        shouldLoop: false,
        particleDrag: 0.05,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
        ],
      );
    });

    _startQuiz();
  }

  /// Style for the bottom-bar nav arrows. Borrows the ElevatedButton theme's
  /// background and foreground so the arrows match the adjacent Termina/Riavvia
  /// button — including its greyed *disabled* look, so a boundary arrow (first
  /// or last question, with `onPressed: null`) reads as disabled.
  ButtonStyle _navArrowStyle(BuildContext context) {
    final ButtonStyle? elevated = Theme.of(context).elevatedButtonTheme.style;
    return ButtonStyle(
      backgroundColor: elevated?.backgroundColor,
      iconColor: elevated?.foregroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context);
    final Size windowSize = getLogicalSize();

    return PopScope(
      canPop: true, //!widget.settings.confirmAlerts,
      onPopInvokedWithResult: (didPop, Object? result) {
        if (didPop) {
          return;
        }

        // TODO: confirmation alert
      },
      child:
          // TODO: move with arrow keys
          GestureDetector(
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
              appBar: ConstrainedAppBar(
                maxWidth: 500.0,
                title: const Text("Quiz"),
                leading: CustomBackButton(
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
                    _endQuiz(settings.writtenGrade);
                    Navigator.pop(context);
                    // }
                  },
                ),
                // TODO: add toggle dark mode?
                actions: [
                  if (kDebugMode)
                    Switch(
                      value: _maxQuizGrade,
                      onChanged: (value) {
                        setState(() {
                          _maxQuizGrade = value;
                          _setAllAnswersCorrect(value);
                        });
                      },
                      activeTrackColor: Colors.white,
                    ),
                ],
              ),
              body: SelectionArea(
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500.0),
                      child: Stack(
                        children: [
                          Column(
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
                                      style: TextTheme.of(context)
                                          .headlineSmall!
                                          .copyWith(
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
                                        opacity: _showTimer || _isQuizOver
                                            ? 1.0
                                            : 0.0,
                                        child: RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                            style: TextTheme.of(context)
                                                .headlineSmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            children: [
                                              const TextSpan(text: 'Time: '),
                                              TextSpan(
                                                text: getTimeString(
                                                  _timerCounter,
                                                ),
                                                style: TextTheme.of(context)
                                                    .headlineSmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _getTimerColor(),
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
                                    padding: EdgeInsets.only(
                                      // TODO: get result card height using key
                                      bottom: _isQuizOver ? 240.0 : 0,
                                    ),
                                    child: _isQuizOver
                                        ? QuestionCard.quizOver(
                                            question:
                                                _quiz.questions[_iQuestion],
                                            selectedAnswer: _quiz
                                                .selectedAnswers[_iQuestion],
                                          )
                                        : QuestionCard.quiz(
                                            question:
                                                _quiz.questions[_iQuestion],
                                            selectedAnswer: _quiz
                                                .selectedAnswers[_iQuestion],
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
                            ],
                          ),
                          // Results card
                          if (_isQuizOver && _showResultCard)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 10,
                              child: Center(
                                child: ResultCard(
                                  correctAnswers: _correctAnswers,
                                  questionNum: widget.questionNum,
                                  quizGrade: _quizGrade,
                                  timerString: getTimeString(
                                    (_timerCounter - settings.quizTime).abs(),
                                  ),
                                  writtenGrade: settings.writtenGrade,
                                  totalGrade: _totalGrade,
                                  totalGradeRange: _totalGradeRange,
                                ),
                              ),
                            ),

                          if (settings.animations && _isQuizOver)
                            Positioned.fill(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _confettiWidgets,
                              ),
                            ),

                          // TODO
                          if (_showGrade && _totalGrade != null)
                            Positioned.fill(
                              child: Grade(
                                grade: _totalGrade!,
                                gradeBase: 30.0,
                                animate: settings.animations,
                                onTapAfterAnimationFinished: () {
                                  setState(() {
                                    _showGrade = false;
                                  });
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
                  color: Theme.of(context).highlightColor.withAlpha(70),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 500.0,
                        maxHeight: 70.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Row(
                                spacing: 20.0,
                                children: [
                                  IconButton(
                                    style: _navArrowStyle(context),
                                    onPressed: _iQuestion <= 0
                                        ? null
                                        : () {
                                            // TODO: long press
                                            _previousQuestion();
                                          },
                                    icon: Icon(Icons.arrow_back_ios_rounded),
                                    iconSize: 35,
                                  ),
                                  IconButton(
                                    style: _navArrowStyle(context),
                                    onLongPress:
                                        _iQuestion >= widget.questionNum - 1
                                        ? null
                                        : () {},
                                    onPressed:
                                        _iQuestion >= widget.questionNum - 1
                                        ? null
                                        : () {
                                            // TODO: long press
                                            _nextQuestion();
                                          },
                                    icon: Icon(Icons.arrow_forward_ios_rounded),
                                    iconSize: 35,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: windowSize.width < 500
                                  ? 500 - windowSize.width
                                  : 0,
                              bottom: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_isQuizOver) {
                                        _startQuiz();
                                      } else {
                                        _endQuiz(settings.writtenGrade);
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
