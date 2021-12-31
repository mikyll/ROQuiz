import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/views/ViewMenu.dart';

class ViewQuiz extends StatefulWidget {
  const ViewQuiz({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  final int maxQuestion = 4;
  int qIndex = 0;
  String currentQuestion =
      "Sia P un politopo, H un generico iperpiano, HS uno dei due semispazi generati da H. Insieme dei punti f = intersezione tra P e HS è detta:";
  List<String> currentAnswers = [
    "A. Politopo convesso ammissibile",
    "B. Regione ammissibile",
    "C. Faccia del politopo se f non vuoto e contenuto in H",
    "D. Insieme di punti ottimi contenuti in H",
    "E. Nessuna di queste"
  ];

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
      currentQuestion = questions[qIndex];
      currentAnswers = answers[qIndex];
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
                "Question: ${qIndex + 1}",
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // QUESTION
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      height: 320,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${currentQuestion}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      answers.length,
                      (index) => InkWell(
                        onTap: () {},
                        child: Column(children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            height: 70,
                            decoration: const BoxDecoration(
                                color: Colors.cyan,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${currentAnswers[index]}",
                                  style: TextStyle(fontSize: 18)),
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
              Row(
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
                  const SizedBox(width: 100),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 250, // fix: fit <->
                      height: 60,
                      decoration: const BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Text("Termina",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final questions = const [
    "Sia P un politopo, H un generico iperpiano, HS uno dei due semispazi generati da H. Insieme dei punti f = intersezione tra P e HS è detta:",
    "In un tableau del simplesso primale, gli elementi della colonna 0 righe da 1 a m:",
    "Ad una variabile primale non negativa corrisponde",
    "Dato un insieme F, un intorno è",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  final answers = const [
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
  final correctAnswers = ["C", "A", "D", "C"];
}
