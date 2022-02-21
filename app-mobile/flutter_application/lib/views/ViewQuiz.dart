import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/views/ViewMenu.dart';

class ViewQuiz extends StatefulWidget {
  const ViewQuiz({Key? key, required this.qRepo}) : super(key: key);

  final QuestionRepository qRepo;

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

const int maxQuestion = 16;
const int minTimer = 18;

class _ViewQuizState extends State<ViewQuiz> {
  bool isOver = false;

  int qIndex = 0;
  int correctAnswers = 0; // TMP

  String currentQuestion = "";
  List<String> currentAnswers = [];

  List<Answer> userAnswers =
      List<Answer>.filled(maxQuestion, Answer.NONE, growable: true);

  late Timer _timer;
  int _timerCounter = minTimer * 60;

  void previousQuestion() {
    setState(() {
      if (qIndex > 0) qIndex--;
    });
  }

  void nextQuestion() {
    setState(() {
      if (qIndex < maxQuestion - 1) qIndex++;
    });
  }

  void loadQuestion() {
    setState(() {
      currentQuestion = widget.qRepo.questions[qIndex].question;
      currentAnswers = widget.qRepo.questions[qIndex].answers;
    });
  }

  void setUserAnswer(int answer) {
    setState(() {
      userAnswers[qIndex] = Answer.values[answer];
      if (Answer.values[answer] ==
          widget.qRepo.questions[qIndex].correctAnswer) {}
    });
  }

  void endQuiz() {
    setState(() {
      isOver = true;
      _timer.cancel();
    });
    for (int i = 0; i < maxQuestion; i++) {
      if (userAnswers[i] == widget.qRepo.questions[i].correctAnswer) {
        correctAnswers++;
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerCounter > 0) {
          //print("tick: $_timerCounter"); // test
          _timerCounter--;
        } else {
          _timer.cancel();
          endQuiz();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    widget.qRepo.loadFile("assets/Domande.txt").then((value) {
      setState(() {
        widget.qRepo.questions.shuffle();
        currentQuestion = widget.qRepo.questions[0].question;
        currentAnswers = widget.qRepo.questions[0].answers;

        _startTimer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // this enables us to catch the "hard back" from device
      onWillPop: () async {
        endQuiz(); // end quiz and stop timer
        return true; // "return true" pops the element from the stack (== Navigator.pop())
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
              endQuiz();
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
                      "Question: ${qIndex + 1}/$maxQuestion",
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
                          // QUESIO
                          child: Text(currentQuestion,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20)),
                        ),
                      ),
                      // ANSWERS
                      ...List.generate(
                        currentAnswers.length,
                        (index) => InkWell(
                          enableFeedback: true,
                          onTap: () {
                            if (!isOver) {
                              setUserAnswer(index);
                            }
                          },
                          child: Column(children: [
                            const SizedBox(height: 5),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: !isOver &&
                                          userAnswers[qIndex] ==
                                              Answer.values[index]
                                      ? Colors.cyan[900]
                                      : (!isOver
                                          ? Colors.cyan
                                          : (widget.qRepo.questions[qIndex]
                                                          .correctAnswer ==
                                                      Answer.values[index] &&
                                                  (userAnswers[qIndex] ==
                                                          Answer.NONE ||
                                                      userAnswers[qIndex] !=
                                                          widget
                                                              .qRepo
                                                              .questions[qIndex]
                                                              .correctAnswer)
                                              ? Colors.green[900]
                                              : (widget.qRepo.questions[qIndex]
                                                          .correctAnswer ==
                                                      Answer.values[index]
                                                  ? Colors.green
                                                  : (userAnswers[qIndex] ==
                                                          Answer.values[index]
                                                      ? Colors.red
                                                      : Colors.cyan)))),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  // current answers
                                  Text(
                                      Answer.values[index].toString().substring(
                                              Answer.values[index]
                                                      .toString()
                                                      .indexOf('.') +
                                                  1) +
                                          ") ",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                    child: Text(currentAnswers[index],
                                        style: const TextStyle(fontSize: 16)),
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
                isOver
                    ? Text(
                        "Risposte corrette: $correctAnswers/$maxQuestion, Risposte errate: ${maxQuestion - correctAnswers}.\nRange di voto finale, in base allo scritto: [${(11.33 + correctAnswers ~/ 3).toInt().toString()}, ${22 + correctAnswers * 2 ~/ 3}]")
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
                  previousQuestion();
                  loadQuestion();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                enableFeedback: true,
                onTap: () {
                  nextQuestion();
                  loadQuestion();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60, // fix: fit <->
                  height: 60,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(flex: 5),
              InkWell(
                enableFeedback: true,
                onTap: () {
                  if (!isOver) {
                    endQuiz();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("   Termina   ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
