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

class _ViewQuizState extends State<ViewQuiz> {
  bool isOver = false;

  int qIndex = 0;
  int correctAnswers = 0; // TMP

  String currentQuestion = "";
  List<String> currentAnswers = [];

  List<Answer> userAnswers =
      List<Answer>.filled(maxQuestion, Answer.NONE, growable: true);

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
      print("Question $qIndex: ${userAnswers[qIndex]}");
    });
  }

  void setUserAnswer(int answer) {
    setState(() {
      userAnswers[qIndex] = Answer.values[answer];
      if (Answer.values[answer] ==
          widget.qRepo.questions[qIndex].correctAnswer) {
        correctAnswers++;
        print("risposta corretta!");
      }

      print("Question $qIndex: ${userAnswers[qIndex]}");
    });
  }

  void endQuiz() {
    setState(() {
      isOver = true;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.qRepo.loadFile().then((value) {
      setState(() {
        //widget.qRepo.questions.shuffle();
        currentQuestion = widget.qRepo.questions[0].question;
        currentAnswers = widget.qRepo.questions[0].answers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: const Text("Quiz"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ViewMenu()));
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                "Question: ${qIndex + 1}/$maxQuestion",
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // QUESTION
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
                      height: 150,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // current question
                        child: Text(currentQuestion,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      currentAnswers.length,
                      (index) => InkWell(
                        onTap: () {
                          if (!isOver) {
                            setUserAnswer(index);
                          }
                        },
                        child: Column(children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: !isOver &&
                                        userAnswers[qIndex] ==
                                            Answer.values[index]
                                    ? Colors.cyan[700]
                                    : (!isOver
                                        ? Colors.cyan
                                        : (widget.qRepo.questions[qIndex]
                                                    .correctAnswer ==
                                                Answer.values[index]
                                            ? Colors.green
                                            : (userAnswers[qIndex] ==
                                                    Answer.values[index]
                                                ? Colors.red
                                                : Colors.cyan))),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                                        ". ",
                                    style: const TextStyle(fontSize: 18)),
                                Flexible(
                                  child: Text(currentAnswers[index],
                                      style: const TextStyle(fontSize: 18)),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // CONTROLS
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          previousQuestion();
                          loadQuestion();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 60, // fix: fit <->
                          height: 60,
                          decoration: const BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (!isOver) {
                              endQuiz();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 250, // fix: fit <->
                            height: 60,
                            decoration: const BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: const Text("Termina",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final questionsTest = const [
    "Sia P un politopo, H un generico iperpiano, HS uno dei due semispazi generati da H. Insieme dei punti f = intersezione tra P e HS è detta:",
    "In un tableau del simplesso primale, gli elementi della colonna 0 righe da 1 a m:",
    "Ad una variabile primale non negativa corrisponde",
    "Dato un insieme F, un intorno è",
  ];
  final answersTest = const [
    [
      "A. Politopo convesso ammissibile",
      "B. Regione ammissibile",
      "C. Faccia del politopo se f non vuoto e contenuto in H",
      "D. Insieme di punti ottimi contenuti in H",
      "E. Nessuna di queste"
    ],
    [
      "A. contengono i valori attuali delle sole variabili base",
      "B. sono tutti nulli",
      "C. contengono i valori attuali di tutte le variabili",
      "D. contengono i costi relativi",
      "E. contengono i valori ottimi delle sole variabili base"
    ],
    [
      "A. nessuna di queste",
      "B. un vincolo duale della forma pi'a^ <= c",
      "C. un vincolo duale nella forma pi'a^ = c",
      "D. una variabile duale non negativa",
      "E. una variabile duale libera (non ristretta in segno)",
    ],
    [
      "A. L'insieme di tutti i sottoinsiemi di F",
      "B. L'insieme dei punti di F a distanza minore di epsilon da un punto x di F",
      "C. Una funzione N: F -> 2^F",
      "D. Una combinazione convessa di due punti x e y di F",
      "E. Nessuna di queste",
    ]
  ];
  final correctAnswersTest = ["C", "A", "D", "C"];
}
