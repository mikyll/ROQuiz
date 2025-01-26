import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import 'package:roquiz/cli/utils/navigation.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/themes.dart';
import 'package:roquiz/view/view_info.dart';
import 'package:roquiz/view/view_settings.dart';
import 'package:roquiz/model/constants.dart';
import 'package:roquiz/view/view_topics.dart';

class ViewMenu extends StatefulWidget {
  ViewMenu({super.key});

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  final QuestionRepository _questionRepository = QuestionRepository();
  Map<String, bool> _selectedTopics = {};

  int _numQuizQuestions = 20;
  int _numSelectedQuestions = 0;
  int _timer = 0;

  int _calculateNumSelected() {
    int num = 0;

    Map<String, List<Question>> topicSizes =
        _questionRepository.getGroupedQuestions();
    for (String topic in topicSizes.keys) {
      if (_selectedTopics[topic] != null && _selectedTopics[topic]!) {
        num += topicSizes[topic]!.length;
      }
    }

    return num;
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

  void _updateQuizValues() {
    setState(() {
      // Num Quiz Questions
      // Tot Num Questions
      _numSelectedQuestions = _calculateNumSelected();
      // Timer from settings
    });
    _test();
  }

  void _initQuestionRepository() {
    _questionRepository.loadFromAsset().then((_) {
      setState(() {
        _numSelectedQuestions = _questionRepository.getQuestions().length;
        _selectedTopics = {
          for (var value in _questionRepository.getGroupedQuestions().keys)
            value: true
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Settings.SHOW_APP_LOGO
                    ? Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/logo.svg',
                            alignment: Alignment.center,
                            fit: BoxFit.fitWidth,
                            width: 200,
                            colorFilter: ColorFilter.mode(
                              Colors.indigo[300]!,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Text(
                            Settings.APP_TITLE,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        Settings.APP_TITLE,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                Text(
                  "v${Settings.VERSION_NUMBER}",
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO

                        // widget.value.isDarkMode;
                        //     widget.value.toggleTheme(widget.value.themeMode == ThemeMode.light);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Avvia",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ViewTopics(
                                questionRepository: _questionRepository,
                                selectedTopics: _selectedTopics,
                                numQuizQuestions: _numQuizQuestions,
                                updateQuizValues: _updateQuizValues,
                              );
                            },
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Argomenti",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 5.0,
                  children: [
                    const Icon(
                      Icons.format_list_numbered_rounded,
                    ),
                    Text(
                        "Domande: $_numQuizQuestions su $_numSelectedQuestions"),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.timer_rounded,
                    ),
                    Text("Tempo: $_timer min"),
                  ],
                ),
                false
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "error",
                          style: const TextStyle(color: Colors.red),
                        ))
                    : const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    openUrl("https://github.com/mikyll/ROQuiz");
                  },
                  child: Container(
                    color: Colors.indigo.withOpacity(0.35),
                    alignment: Alignment.center,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Se l'app ti è piaciuta, considera di lasciare una stellina alla repository GitHub!\n\nBasta un click qui!",
                          maxLines: 6,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
                const Spacer(flex: 5),
              ],
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ViewSettings();
                    },
                  ),
                );
              },
              iconSize: 45,
              icon: Icon(
                Icons.settings,
              ),
            ),
          ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewInfo();
                }));
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
