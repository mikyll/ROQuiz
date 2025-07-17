import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/view/view_questions_edit.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewQuestions extends StatefulWidget {
  final List<Question> questions;

  const ViewQuestions({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  final ScrollController _scrollController = ScrollController();

  late List<Question> _questions;
  bool _showAnswers = true; // Todo: save to shared prefs?

  Future<void> _toggleAnswers() async {
    setState(() {
      _showAnswers = !_showAnswers;
    });
  }

  void _enterEditMode() {}

  void _checkUpdates() {}

  void _importFromFile() {}

  void _exportToFile() {}

  @override
  void initState() {
    _questions = widget.questions;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onPopInvoked: (_) {
      //   // todo
      // },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lista Domande (${_questions.length})"),
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
        ),
        body: SafeArea(
          child: Scrollbar(
            interactive: true,
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _questions.length,
              itemBuilder: (_, index) {
                Widget questionWidget = QuestionCard.base(
                  question: _questions[index],
                  hideCorrectAnswer: !_showAnswers,
                );
                // Check if we have to display the topic divider
                if (index == 0 ||
                    _questions[index - 1].topic != _questions[index].topic) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: index == 0 ? 10.0 : 0,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                _questions[index].topic!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(thickness: 2)),
                          ],
                        ),
                      ),
                      questionWidget,
                    ],
                  );
                }
                // Otherwise simply return the card
                else {
                  return questionWidget;
                }
              },
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show/Hide correct answers
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Mostra/nascondi le risposte corrette",
                child: IconButton(
                  onPressed: () {
                    _toggleAnswers();
                  },
                  icon: Icon(
                    _showAnswers ? Icons.visibility : Icons.visibility_off,
                  ),
                  iconSize: 45,
                ),
              ),
              const SizedBox(width: 20),
              // Edit mode
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Modifica",
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ViewQuestionsEdit(
                            questions: _questions,
                            showAnswers: _showAnswers,
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                  iconSize: 45,
                ),
              ),
              const SizedBox(width: 20),
              // Check if there are new questions
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Controlla se ci sono nuove domande",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.sync_rounded),
                  iconSize: 45,
                ),
              ),
              const SizedBox(width: 20),
              // Import questions from a file
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Importa le domande da un file",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.file_open_outlined),
                  iconSize: 45,
                ),
              ),
              const SizedBox(width: 20),
              // Export questions file
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Esporta il file delle domande",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.file_download_outlined),
                  iconSize: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
