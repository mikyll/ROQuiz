import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:roquiz/model/Themes.dart';
// import 'package:roquiz/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/constants.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/themes.dart';
import 'package:roquiz/widget/quiz/question_widget.dart';
import 'package:roquiz/widget/search_bar.dart';
// import 'package:roquiz/model/Question.dart';
// import 'package:roquiz/widget/question_widget.dart';

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

  List<Question> _questions = [];
  int numQuestion = 0;
  int offset = 0;

  bool _multipleTopics = false;
  bool _searchBarOpen = false;

  void _clearSearch() {
    setState(() {
      _questions.clear();
      for (int i = offset; i < widget.questions.length; i++) {
        _questions.add(widget.questions[i]);
      }
      _textController.clear();

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    });
  }

  void _search(String value) {
    value = value.toLowerCase();

    setState(() {
      _questions = widget.questions.where((question) {
        final bodyMatches = question.getBody().toLowerCase().contains(value);
        final answerMatches = question
            .getAnswers()
            .any((answer) => answer.toLowerCase().contains(value));
        return bodyMatches || answerMatches;
      }).toList();

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _questions = widget.questions;
    numQuestion = widget.questions.length;

    Question? prev;
    for (Question q in _questions) {
      if (prev != null && q.getTopic() != prev.getTopic()) {
        _multipleTopics = true;
        break;
      }
      prev = q;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedOpacity(
            opacity: _searchBarOpen ? 0.0 : 1.0,
            curve: Curves.easeOutSine,
            duration: const Duration(milliseconds: 250),
            child: Text(
              _textController.value.text.isEmpty
                  ? widget.title
                  : "Trovate: ${_questions.length}",
              maxLines: 1,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            SearchBarWidget(
              color: Colors.transparent,
              boxShadow: false,
              width: 300,
              textController: _textController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              onOpen: () {
                setState(() => _searchBarOpen = true);
              },
              onSearch: (stringToSearch) {
                _search(stringToSearch);
              },
              onClear: () {
                _clearSearch();
              },
              onClose: () {
                setState(() => _searchBarOpen = false);
              },
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: _questions.isEmpty
                ? Text(
                    _textController.text.isEmpty
                        ? "Nessuna domanda"
                        : "Nessuna domanda corrisponde alla ricerca \"${_textController.text}\"",
                  )
                : Scrollbar(
                    interactive: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      controller: _scrollController,
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: _multipleTopics &&
                                  (index == 0 ||
                                      _questions[index].getTopic() !=
                                          _questions[index - 1].getTopic())
                              ? Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              _questions[index].getTopic(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          const Expanded(child: Divider())
                                        ],
                                      ),
                                    ),
                                    QuestionWidget(
                                      questionNumber: _questions[index].getId(),
                                      questionText: _questions[index].getBody(),
                                      alignmentQuestion: Alignment.centerLeft,
                                      answers: _questions[index].getAnswers(),
                                      highlightAnswer: true,
                                      correctAnswer:
                                          _questions[index].getCorrectAnswer(),
                                      onTapAnswer: null,
                                      // TODO
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
                                  questionNumber: _questions[index].getId(),
                                  questionText: _questions[index].getBody(),
                                  alignmentQuestion: Alignment.centerLeft,
                                  answers: _questions[index].getAnswers(),
                                  highlightAnswer: true,
                                  correctAnswer:
                                      _questions[index].getCorrectAnswer(),
                                  onTapAnswer: null,
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
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
