import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/view/view_questions_edit.dart';
import 'package:roquiz/view/view_questions_edit_file.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/separator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roquiz/widget/custom_search_bar.dart';

class ViewQuestions extends StatefulWidget {
  final List<Question> questions;

  const ViewQuestions({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  late List<Question> _questions;

  bool _searchBarOpen = false;

  void _toggleAnswers(Settings settings) {
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

    _questions = widget.questions;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: AnimatedOpacity(
            opacity: _searchBarOpen ? 0.0 : 1.0,
            curve: Curves.easeOutSine,
            duration: const Duration(milliseconds: 250),
            child: Text("Lista Domande (${_questions.length})"),
          ),
          actions: [
            CustomSearchBar(
              textController: _textController,
              autoFocus: false,
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
              onSearch: (_) {},
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
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  cacheExtent: 1000,
                  itemBuilder: (_, index) {
                    Widget questionWidget = QuestionCard.base(
                      question: _questions[index],
                      iQuestion: index + 1,
                      hideCorrectAnswer: settings.hideCorrectAnswersInEditMode,
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
        bottomNavigationBar: Padding(
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
                    _toggleAnswers(settings);
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
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Modifica",
                child: IconButton(
                  onPressed: !kDebugMode
                      ? null
                      : () {
                          // TODO: change animation
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) {
                                return ViewQuestionsEdit(
                                  questions: _questions,
                                  hideAnswers:
                                      settings.hideCorrectAnswersInEditMode,
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
                  icon: Icon(Icons.edit),
                  iconSize: 35,
                ),
              ),
              // Edit mode (file)
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Modifica File",
                child: IconButton(
                  onPressed: !kDebugMode
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
                                return ViewQuestionsEditFile(fileContent: "");
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
    );
  }
}
