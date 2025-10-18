import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/edit_question/commands/custom_command.dart';
import 'package:roquiz/model/edit_question/command_executor.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/question_dialog.dart';
import 'package:roquiz/widget/separator.dart';

class ViewQuestionsEdit extends StatefulWidget {
  final List<Question> questions;
  final List<String> topics;
  final bool hideAnswers;

  const ViewQuestionsEdit({
    super.key,
    required this.questions,
    required this.topics,
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

  late CommandExecutor _commandExecutor;

  void _calculateSelectedAll() {
    setState(() {
      _selectedAll = null;
      if (_selectedCount == _questions.length) {
        _selectedAll = true;
      }
      if (_selectedCount == 0) {
        _selectedAll = false;
      }
    });
  }

  void _resetSelectedQuestions() {
    setState(() {
      _selectedQuestions = List.filled(
        _questions.length,
        false,
        growable: true,
      );
      _selectedCount = 0;
      _calculateSelectedAll();
    });
  }

  void _toggleQuestionSelection(int i) {
    setState(() {
      _selectedQuestions[i] = !_selectedQuestions[i];
      _selectedCount += (_selectedQuestions[i] ? 1 : -1);
      _calculateSelectedAll();
    });
  }

  void _addQuestion(int id, Question question, {bool select = false}) {
    setState(() {
      _questions.insert(id, question);
      _selectedQuestions.insert(id, select);
      _selectedCount += select ? 1 : 0;
      _calculateSelectedAll();

      // Update IDs
      for (int i = id + 1; i < _questions.length; i++) {
        _questions[i].id = i;
      }
    });
  }

  void _addQuestions(List<Question> questions, {bool select = false}) {
    setState(() {
      for (Question q in questions) {
        _addQuestion(q.id, q, select: select);
      }
    });
  }

  /// Removes the question with ID.
  ///   Updates all the other questions
  ///
  /// NB: select count must be decreased only if they were selected! (for example not when redoing the operation)
  void _removeQuestion(int id, {bool deselect = false}) {
    setState(() {
      _questions.removeAt(id);
      _selectedQuestions.removeAt(id);
      _selectedCount += deselect ? -1 : 0;
      _calculateSelectedAll();

      // Update IDs
      for (int i = id; i < _questions.length; i++) {
        _questions[i].id = i;
      }
    });
  }

  void _removeQuestions(List<Question> questions, {bool deselect = false}) {
    for (int i = questions.length - 1; i >= 0; i--) {
      _removeQuestion(questions[i].id, deselect: deselect);
    }
  }

  // void _removeSelectedQuestions(List<bool> selectedQuestions) {
  //   final List<Question> newQuestions = [];

  //   for (int iSelect = 0; iSelect < selectedQuestions.length; iSelect++) {
  //     if (!selectedQuestions[iSelect]) {
  //       newQuestions.add(_questions[iSelect]);
  //       int id = newQuestions.length - 1;
  //       newQuestions[id].id = id;
  //     }
  //   }

  //   setState(() {
  //     _questions = newQuestions;
  //   });

  //   _resetSelectedQuestions();
  // }

  // TODO: functions to shoot and restore a snapshot of state (dynamic obj)
  // Map<String, dynamic> _createStateSnapshot() {
  //   return {
  //     'questions': _questions
  //         .map(
  //           (q) => Question.copy(q),
  //         ) // Make sure Question.copy() creates a proper deep copy
  //         .toList(), // Deep copy
  //     'selectedQuestions': List<bool>.from(_selectedQuestions),
  //     'selectedCount': _selectedCount,
  //     'selectedAll': _selectedAll,
  //   };
  // }

  // void _restoreState(Map<String, dynamic> state) {
  //   setState(() {
  //     _questions = state['questions'] as List<Question>;
  //     _selectedQuestions = state['selectedQuestions'] as List<bool>;
  //     _selectedCount = state['selectedCount'] as int;
  //     _selectedAll = state['selectedAll'] as bool?;
  //   });
  // }

  /// Adds a new question, inserting it at the end of the topic
  void _commandAddNewQuestion() {
    // TODO:
    //   - open modal
    //   - insert new question data
    //   - validate fields:
    //     - question is not duplicated (no equal-ignore-case to another question body)
    //     - no

    // TODO: problema: l'ID come lo gestiamo? Si potrebbe togliere del tutto... Tanto nel vecchio file non c'era
    // Oppure quando si salvano le modifiche, l'ID viene ricalcolato
    // Random r = Random(0);
    // Question test = Question(
    //   id: getFirstAvailableId(
    //     _questions,
    //     widget.topics[r.nextInt(widget.topics.length)],
    //   ),
    //   body: "Test question ${r.nextInt(200000)}",
    //   answers: ["a", "b", "c"],
    //   correctAnswer: r.nextInt(3),
    // );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDialog(
          topics: widget.topics,
          questions: _questions,
          onSubmit: (question) {
            _commandExecutor.executeCommand(
              CustomCommand(
                name:
                    "add(topic: '${question.topic}', id: ${question.id}, newSize: ${_questions.length + 1})",
                onExecute: () {
                  _addQuestion(question.id, question);
                },
                onUndo: () {
                  _resetSelectedQuestions();
                  _removeQuestion(question.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  // // TODO: questo funzionava, ma si spacca se selezioni tutte le domande
  // // TODO: fix (Non è colpa della remove (provare a fare 2 remove, poi 2 undo e poi 2 redo, la seconda redo si bugga)
  // void _commandRemoveQuestions() {
  //   List<Question> questionsToRemove = [];

  //   _commandExecutor.executeCommand(
  //     CustomQuestionCommand(
  //       name: "remove: ...",
  //       onExecute: () {
  //         for (int i = 0; i < _selectedQuestions.length; i++) {
  //           if (_selectedQuestions[i]) {
  //             questionsToRemove.add(_questions[i]);
  //           }
  //         }
  //         setState(() {
  //           for (Question q in questionsToRemove) {
  //             _removeQuestion(q.id!);
  //           }
  //           _resetSelectedQuestions();
  //         });
  //       },
  //       onUndo: () {
  //         setState(() {
  //           for (Question q in questionsToRemove) {
  //             _selectedQuestions[q.id!] = true;
  //             _addQuestion(q.id!, q);
  //           }
  //           _resetSelectedQuestions();

  //           for (Question q in questionsToRemove) {
  //             _toggleQuestionSelection(q.id!);
  //           }
  //         });
  //       },
  //     ),
  //   );
  // }

  // TODO: check
  void _commandRemoveQuestions() {
    final List<Question> questionsToRemove = [];
    for (int i = 0; i < _selectedQuestions.length; i++) {
      if (_selectedQuestions[i]) {
        questionsToRemove.add(_questions[i]);
      }
    }

    _commandExecutor.executeCommand(
      CustomCommand(
        name:
            "remove(num: ${questionsToRemove.length}, newSize: ${_questions.length + questionsToRemove.length})",
        onExecute: () {
          _removeQuestions(questionsToRemove, deselect: true);
        },
        onUndo: () {
          _resetSelectedQuestions();
          _addQuestions(questionsToRemove, select: true);
        },
        onRedo: () {
          _resetSelectedQuestions();
          _removeQuestions(questionsToRemove, deselect: false);
        },
      ),
    );
  }

  // // TODO: check why it doesn't work (Non è colpa della remove (provare a fare 2 remove, poi 2 undo e poi 2 redo, la seconda redo si bugga)
  // void _commandRemoveQuestions() {
  //   Map<String, dynamic> stateBeforeRemoval = {};

  //   // PRINT UTILITY
  //   final List<int> selectedIndices = [];
  //   for (int i = 0; i < _selectedQuestions.length; i++) {
  //     if (_selectedQuestions[i]) {
  //       selectedIndices.add(i);
  //     }
  //   }
  //   String idList = selectedIndices.join(",");

  //   _commandExecutor.executeCommand(
  //     CustomQuestionCommand(
  //       name:
  //           "remove: [$idList] ($_selectedCount/${_selectedQuestions.length})",
  //       onExecute: () {
  //         setState(() {
  //           stateBeforeRemoval = _createStateSnapshot();
  //           _removeSelectedQuestions(_selectedQuestions);
  //         });
  //       },
  //       onUndo: () {
  //         setState(() {
  //           _restoreState(stateBeforeRemoval);
  //         });
  //       },
  //     ),
  //   );
  // }

  void _commandEditQuestion() {
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
          topics: widget.topics,
          questions: _questions,
          onSubmit: (question) {
            // TODO
          },
          question: _questions[iSelected],
        );
      },
    );

    // if Ok (edit complete)
    // add new command
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

    _commandExecutor = CommandExecutor(
      initState: "init(size: ${widget.questions.length})",
    );
    _questions = List.from(widget.questions);
    _selectedQuestions = List.filled(_questions.length, false, growable: true);
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
                onChanged: _questions.isEmpty
                    ? null
                    : (value) {
                        setState(() {
                          if (_selectedAll == null || _selectedAll == false) {
                            _selectedAll = true;
                            for (
                              int i = 0;
                              i < _selectedQuestions.length;
                              i++
                            ) {
                              _selectedQuestions[i] = true;
                            }
                            _selectedCount = _selectedQuestions.length;
                            return;
                          }

                          if (_selectedAll == true) {
                            _selectedAll = false;
                            for (
                              int i = 0;
                              i < _selectedQuestions.length;
                              i++
                            ) {
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
                      isSelected: _selectedQuestions[index],
                      // TODO
                      //hideCorrectAnswer: !widget.showAnswers,
                      onSelected: () {
                        _toggleQuestionSelection(index);
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
                                _commandAddNewQuestion();
                              }
                            : null,
                        icon: Icon(Icons.add),
                        iconSize: 35,
                      ),
                    ),
                    if (kDebugMode)
                      Tooltip(
                        waitDuration: Duration(milliseconds: 500),
                        message: "Modifica",
                        child: IconButton(
                          onPressed: _selectedCount == 1
                              ? () {
                                  _commandEditQuestion();
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
                                _commandRemoveQuestions();
                              }
                            : null,
                        icon: Icon(Icons.delete),
                        iconSize: 35,
                      ),
                    ),
                    SizedBox(width: 10.0),
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
