import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/edit_question/commands/custom_command.dart';
import 'package:roquiz/model/edit_question/command_executor.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/utils/selection_controller.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/question_dialog.dart';
import 'package:roquiz/widget/select_all_checkbox.dart';
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
  late SelectionController _selection;

  late CommandExecutor _commandExecutor;

  void _resetSelectedQuestions() {
    setState(() {
      _selection.reset(_questions.length);
    });
  }

  void _toggleQuestionSelection(int i) {
    setState(() {
      _selection.toggle(i);
    });
  }

  void _addQuestion(int id, Question question, {bool select = false}) {
    setState(() {
      _questions.insert(id, question);
      _selection.insert(id, selected: select);

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

  /// Removes the question with ID, updating all the other questions' IDs.
  ///
  /// The selection count is decreased only when the removed question was
  /// actually selected, which [SelectionController.removeAt] handles: e.g.
  /// when redoing a removal the selection has been reset first, so nothing is
  /// counted off.
  void _removeQuestion(int id) {
    setState(() {
      _questions.removeAt(id);
      _selection.removeAt(id);

      // Update IDs
      for (int i = id; i < _questions.length; i++) {
        _questions[i].id = i;
      }
    });
  }

  void _removeQuestions(List<Question> questions) {
    for (int i = questions.length - 1; i >= 0; i--) {
      _removeQuestion(questions[i].id);
    }
  }

  void _editQuestion(int id, Question q) {
    setState(() {
      _questions[id].topic = q.topic;
      _questions[id].body = q.body;
      _questions[id].answers = List.from(q.answers);
      _questions[id].correctAnswer = q.correctAnswer;
    });
  }

  /// Adds a new question, inserting it at the end of the topic
  void _commandAddNewQuestion() {
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

  // TODO: check
  void _commandRemoveQuestions() {
    final List<Question> questionsToRemove = [
      for (final i in _selection.selectedIndices) _questions[i],
    ];

    _commandExecutor.executeCommand(
      CustomCommand(
        name:
            "remove(num: ${questionsToRemove.length}, newSize: ${_questions.length + questionsToRemove.length})",
        onExecute: () {
          _removeQuestions(questionsToRemove);
        },
        onUndo: () {
          _resetSelectedQuestions();
          _addQuestions(questionsToRemove, select: true);
        },
        onRedo: () {
          _resetSelectedQuestions();
          _removeQuestions(questionsToRemove);
        },
      ),
    );
  }

  void _commandEditQuestion() {
    final List<int> selected = _selection.selectedIndices;
    if (selected.isEmpty) {
      return;
    }
    final Question questionBefore = _questions[selected.first];

    // Snapshot the pre-edit state for undo. _editQuestion mutates the list
    // element in place, so a deep copy is required: keeping a reference to
    // questionBefore would be overwritten by the edit itself.
    final Question original = Question.copy(questionBefore);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDialog(
          topics: widget.topics,
          questions: _questions,
          question: questionBefore,
          onSubmit: (question) {
            _commandExecutor.executeCommand(
              CustomCommand(
                name: "edit()",
                onExecute: () {
                  _editQuestion(question.id, question);
                },
                onUndo: () {
                  _editQuestion(original.id, original);
                },
                onRedo: () {
                  _editQuestion(question.id, question);
                },
              ),
            );
          },
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
    _selection = SelectionController(_questions.length);
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
          title: Text("Selezionate: ${_selection.count}/${_selection.length}"),
          leading: CustomBackButton(),
          actions: [
            SelectAllCheckbox(
              value: _selection.allSelected,
              onChanged: _questions.isEmpty
                  ? null
                  : () => setState(() => _selection.toggleAll()),
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
                      isSelected: _selection.isSelected(index),
                      // TODO
                      //hideCorrectAnswer: !widget.showAnswers,
                      onSelected: () {
                        _toggleQuestionSelection(index);
                      },
                      tapToSelect: _selection.hasSelection,
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
          child: SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15.0,
                  children: [
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Aggiungi una nuova domanda",
                      child: IconButton(
                        onPressed: !_selection.hasSelection
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
                          onPressed: _selection.count == 1
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
                        onPressed: _selection.hasSelection
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
            ),
          ),
        ),
      ),
    );
  }
}
