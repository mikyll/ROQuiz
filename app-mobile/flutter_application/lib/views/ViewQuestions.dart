import 'package:flutter/material.dart';
import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';

class ViewQuestions extends StatefulWidget {
  const ViewQuestions({Key? key, required this.qRepo, required this.iTopic});

  final QuestionRepository qRepo;
  final int iTopic;

  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  List<Question> questions = [];
  int qNum = 0;
  int offset = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      // get starting offset
      for (int i = 0;; i++) {
        qNum = widget.qRepo.getQuestionNumPerTopic()[i];
        if (i >= widget.iTopic) break;
        offset += qNum;
      }

      // get question list
      for (int i = offset; i < offset + qNum; i++) {
        Question q = widget.qRepo.questions[i];
        questions.add(q);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.qRepo.topics[widget.iTopic]),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (_, iQuestion) => Container(
                      child: Column(
                    children: [
                      Text(
                        "Q${iQuestion + offset + 1}) ${questions[iQuestion].question}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(
                          questions[iQuestion].answers.length,
                          (iAnswer) => Row(
                                children: [
                                  Text(
                                    Answer.values[iAnswer].name + ") ",
                                    style: TextStyle(
                                        color: Answer.values[iAnswer] ==
                                                questions[iQuestion]
                                                    .correctAnswer
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                  Flexible(
                                    child: Text(
                                      questions[iQuestion].answers[iAnswer],
                                      style: TextStyle(
                                          color: Answer.values[iAnswer] ==
                                                  questions[iQuestion]
                                                      .correctAnswer
                                              ? Colors.green
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ))),
        ));
  }
}
