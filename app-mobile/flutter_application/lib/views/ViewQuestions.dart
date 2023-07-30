import 'dart:ui';

import 'package:roquiz/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/widget/question_widget.dart';

class ViewQuestions extends StatefulWidget {
  const ViewQuestions(
      {Key? key, required this.title, required this.qRepo, this.iTopic});

  final String title;
  final QuestionRepository qRepo;
  final int? iTopic;

  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();

  List<Question> questionsFullList = [];
  List<Question> questions = [];
  int qNum = 0;
  int offset = 0;

  bool _searchBarOpen = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      qNum = widget.qRepo.questions.length;

      if (widget.iTopic != null) {
        // get starting offset
        for (int i = 0;; i++) {
          qNum = widget.qRepo.getQuestionNumPerTopic()[i];
          if (i >= widget.iTopic!) break;
          offset += qNum;
        }
      }

      // get question list
      for (int i = offset; i < offset + qNum; i++) {
        Question q = widget.qRepo.questions[i];
        questionsFullList.add(q);
        questions.add(q);
      }
    });
  }

  double _getWidth() {
    return PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  void _clearSearch() {
    questions.clear();
    setState(() {
      for (int i = offset; i < questionsFullList.length; i++) {
        questions.add(questionsFullList[i]);
      }
    });
  }

  void _search(String value) {
    _scrollController.jumpTo(0.0);
    setState(() {
      questions.clear();
      for (int i = 0; i < questionsFullList.length; i++) {
        if (questionsFullList[i].question.contains(value)) {
          questions.add(questionsFullList[i]);
          continue;
        }
        for (int j = 0; j < questionsFullList[i].answers.length; j++) {
          if (questionsFullList[i].answers[j].contains(value)) {
            questions.add(questionsFullList[i]);
            break;
          }
        }
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
          title: AnimatedOpacity(
            opacity: _searchBarOpen ? 0.0 : 1.0,
            curve: Curves.easeOutSine,
            duration: const Duration(milliseconds: 250),
            child: Text(
              widget.title,
              maxLines: 1,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            SearchBarWidget(
              color: Colors.transparent,
              searchIconColor: Colors.white,
              boxShadow: false,
              width: 300,
              textController: _textController,
              onOpen: () {
                //print("open");
                setState(() => _searchBarOpen = true);
              },
              onSearch: (stringToSearch) {
                //print("search");
                _search(stringToSearch);
                if (questions.isEmpty) {
                  _clearSearch();
                  _textController.clear();
                }
              },
              onClear: () {
                //print("clear");
                _clearSearch();
                _textController.clear();
              },
              onClose: () {
                //print("close");
                setState(() => _searchBarOpen = false);
              },
            ),
          ],
        ),
        body: Scrollbar(
          interactive: true,
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: widget.iTopic == null &&
                            (index == 0 ||
                                questions[index].topic !=
                                    questions[index - 1].topic)
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        questions[index].topic,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    const Expanded(child: Divider())
                                  ],
                                ),
                              ),
                              QuestionWidget(
                                questionNumber: questions[index].id,
                                questionText: questions[index].question,
                                alignmentQuestion: Alignment.centerLeft,
                                answers: questions[index].answers,
                                isOver: true,
                                userAnswer: questions[index].correctAnswer,
                                onTapAnswer: (_) => null,
                                correctAnswer: questions[index].correctAnswer,
                                backgroundQuizColor:
                                    Colors.cyan.withOpacity(0.1),
                                defaultAnswerColor:
                                    Colors.indigo.withOpacity(0.2),
                                selectedAnswerColor:
                                    Colors.indigo.withOpacity(0.5),
                                correctAnswerColor:
                                    const Color.fromARGB(255, 42, 255, 49)
                                        .withOpacity(0.5),
                                correctNotSelectedAnswerColor:
                                    const Color.fromARGB(255, 42, 255, 49)
                                        .withOpacity(0.5),
                              ),
                            ],
                          )
                        : QuestionWidget(
                            questionNumber: questions[index].id,
                            questionText: questions[index].question,
                            alignmentQuestion: Alignment.centerLeft,
                            answers: questions[index].answers,
                            isOver: true,
                            userAnswer: questions[index].correctAnswer,
                            onTapAnswer: (_) => null,
                            correctAnswer: questions[index].correctAnswer,
                            backgroundQuizColor: Colors.cyan.withOpacity(0.1),
                            defaultAnswerColor: Colors.indigo.withOpacity(0.2),
                            selectedAnswerColor: Colors.indigo.withOpacity(0.5),
                            correctAnswerColor:
                                const Color.fromARGB(255, 42, 255, 49)
                                    .withOpacity(0.5),
                            correctNotSelectedAnswerColor:
                                const Color.fromARGB(255, 42, 255, 49)
                                    .withOpacity(0.5),
                          ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
