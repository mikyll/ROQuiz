import 'dart:ui';

import 'package:roquiz/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/widget/question_widget.dart';

class ViewQuestions extends StatefulWidget {
  const ViewQuestions({Key? key, required this.title, required this.questions});

  final String title;
  final List<Question> questions;

  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  bool multipleTopics = false;

  List<Question> displayedQuestions = [];
  int qNum = 0;
  int offset = 0;

  bool _searchBarOpen = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      qNum = widget.questions.length;

      // get question list
      for (int i = offset; i < offset + qNum; i++) {
        Question q = widget.questions[i];

        if (i >= 1 && !multipleTopics) {
          multipleTopics = widget.questions[i - 1].topic != q.topic;
        }
        displayedQuestions.add(q);
      }
    });
  }

  void _clearSearch() {
    displayedQuestions.clear();
    setState(() {
      for (int i = offset; i < widget.questions.length; i++) {
        displayedQuestions.add(widget.questions[i]);
      }
    });
  }

  void _search(String value) {
    value = value.toLowerCase();

    _scrollController.jumpTo(0.0);
    setState(() {
      displayedQuestions.clear();

      // Loop over the question list
      for (int i = 0; i < widget.questions.length; i++) {
        // Check if contained in question
        if (widget.questions[i].question.toLowerCase().contains(value)) {
          displayedQuestions.add(widget.questions[i]);
          continue;
        }

        // Check if contained in answers
        for (int j = 0; j < widget.questions[i].answers.length; j++) {
          if (widget.questions[i].answers[j].toLowerCase().contains(value)) {
            displayedQuestions.add(widget.questions[i]);
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
              widget.questions.length == displayedQuestions.length
                  ? widget.title
                  : "Trovate: ${displayedQuestions.length}",
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
                setState(() => _searchBarOpen = true);
              },
              onSearch: (stringToSearch) {
                _search(stringToSearch);
                /*if (displayedQuestions.isEmpty) {
                  _clearSearch();
                  _textController.clear();
                }*/
              },
              onClear: () {
                _clearSearch();
                _textController.clear();
              },
              onClose: () {
                setState(() => _searchBarOpen = false);
              },
            ),
          ],
        ),
        body: Scrollbar(
          interactive: true,
          controller: _scrollController,
          child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              controller: _scrollController,
              itemCount: displayedQuestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: multipleTopics &&
                          (index == 0 ||
                              displayedQuestions[index].topic !=
                                  displayedQuestions[index - 1].topic)
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      displayedQuestions[index].topic,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const Expanded(child: Divider())
                                ],
                              ),
                            ),
                            QuestionWidget(
                              questionNumber: displayedQuestions[index].id,
                              questionText: displayedQuestions[index].question,
                              alignmentQuestion: Alignment.centerLeft,
                              answers: displayedQuestions[index].answers,
                              isOver: true,
                              userAnswer:
                                  displayedQuestions[index].correctAnswer,
                              onTapAnswer: (_) => null,
                              correctAnswer:
                                  displayedQuestions[index].correctAnswer,
                              backgroundQuizColor: Colors.cyan.withOpacity(0.1),
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
                          questionNumber: displayedQuestions[index].id,
                          questionText: displayedQuestions[index].question,
                          alignmentQuestion: Alignment.centerLeft,
                          answers: displayedQuestions[index].answers,
                          isOver: true,
                          userAnswer: displayedQuestions[index].correctAnswer,
                          onTapAnswer: (_) => null,
                          correctAnswer:
                              displayedQuestions[index].correctAnswer,
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
    );
  }
}
