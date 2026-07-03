import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/utils/question.dart';
import 'package:roquiz/view/view_questions_edit.dart';
import 'package:roquiz/view/view_questions_edit_file.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/separator.dart';
import 'package:roquiz/widget/custom_search_bar.dart';

class ViewQuestions extends StatefulWidget {
  final List<Question> questions;
  final String title;
  final bool editable;

  /// Backing store for the questions. Required for edits made in the edit
  /// screen to be persisted; when null the edit screen can't save.
  final QuestionRepository? repository;

  const ViewQuestions({
    super.key,
    required this.questions,
    this.title = "Lista Domande",
    this.editable = true,
    this.repository,
  });

  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  // SelectionArea over a lazy ListView crashes if the set of selectables
  // changes (items built/disposed) while a selection is active. We clear any
  // active selection when scrolling starts to keep the indices consistent.
  final GlobalKey<SelectionAreaState> _selectionKey =
      GlobalKey<SelectionAreaState>();

  late String _title;
  // Authoritative full question set for this screen. Seeded from
  // widget.questions and refreshed from the repository after an editing
  // session; search/reset derive from it (not the stale widget.questions).
  late List<Question> _allQuestions;
  // The currently displayed list: either all questions or the search results.
  late List<Question> _questions;

  bool _searchBarOpen = false;

  void _resetQuestions() {
    setState(() {
      _questions = List.from(_allQuestions);
    });
  }

  void _searchQuestions(String value, {bool ignoreCase = true}) {
    if (ignoreCase) {
      value = value.toLowerCase();
    }

    _scrollController.jumpTo(0.0);
    setState(() {
      _questions.clear();

      // Loop over the question list
      for (int i = 0; i < _allQuestions.length; i++) {
        String questionBody = _allQuestions[i].body;
        if (ignoreCase) {
          questionBody = questionBody.toLowerCase();
        }

        // Add the question if the search string is contained in question body
        if (questionBody.contains(value)) {
          _questions.add(_allQuestions[i]);
          continue;
        }

        // Add the question if the search string is contained in a question answer
        for (int j = 0; j < _allQuestions[i].answers.length; j++) {
          String answer = _allQuestions[i].answers[j];
          if (ignoreCase) {
            answer = answer.toLowerCase();
          }

          if (answer.contains(value)) {
            _questions.add(_allQuestions[i]);
            break;
          }
        }
      }
    });
  }

  void _toggleShowAnswers(Settings settings) {
    settings.hideCorrectAnswersInEditMode =
        !settings.hideCorrectAnswersInEditMode;
    SettingsManager.save(settings);
  }

  void _enterEditMode() {}

  void _checkUpdates() {}

  void _importFromFile() {}

  void _exportToFile() {}

  @override
  void initState() {
    super.initState();

    _allQuestions = List.from(widget.questions);
    _resetQuestions();
    _title = "${widget.title} (${_allQuestions.length})";
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);

    return PopScope(
      canPop: true,
      // onPopInvoked: (_) {
      //   // todo
      // },
      child: Scaffold(
        appBar: ConstrainedAppBar(
          maxWidth: 500.0,
          title: AnimatedOpacity(
            opacity: _searchBarOpen ? 0.0 : 1.0,
            curve: Curves.easeOutSine,
            duration: const Duration(milliseconds: 250),
            child: Text(_title),
          ),
          leading: CustomBackButton(),
          actions: [
            CustomSearchBar(
              textController: _textController,
              autoFocus: _textController.text.isEmpty,
              helpText: "Cerca...",
              onOpen: () {
                setState(() {
                  _searchBarOpen = true;
                });
              },
              onClose: () {
                setState(() {
                  _searchBarOpen = false;
                });
              },
              onSearch: (searchString) {
                _searchQuestions(searchString);
                setState(() {
                  _title =
                      "Trovate: ${_questions.length}/${_allQuestions.length}";
                });
              },
              onClear: () {
                _resetQuestions();
                _title = "${widget.title} (${_allQuestions.length})";
              },
            ),
          ],
        ),
        body: SelectionArea(
          key: _selectionKey,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.0),
                child: NotificationListener<ScrollStartNotification>(
                  onNotification: (_) {
                    _selectionKey.currentState?.selectableRegion
                        .clearSelection();
                    return false;
                  },
                  child: Scrollbar(
                    interactive: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _questions.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      cacheExtent: 1000,
                      itemBuilder: (_, index) {
                        Widget questionWidget = QuestionCard.base(
                          question: _questions[index],
                          hideCorrectAnswer:
                              settings.hideCorrectAnswersInEditMode,
                        );

                        // Check if we have to display the topic divider
                        if (_questions.first.topic != _questions.last.topic &&
                            (index == 0 ||
                                _questions[index].topic !=
                                    _questions[index - 1].topic)) {
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
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor.withAlpha(70),
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
                    // Show/Hide correct answers
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Mostra/nascondi le risposte corrette",
                      child: IconButton(
                        onPressed: () {
                          _toggleShowAnswers(settings);
                        },
                        icon: Icon(
                          settings.hideCorrectAnswersInEditMode
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 35,
                      ),
                    ),
                    // Check if there are new questions
                    if (widget.editable)
                      Tooltip(
                        waitDuration: Duration(milliseconds: 500),
                        message: "Controlla se ci sono nuove domande",
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.sync_rounded),
                          iconSize: 35,
                        ),
                      ),

                    // Edit mode
                    if (widget.editable)
                      Tooltip(
                        waitDuration: Duration(milliseconds: 500),
                        message: "Modifica",
                        child: IconButton(
                          onPressed: () async {
                            final bool? changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  // Always edit the full set, not the current
                                  // search results — otherwise saving would
                                  // persist only the filtered subset.
                                  final List<String> topics = getTopicsList(
                                    _allQuestions,
                                  );

                                  return ViewQuestionsEdit(
                                    questions: _allQuestions,
                                    topics: topics,
                                    hideAnswers:
                                        settings.hideCorrectAnswersInEditMode,
                                    repository: widget.repository,
                                  );
                                },
                              ),
                            );
                            // Edits were auto-saved to the repository; refresh
                            // the list (and drop any active search) to show them.
                            if (changed == true &&
                                widget.repository != null &&
                                mounted) {
                              setState(() {
                                _searchBarOpen = false;
                                _textController.clear();
                                _allQuestions = List.from(
                                  widget.repository!.questions,
                                );
                                _questions = List.from(_allQuestions);
                                _title =
                                    "${widget.title} (${_allQuestions.length})";
                              });
                            }
                            // TODO: change animation?
                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) {
                            //       return ViewQuestionsEdit(
                            //         questions: _questions,
                            //         hideAnswers:
                            //             settings.hideCorrectAnswersInEditMode,
                            //       );
                            //     },
                            //     transitionDuration: Duration.zero,
                            //     // transitionDuration: Duration(milliseconds: 300),
                            //     // transitionsBuilder: (_, animation, __, c) {
                            //     //   const begin = Offset(1.0, 0.0);
                            //     //   const end = Offset.zero;
                            //     //   var tween = Tween(
                            //     //     begin: begin,
                            //     //     end: end,
                            //     //   ).chain(CurveTween(curve: Curves.easeOut));
                            //     //   return SlideTransition(
                            //     //     position: animation.drive(tween),
                            //     //     child: c,
                            //     //   );
                            //     // },
                            //   ),
                            // );
                          },
                          icon: Icon(Icons.edit),
                          iconSize: 35,
                        ),
                      ),

                    // Edit mode (file)
                    if (widget.editable)
                      if (kDebugMode)
                        Tooltip(
                          waitDuration: Duration(milliseconds: 500),
                          message: "Modifica File",
                          child: IconButton(
                            onPressed: !widget.editable
                                ? null
                                : () {
                                    // Prompt for format

                                    // TODO: change animation

                                    Navigator.push(
                                      context,
                                      // PageRouteBuilder(
                                      //   pageBuilder: (_, __, ___) {
                                      //     return ViewQuestionsEditFile();
                                      //   },
                                      //   transitionDuration: Duration.zero,
                                      //   transitionsBuilder: (_, animation, __, child) {
                                      //     return child;
                                      //   },
                                      // ),
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) {
                                          return ViewQuestionsEditFile(
                                            fileContent: "",
                                          );
                                        },
                                        transitionDuration: Duration.zero,
                                        // transitionDuration: Duration(milliseconds: 300),
                                        // transitionsBuilder: (_, animation, __, c) {
                                        //   const begin = Offset(1.0, 0.0);
                                        //   const end = Offset.zero;
                                        //   var tween = Tween(
                                        //     begin: begin,
                                        //     end: end,
                                        //   ).chain(CurveTween(curve: Curves.easeOut));
                                        //   return SlideTransition(
                                        //     position: animation.drive(tween),
                                        //     child: c,
                                        //   );
                                        // },
                                      ),
                                    );
                                  },
                            icon: Icon(Icons.edit_document),
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
