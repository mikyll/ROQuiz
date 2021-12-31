import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/Quiz.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:flutter_svg/svg.dart';

class ViewQuizWidget extends StatefulWidget {
  const ViewQuizWidget({Key? key}) : super(key: key);

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

  @override
  _ViewQuizWidgetState createState() {
    return _ViewQuizWidgetState();
  }
}

class _ViewQuizWidgetState extends State<ViewQuizWidget> {
  // test
  /*final List<Question> questions = const [

  ]

  Quiz quiz = Quiz(questions, 5);*/
  int _qIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  void _toggleAnswer() {}

  void _previousQuestion() {}

  void _nextQuestion() {}

  void _endQuiz() {
    // alert dialog if there are unselected questions
  }
}
