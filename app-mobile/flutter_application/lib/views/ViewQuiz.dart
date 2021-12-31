import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Quiz.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_svg/svg.dart';

class ViewQuizWidget extends StatefulWidget {
  const ViewQuizWidget({Key? key}) : super(key: key);

  @override
  _ViewQuizWidgetState createState() {
    return _ViewQuizWidgetState();
  }
}

class _ViewQuizWidgetState extends State<ViewQuizWidget> {
  // test
  final _questions = const [
    {
      "question_text":
          "Sia P un politopo, H un generico iperpiano, HS uno dei due semispazi generati da H. Insieme dei punti f = intersezione tra P e HS è detta:",
      "answers": [
        "A. Politopo convesso ammissibile",
        "B. Regione ammissibile",
        "C. Faccia del politopo se f non vuoto e contenuto in H",
        "D. Insieme di punti ottimi contenuti in H",
        "E. Nessuna di queste",
      ],
      "correct_answer": "C",
    },
    {
      "question_text":
          "In un tableau del simplesso primale, gli elementi della colonna 0 righe da 1 a m:",
      "answers": [
        "A. contengono i valori attuali delle sole variabili base",
        "B. sono tutti nulli",
        "C. contengono i valori attuali di tutte le variabili",
        "D. contengono i costi relativi",
        "E. contengono i valori ottimi delle sole variabili base",
      ],
      "correct_answer": "A",
    },
    {
      "question_text": "Ad una variabile primale non negativa corrisponde",
      "answers": [
        "A. nessuna di queste",
        "B. un vincolo duale della forma pi'a^ <= c",
        "C. un vincolo duale nella forma pi'a^ = c",
        "D. una variabile duale non negativa",
        "E. una variabile duale libera (non ristretta in segno)",
      ],
      "correct_answer": "D",
    },
  ];
  int _qIndex = 0;

  void _toggleAnswer() {}

  void _previousQuestion() {}

  void _nextQuestion() {}

  void _endQuiz() {
    // alert dialog if there are unselected questions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Quiz"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF3F4768), width: 3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) => Container(
                            // from 0 to 1 it takes 60s
                            width: constraints.maxHeight * 0.5,
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
