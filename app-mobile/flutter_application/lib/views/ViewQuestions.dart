import 'package:flutter/material.dart';
import 'package:roquiz/model/Answer.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/widget/question_widget.dart';

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
          title: Text(
            widget.qRepo.topics[widget.iTopic],
            maxLines: 2,
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (_, iQuestion) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: QuestionWidget(
                questionNumber: iQuestion + offset + 1,
                questionText: questions[iQuestion].question,
                alignmentQuestion: Alignment.centerLeft,
                answers: questions[iQuestion].answers,
                isOver: true,
                userAnswer: Answer.NONE,
                onTapAnswer: (_) => null,
                correctAnswer: questions[iQuestion].correctAnswer,
                backgroundQuizColor: Colors.cyan.withOpacity(0.1),
                defaultAnswerColor: Colors.indigo.withOpacity(0.2),
                selectedAnswerColor: Colors.indigo.withOpacity(0.5),
                correctAnswerColor:
                    const Color.fromARGB(255, 42, 255, 49).withOpacity(0.5),
                correctNotSelectedAnswerColor:
                    const Color.fromARGB(255, 27, 94, 32).withOpacity(0.8),
                wrongAnswerColor: Colors.red.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
