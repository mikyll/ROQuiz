import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/grade.dart';
import 'package:roquiz/model/utils/time.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/question_card.dart';

class ViewHistoryQuiz extends StatefulWidget {
  const ViewHistoryQuiz({super.key, required this.quizCompleted});

  final QuizCompleted quizCompleted;

  @override
  State<StatefulWidget> createState() => _ViewHistoryQuizState();
}

class _ViewHistoryQuizState extends State<ViewHistoryQuiz> {
  final ScrollController _scrollController = ScrollController();

  int _iQuestion = 0;
  int _dragDirectionDX = 0;

  void _previousQuestion() {
    setState(() {
      if (_iQuestion > 0) {
        _iQuestion--;
        _scrollController.jumpTo(0);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_iQuestion < widget.quizCompleted.questions.length - 1) {
        _iQuestion++;
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuizCompleted quiz = widget.quizCompleted;
    final int totalQuestions = quiz.questions.length;

    return PopScope(
      canPop: true,
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
          _dragDirectionDX = 0;
        },
        child: Scaffold(
          appBar: ConstrainedAppBar(
            maxWidth: 500.0,
            title: Text("Dettaglio Quiz"),
            leading: CustomBackButton(),
          ),
          body: SelectionArea(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500.0),
                  child: totalQuestions == 0
                      ? Center(child: Text("Nessuna domanda disponibile"))
                      : Column(
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
                                    "D${_iQuestion + 1}/$totalQuestions",
                                    style: TextTheme.of(context).headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${quiz.correctAnswers}/$totalQuestions  ${getTimeString(quiz.timeSpent)}",
                                    style: TextTheme.of(context).headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: QuestionCard.quizOver(
                                  question: quiz.questions[_iQuestion],
                                  selectedAnswer:
                                      quiz.selectedAnswers[_iQuestion],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: totalQuestions == 0
              ? null
              : Container(
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
                                      onPressed: _iQuestion <= 0
                                          ? null
                                          : _previousQuestion,
                                      icon: Icon(Icons.arrow_back_ios_rounded),
                                      iconSize: 35,
                                    ),
                                    IconButton(
                                      onPressed:
                                          _iQuestion >= totalQuestions - 1
                                          ? null
                                          : _nextQuestion,
                                      icon: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                      ),
                                      iconSize: 35,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getGradeString(quiz.grade),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
