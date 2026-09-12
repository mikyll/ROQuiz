import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/completed_quiz_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/grade.dart';
import 'package:roquiz/model/utils/time.dart';
import 'package:roquiz/view/view_settings.dart';
import 'package:roquiz/widget/confirmation_dialog.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/grade.dart';
import 'package:roquiz/widget/icon_button_acceleration.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/result_card.dart';

import 'package:flutter/foundation.dart';

class ViewQuiz extends StatefulWidget {
  final List<Question> quizPool;
  final int questionNum;
  final int timer;
  final bool shuffleAnswers;
  final CompletedQuizRepository completedQuizRepository;

  /// Size of the full question pool, forwarded to [ViewSettings] when the user
  /// taps the "set your written grade" hint on the result card.
  final int maxQuizPool;

  const ViewQuiz({
    super.key,
    required this.quizPool,
    required this.questionNum,
    required this.timer,
    required this.shuffleAnswers,
    required this.completedQuizRepository,
    required this.maxQuizPool,
  });

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  // Maps number keys (top row and numpad) 1-9 to the answer index to toggle.
  static final Map<LogicalKeyboardKey, int> _numberKeys = {
    LogicalKeyboardKey.digit1: 1,
    LogicalKeyboardKey.digit2: 2,
    LogicalKeyboardKey.digit3: 3,
    LogicalKeyboardKey.digit4: 4,
    LogicalKeyboardKey.digit5: 5,
    LogicalKeyboardKey.digit6: 6,
    LogicalKeyboardKey.digit7: 7,
    LogicalKeyboardKey.digit8: 8,
    LogicalKeyboardKey.digit9: 9,
    LogicalKeyboardKey.numpad1: 1,
    LogicalKeyboardKey.numpad2: 2,
    LogicalKeyboardKey.numpad3: 3,
    LogicalKeyboardKey.numpad4: 4,
    LogicalKeyboardKey.numpad5: 5,
    LogicalKeyboardKey.numpad6: 6,
    LogicalKeyboardKey.numpad7: 7,
    LogicalKeyboardKey.numpad8: 8,
    LogicalKeyboardKey.numpad9: 9,
  };

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
  // End-of-quiz total grade snapshot, used only to drive the confetti/grade
  // celebration. The result card itself derives the grade/range live from the
  // current written grade (see build), so it updates if the grade is entered
  // after the quiz ends.
  double? _totalGrade;

  // TODO
  bool _showResultCard = false;
  bool _showConfetti = false;
  bool _showGrade = false;

  // Debug only: whether the "fill correct answers" button was the last thing to
  // touch the answers. Tracks the button press explicitly (NOT whether the
  // answers happen to all be correct) so it can't double as a cheat-checker.
  // Cleared whenever the user changes/unselects an answer, and on each (re)start.
  bool _filledCorrectAnswers = false;

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

  /// Toggles the answer at [index] for the current question, matching the tap
  /// behaviour (tapping the selected answer again deselects it). Out-of-range
  /// indices (e.g. a number key with no matching answer) are ignored.
  void _toggleAnswer(int index) {
    final List<String> answers = _quiz.questions[_iQuestion].answers;
    if (index < 0 || index >= answers.length) {
      return;
    }
    setState(() {
      _quiz.selectedAnswers[_iQuestion] =
          _quiz.selectedAnswers[_iQuestion] == index ? null : index;
      _filledCorrectAnswers = false;
    });
  }

  /// Keyboard controls: left/right arrows move between questions; number keys
  /// 1-9 toggle the matching answer while the quiz is still running.
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) {
      return KeyEventResult.ignored;
    }

    // Arrows navigate (auto-repeat when held is fine).
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _previousQuestion();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _nextQuestion();
      return KeyEventResult.handled;
    }

    // Numbers select/deselect an answer — only on the initial press, and only
    // while answers are still selectable (not once the quiz is over).
    if (event is KeyDownEvent && !_isQuizOver) {
      final int? number = _numberKeys[event.logicalKey];
      if (number != null) {
        _toggleAnswer(number - 1);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  /// Debug helper for the AppBar button: selects the correct answer for every
  /// question, so the max-grade / end-quiz flow can be exercised in one tap.
  void _fillCorrectAnswers() {
    setState(() {
      for (int i = 0; i < _quiz.selectedAnswers.length; i++) {
        _quiz.selectedAnswers[i] = _quiz.questions[i].correctAnswer;
      }
      _filledCorrectAnswers = true;
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
      _filledCorrectAnswers = false;

      _confettiPlayed = false;
      _showGrade = false;
      _showResultCard = false;

      _totalGrade = null;

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

  /// Whether the user has agreed to leave. Leaving mid-quiz discards it without
  /// grading or saving to history, so at the [ConfirmationLevel.full] tier we
  /// confirm first; once the quiz is over there's nothing left to lose. Does not
  /// pop — the caller ([PopScope]'s `onPopInvokedWithResult`) owns navigation so
  /// every exit path (in-app back button, Esc, Android system back, swipe)
  /// shares this one flow.
  Future<bool> _confirmLeaveQuiz(Settings settings) async {
    if (_isQuizOver) {
      return true;
    }
    return maybeConfirm(
      context,
      userLevel: settings.confirmationLevel,
      minLevel: ConfirmationLevel.full,
      title: "Esci dal quiz",
      message:
          "Uscendo, il quiz verrà annullato e non verrà salvato nello storico. Continuare?",
      confirmLabel: "Esci",
    );
  }

  /// Terminating with unanswered questions is easy to do by accident, so at the
  /// [ConfirmationLevel.full] tier we confirm when any answer is still blank.
  Future<void> _handleTerminate(Settings settings) async {
    final int blank = _quiz.countBlankAnswers();
    if (blank > 0) {
      final bool confirmed = await maybeConfirm(
        context,
        userLevel: settings.confirmationLevel,
        minLevel: ConfirmationLevel.full,
        title: "Termina quiz",
        message: blank == 1
            ? "Hai 1 domanda senza risposta. Terminare comunque?"
            : "Hai $blank domande senza risposta. Terminare comunque?",
        confirmLabel: "Termina",
      );
      if (!confirmed) {
        return;
      }
    }

    _endQuiz(settings.writtenGrade);
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

  /// A bottom-bar nav arrow. A tap moves one question; pressing and holding
  /// repeats (accelerating), matching the keyboard arrow auto-repeat. When
  /// disabled (first/last question) [onUpdate] is null, so it renders as a
  /// greyed, non-repeating button.
  Widget _buildNavArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onUpdate,
  }) {
    return IconButtonAcceleration(
      style: _navArrowStyle(context),
      onUpdate: enabled ? onUpdate : null,
      icon: Icon(icon),
      iconSize: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context);

    return PopScope(
      // Every exit path (in-app back button, Esc, Android system back, swipe)
      // is a blocked pop that funnels through here so the leave-quiz confirm
      // (full tier) can't be skipped. Leaving mid-quiz simply discards it — no
      // grading, no save to history; only a finished quiz reaches history.
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        if (!await _confirmLeaveQuiz(settings) || !mounted) {
          return;
        }
        navigator.pop();
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: _onKeyEvent,
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
            appBar: ConstrainedAppBar(
              maxWidth: 500.0,
              title: const Text("Quiz"),
              leading: CustomBackButton(
                onPressed: () => Navigator.maybePop(context),
              ),
              // TODO: add toggle dark mode?
              actions: [
                if (kDebugMode)
                  IconButton(
                    tooltip: "Compila risposte corrette",
                    icon: const Icon(Icons.done_all),
                    onPressed: _isQuizOver ? null : _fillCorrectAnswers,
                    // Transparent background in both themes (the default icon-
                    // button theme paints a filled pill that only blends into the
                    // app bar in light mode). Green once used; reverts to the
                    // app-bar's white as soon as any answer is changed/unselected.
                    // Disabled colors are pinned too, otherwise the quiz-over
                    // (disabled) state falls back to the theme's disabled palette
                    // (a light-blue pill + navy icon in dark mode).
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      foregroundColor: _filledCorrectAnswers
                          ? Colors.green
                          : Colors.white,
                      disabledForegroundColor: Colors.white38,
                    ),
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
                                    style: TextTheme.of(context).headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
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
                                                    fontWeight: FontWeight.bold,
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
                                              _filledCorrectAnswers = false;
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
                                // Derived live from the current written grade so
                                // the card updates if it's set via the hint below
                                // after the quiz has ended.
                                totalGrade: settings.writtenGrade != null
                                    ? calculateTotalGrade(
                                        settings.writtenGrade!,
                                        _quizGrade,
                                      )
                                    : null,
                                totalGradeRange: settings.writtenGrade == null
                                    ? calculateTotalGradeRange(_quizGrade)
                                    : null,
                                onSetWrittenGrade: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewSettings(
                                        maxQuizPool: widget.maxQuizPool,
                                        lockQuizConfig: true,
                                      ),
                                    ),
                                  );
                                },
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
              // The bar keeps the nav arrows pinned left and the action button
              // pinned right. As the screen narrows, the gap between them
              // shrinks first (spaceBetween over a width that tracks the
              // screen). Only once the gap is gone — when the content can no
              // longer fit — does FittedBox scale everything down. MainAxisSize.min
              // lets the row report its own minimum width, so no breakpoint is
              // hardcoded.
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double targetWidth = (constraints.maxWidth - 16.0)
                      .clamp(0.0, 500.0 - 16.0)
                      .toDouble();
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: targetWidth),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // Minimum gap kept between the arrows and the action
                          // button: spaceBetween grows it on wider screens, but
                          // it never drops below this even when fully collapsed.
                          spacing: 16.0,
                          children: [
                            Row(
                              spacing: 20.0,
                              children: [
                                _buildNavArrow(
                                  icon: Icons.arrow_back_ios_rounded,
                                  enabled: _iQuestion > 0,
                                  onUpdate: _previousQuestion,
                                ),
                                _buildNavArrow(
                                  icon: Icons.arrow_forward_ios_rounded,
                                  enabled: _iQuestion < widget.questionNum - 1,
                                  onUpdate: _nextQuestion,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_isQuizOver) {
                                  _startQuiz();
                                } else {
                                  _handleTerminate(settings);
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
