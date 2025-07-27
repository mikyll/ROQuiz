import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:provider/provider.dart';

import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/style/theme_provider.dart';
import 'package:roquiz/view/view_info.dart';
import 'package:roquiz/view/view_questions.dart';
import 'package:roquiz/view/view_quiz.dart';
import 'package:roquiz/view/view_topics.dart';

class ViewMenu extends StatefulWidget {
  final PackageInfo packageInfo;

  const ViewMenu({super.key, required this.packageInfo});

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  final QuestionRepository _questionRepository = QuestionRepository();
  Map<String, bool> _selectedTopics = {};

  int _numQuizQuestions = 16;
  int _timer = 18;

  int _calculateNumSelected() {
    int num = 0;

    Map<String, List<Question>> topicSizes = _questionRepository
        .getGroupedQuestions();
    for (String topic in topicSizes.keys) {
      if (_selectedTopics[topic] != null && _selectedTopics[topic]!) {
        num += topicSizes[topic]!.length;
      }
    }

    return num;
  }

  // Get the question list
  List<Question> _getQuizPool() {
    List<Question> questions = [];
    Map<String, List<Question>> groupedQuestions = _questionRepository
        .getGroupedQuestions();

    for (String topic in _selectedTopics.keys) {
      if (_selectedTopics[topic]! && groupedQuestions[topic] != null) {
        questions.addAll(groupedQuestions[topic]!);
      }
    }

    return questions;
  }

  void _test() {
    String res = "\n";
    int curr = 0;
    for (String topic in _selectedTopics.keys) {
      bool isSelected = _selectedTopics[topic] ?? false;
      int num = _questionRepository.getGroupedQuestions()[topic]?.length ?? 0;

      res += "- [";
      res += isSelected ? "x" : " ";
      res += "] $topic: $num (+$curr)\n";
      if (isSelected) {
        curr += num;
      }
    }
    print(res);
    print(curr);
  }

  void _initQuestionRepository() {
    _questionRepository.loadFromAsset().then((_) {
      setState(() {
        _selectedTopics = {
          for (var value in _questionRepository.getGroupedQuestions().keys)
            value: true,
        };
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // From settings
    // TODO: set quiz pool
    // TODO: set quiz timer
    _initQuestionRepository();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ConstrainedBox(
              // TODO
              constraints: BoxConstraints(maxWidth: 400.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Settings.SHOW_APP_LOGO
                  //     ? Column(
                  //         children: [
                  //           SvgPicture.asset(
                  //             'assets/icons/logo.svg',
                  //             alignment: Alignment.center,
                  //             fit: BoxFit.fitWidth,
                  //             width: 200,
                  //             colorFilter: ColorFilter.mode(
                  //               Colors.indigo[300]!,
                  //               BlendMode.srcIn,
                  //             ),
                  //           ),
                  //           const Text(
                  //             Settings.APP_TITLE,
                  //             style: TextStyle(
                  //               fontSize: 40,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     :
                  Text(
                    "ROQuiz",
                    maxLines: 1,
                    style: TextTheme.of(context).displayLarge,
                  ),
                  Text(
                    "v${widget.packageInfo.version}",
                    maxLines: 1,
                    style: TextTheme.of(context).headlineSmall,
                  ),
                  const Spacer(flex: 1),
                  Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (isDarkMode) {
                      themeProvider.toggleTheme();
                    },
                  ),

                  // BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewQuiz(
                                  quizPool: _getQuizPool(),
                                  questionNum: _numQuizQuestions,
                                  timer: _timer,
                                  // TODO
                                  shuffleAnswers: false,
                                );
                              },
                            ),
                          );

                          // TODO

                          // widget.value.isDarkMode;
                          //     widget.value.toggleTheme(widget.value.themeMode == ThemeMode.light);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text("Avvia Quiz", maxLines: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(flex: 1),
                      const Icon(Icons.format_list_numbered_rounded),
                      Text(
                        "Domande: $_numQuizQuestions su ${_calculateNumSelected()}"
                            .padRight(22),
                      ),
                      const Spacer(flex: 2),
                      const Icon(Icons.timer_rounded),
                      Text("Tempo: $_timer min".padRight(22)),
                      const Spacer(flex: 1),
                    ],
                  ),
                  Visibility(
                    visible: true,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "error",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: ElevatedButton.icon(
                      label: Text(
                        "Domande",
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      icon: Icon(Icons.format_list_numbered),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButtonTheme.of(context).style,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ViewQuestions(
                                questions: _questionRepository.getQuestions(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: ElevatedButton.icon(
                      label: Text(
                        "Argomenti",
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      icon: Icon(Icons.checklist),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButtonTheme.of(context).style,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ViewTopics(
                                quizPool: _numQuizQuestions,
                                questionsPerTopic: _questionRepository
                                    .getGroupedQuestions(),
                                selectedTopics: _selectedTopics,
                                toggleTopic: (Map<String, bool> v) {
                                  setState(() {
                                    _selectedTopics = v;
                                  });
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: ElevatedButton.icon(
                      label: Text(
                        "Storico",
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      icon: Icon(Icons.history),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButtonTheme.of(context).style,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // TODO
                              return Text("");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: IconButton.filled(
              padding: EdgeInsets.only(right: 2.0),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return ViewSettings();
                //     },
                //   ),
                // );
              },
              iconSize: 45,
              icon: Icon(Icons.history),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 60,
            width: 60,
            child: IconButton.filled(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return ViewSettings();
                //     },
                //   ),
                // );
              },
              iconSize: 45,
              icon: Icon(Icons.settings),
            ),
          ),
          const SizedBox(height: 10.0),
          // IconButtonWidget(
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) =>
          //     //     return ViewSettings(
          //     //       qRepo: qRepo,
          //     //       settings: _settings,
          //     //       reloadTopics: loadTopics,
          //     //   )),
          //     // );
          //   },
          //   width: 60.0,
          //   height: 60.0,
          //   lightPalette: MyThemes.lightIconButtonPalette,
          //   darkPalette: MyThemes.darkIconButtonPalette,
          //   icon: Icons.settings,
          //   iconSize: 40,
          //   shadow: true,
          // ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 60,
            width: 60,
            child: IconButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ViewInfo(packageInfo: widget.packageInfo);
                    },
                  ),
                );
              },
              iconSize: 45,
              icon: Icon(
                Icons.info,
                // TODO
                // color:
                //     themeProvider.isDarkMode ? Color(0xff515b92) : Colors.white,
              ),
            ),
          ),
          // IconButtonWidget(
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       // return ViewInfo(settings: _settings);

          //       // TODO
          //       return ViewMenu();
          //     }));
          //   },
          //   width: 60.0,
          //   height: 60.0,
          //   lightPalette: MyThemes.lightIconButtonPalette,
          //   darkPalette: MyThemes.darkIconButtonPalette,
          //   icon: Icons.info,
          //   iconSize: 40,
          //   shadow: true,
          // ),
        ],
      ),
    );
  }
}
