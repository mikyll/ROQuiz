import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/question_card.dart';

class ViewQuestionsEdit extends StatefulWidget {
  final List<Question> questions;
  final bool showAnswers;

  const ViewQuestionsEdit({
    super.key,
    required this.questions,
    this.showAnswers = true,
  });

  @override
  State<StatefulWidget> createState() => ViewQuestionsEditState();
}

class ViewQuestionsEditState extends State<ViewQuestionsEdit> {
  final ScrollController _scrollController = ScrollController();

  late List<Question> _questions;
  late List<bool> _selectedQuestions;
  int _selectedCount = 0;

  // TODO: operations buffer

  void _addNewQuestion() {}

  void _editQuestion() {}

  void _removeQuestion() {}

  void _undoOperation() {}

  void _redoOperation() {}

  @override
  void initState() {
    super.initState();

    _questions = widget.questions;
    _selectedQuestions = [];
    for (Question _ in _questions) {
      _selectedQuestions.add(false);
    }
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
          title: Text(
            _selectedCount > 0
                ? "Selected: $_selectedCount/${_questions.length}"
                : "Modifica Domande",
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
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700.0),
              child: Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _questions.length,
                  itemBuilder: (_, index) {
                    Widget questionWidget = QuestionCard.edit(
                      question: _questions[index],
                      isSelected: _selectedQuestions[index],
                      onSelected: () {
                        setState(() {
                          _selectedQuestions[index] =
                              !_selectedQuestions[index];
                          _selectedCount =
                              _selectedCount +
                              (_selectedQuestions[index] ? 1 : -1);
                        });
                      },
                      tapToSelect: _selectedCount > 0,
                    );
                    // Check if we have to display the topic divider
                    if (index == 0 ||
                        _questions[index - 1].topic !=
                            _questions[index].topic) {
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
                message: "Aggiungi una nuova domanda",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  iconSize: 35,
                ),
              ),
              const SizedBox(width: 20),
              // Edit mode
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Modifica",
                child: IconButton(
                  onPressed: _selectedCount > 0 ? () {} : null,
                  icon: Icon(Icons.edit_note),
                  iconSize: 35,
                ),
              ),
              const SizedBox(width: 20),
              // Check if there are new questions
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Rimuovi",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  iconSize: 35,
                ),
              ),
              const SizedBox(width: 20),
              // Import questions from a file
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Annulla l'ultima azione",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.undo),
                  iconSize: 35,
                ),
              ),
              const SizedBox(width: 20),
              // Export questions file
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Ripeti l'ultima azione",
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.redo),
                  iconSize: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
