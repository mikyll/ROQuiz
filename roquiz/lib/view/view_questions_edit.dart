import 'package:flutter/material.dart';
import 'package:roquiz/model/edit/command.dart';
import 'package:roquiz/model/edit/command_executor.dart';
import 'package:roquiz/model/edit/commands/add.dart';
import 'package:roquiz/model/edit_question/commands/add_question.dart';
import 'package:roquiz/model/edit_question/commands/custom_command.dart';
import 'package:roquiz/model/edit_question/question_command_executor.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/question_dialog.dart';
import 'package:roquiz/widget/separator.dart';

class ViewQuestionsEdit extends StatefulWidget {
  final List<Question> questions;
  final bool hideAnswers;

  const ViewQuestionsEdit({
    super.key,
    required this.questions,
    this.hideAnswers = true,
  });

  @override
  State<StatefulWidget> createState() => ViewQuestionsEditState();
}

class ViewQuestionsEditState extends State<ViewQuestionsEdit> {
  final ScrollController _scrollController = ScrollController();

  List<Question> _questions = [];
  List<bool> _selectedQuestions = [];
  int _selectedCount = 0;
  bool? _selectedAll = false;

  final QuestionCommandExecutor _commandExecutor = QuestionCommandExecutor();

  void _selectQuestion(int i) {
    setState(() {
      _selectedQuestions[i] = !_selectedQuestions[i];
      _selectedCount += (_selectedQuestions[i] ? 1 : -1);
      _selectedAll = null;

      if (_selectedCount == 0) {
        _selectedAll = false;
      }
      if (_selectedCount == _questions.length) {
        _selectedAll = true;
      }
    });
  }

  void _addNewQuestion() {
    // TODO: problema: l'ID come lo gestiamo? Si potrebbe togliere del tutto... Tanto nel vecchio file non c'era
    // Oppure quando si salvano le modifiche, l'ID viene ricalcolato
    final Question newQuestion = Question(
      id: _questions.length + 1,
      body: "Quanto fa 2+2",
      topic: "Somma",
      answers: ["2", "3", "4", "5"],
      correctAnswer: 2,
    );

    // TODO: get topics
    List<String> topics = [];
    for (Question q in _questions) {
      if (!topics.contains(q.topic)) {
        topics.add(q.topic!);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDialog(
          topicsList: topics,
          onSubmit: (question) {
            // _commandExecutor.executeCommand(
            //   CustomQuestionCommand(
            //     () {
            //       int index = _questions.length;
            //       // Find index where to insert the new question
            //       for (int i = 0; i < _questions.length; i++) {
            //         if (_questions[i].topic! == newQuestion.topic!) {
            //           index = i;
            //           break;
            //         }
            //       }
            //       setState(() {
            //         _questions.insert(index, newQuestion);
            //         _selectedQuestions.insert(index, false);
            //         _selectedAll = _selectedAll! ? null : false;
            //       });
            //     },
            //     () {
            //       setState(() {
            //         final int index = _questions.indexOf(newQuestion);
            //         _questions.removeAt(index);
            //         _selectedQuestions.removeAt(index);
            //         _selectedAll = _selectedAll! ? null : false;
            //       });
            //     },
            //   ),
            // );
          },
        );
      },
    );
  }

  void _editQuestion() {
    // TODO: get topics
    List<String> topics = [];
    for (Question q in _questions) {
      if (!topics.contains(q.topic)) {
        topics.add(q.topic!);
      }
    }

    int iSelected = 0;
    for (int i = 0; i < _selectedQuestions.length; i++) {
      if (_selectedQuestions[i]) {
        iSelected = i;
        break;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDialog(
          topicsList: topics,
          onSubmit: (question) {
            print("Hello");
          },
          question: _questions[iSelected],
        );
      },
    );

    // if Ok (edit complete)
    // add new command
  }

  void _showQuestionModal(Question? question) {
    // TODO
    // NB: if null, is for adding new one
  }

  void _removeQuestion() {
    final List<Question> previousQuestions = List.from(_questions);
    final List<bool> previousSelectedQuestions = List.from(_selectedQuestions);
    final int previousCount = _selectedCount;

    setState(() {
      _selectedQuestions = List.filled(_questions.length, false);
      _selectedCount = 0;
    });

    _commandExecutor.executeCommand(
      CustomQuestionCommand(
        () {
          setState(() {
            for (int i = previousSelectedQuestions.length - 1; i >= 0; i--) {
              if (previousSelectedQuestions[i]) {
                _questions.removeAt(i);
                _selectedQuestions.removeAt(i);
                _selectedCount--;
              }
            }

            _selectedAll = _selectedAll! ? null : false;
          });
        },
        () {
          setState(() {
            _questions = List.from(previousQuestions);
            _selectedQuestions = List.filled(_questions.length, false);
            _selectedCount = 0;
            _selectedAll = _selectedAll! ? null : false;
          });
        },
      ),
    );

    // setState(() {
    //   if (_selectedAll != null && _selectedAll!) {
    //     // Remove all
    //     _questions = [];
    //     _selectedQuestions = [];
    //     _selectedCount = 0;
    //   } else {
    //     // Remove selected
    //     for (int i = 0; i < _selectedQuestions.length; i++) {
    //       if (_selectedQuestions[i]) {
    //         // Remove
    //         _questions.removeAt(i);
    //         _selectedQuestions.removeAt(i);
    //         _selectedCount--;
    //       }
    //     }
    //   }
    // });
  }

  void _undoOperation() {
    // TODO
  }

  void _redoOperation() {
    // TODO
  }

  @override
  void initState() {
    super.initState();

    _questions = List.from(widget.questions);
    _selectedQuestions = List.filled(_questions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: ConstrainedAppBar(
          maxWidth: 500.0,
          title: Text(
            "Selezionate: $_selectedCount/${_selectedQuestions.length}",
          ),
          leading: CustomBackButton(),
          actions: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                side: WidgetStateBorderSide.resolveWith((states) {
                  return BorderSide(
                    color: states.contains(WidgetState.selected)
                        ? Colors.blue
                        : Colors.white,
                  );
                }),
                fillColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? Colors.blue
                      : Colors.transparent;
                }),
                checkColor: Colors.white,
                tristate: true,
                value: _selectedAll,
                onChanged: (value) {
                  setState(() {
                    if (_selectedAll == null || _selectedAll == false) {
                      _selectedAll = true;
                      for (int i = 0; i < _selectedQuestions.length; i++) {
                        _selectedQuestions[i] = true;
                      }
                      _selectedCount = _selectedQuestions.length;
                      return;
                    }

                    if (_selectedAll == true) {
                      _selectedAll = false;
                      for (int i = 0; i < _selectedQuestions.length; i++) {
                        _selectedQuestions[i] = false;
                      }
                      _selectedCount = 0;
                      return;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500.0),
              child: Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    Widget questionWidget = QuestionCard.edit(
                      question: _questions[index],
                      iQuestion: index + 1,
                      isSelected: _selectedQuestions[index],
                      // TODO
                      //hideCorrectAnswer: !widget.showAnswers,
                      onSelected: () {
                        _selectQuestion(index);
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
                              top: index == 0 ? 10.0 : 0,
                            ),
                            child: Separator(
                              text: _questions[index].topic!,
                              indent: 10.0,
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

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor.withAlpha(70),
            // border: Border(
            //   top: BorderSide(color: Theme.of(context).disabledColor),
            // ),
          ),
          child: Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15.0,
                  children: [
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Aggiungi una nuova domanda",
                      child: IconButton(
                        onPressed: _selectedCount == 0
                            ? () {
                                _addNewQuestion();
                              }
                            : null,
                        icon: Icon(Icons.add),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Modifica",
                      child: IconButton(
                        onPressed: _selectedCount == 1
                            ? () {
                                _editQuestion();
                              }
                            : null,
                        icon: Icon(Icons.edit_note),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Rimuovi",
                      child: IconButton(
                        onPressed: _selectedCount > 0
                            ? () {
                                _removeQuestion();
                              }
                            : null,
                        icon: Icon(Icons.delete),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Annulla l'ultima azione",
                      child: IconButton(
                        onPressed: _commandExecutor.canUndo()
                            ? () {
                                setState(() {
                                  _commandExecutor.undoCommand();
                                });
                              }
                            : null,
                        icon: Icon(Icons.undo),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Ripeti l'ultima azione",
                      child: IconButton(
                        onPressed: _commandExecutor.canRedo()
                            ? () {
                                setState(() {
                                  _commandExecutor.redoCommand();
                                });
                              }
                            : null,
                        icon: Icon(Icons.redo),
                        iconSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
