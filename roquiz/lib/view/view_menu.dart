import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:provider/provider.dart';

import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/persistence/quiz_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/view/view_history.dart';
import 'package:roquiz/view/view_info.dart';
import 'package:roquiz/view/view_questions.dart';
import 'package:roquiz/view/view_quiz.dart';
import 'package:roquiz/view/view_settings.dart';
import 'package:roquiz/view/view_topics.dart';

import 'package:flutter/foundation.dart';

class ViewMenu extends StatefulWidget {
  final PackageInfo packageInfo;
  final QuizRepository quizRepository;

  const ViewMenu({
    super.key,
    required this.packageInfo,
    required this.quizRepository,
  });

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  final QuestionRepository _questionRepository = QuestionRepository();

  Map<String, bool> _selectedTopics = {};

  int _totQuestions = 0;
  String? _error = kDebugMode ? "Error" : null;

  // int _calculateNumSelected() {
  //   int num = 0;

  //   Map<String, List<Question>> topicSizes = _questionRepository
  //       .getGroupedQuestions();
  //   for (String topic in topicSizes.keys) {
  //     if (_selectedTopics[topic] != null && _selectedTopics[topic]!) {
  //       num += topicSizes[topic]!.length;
  //     }
  //   }

  //   return num;
  // }

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

  void _initQuestionRepository() async {
    _questionRepository
        .init()
        .then((_) {
          setState(() {
            _totQuestions = _questionRepository.questions.length;
            _selectedTopics = {
              for (var value in _questionRepository.getGroupedQuestions().keys)
                value: true,
            };
            _error = null;
          });
        })
        .onError((error, stackTrace) {
          setState(() {
            _error = error.toString();
          });
        });
  }

  @override
  void initState() {
    super.initState();

    _initQuestionRepository();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500.0),
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
                                  questionNum: settings.quizQuestions,
                                  timer: settings.quizTime,
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
                          child: Text(
                            "Avvia Quiz",
                            maxLines: 1,
                            style: TextStyle(fontSize: 32),
                          ),
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
                        "Domande: ${settings.quizQuestions.toString().padLeft(3)} "
                        "su ${_getQuizPool().length.toString().padLeft(3)}",
                      ),
                      const Spacer(flex: 2),
                      const Icon(Icons.timer_rounded),
                      Text(
                        "Tempo: ${settings.quizTime.toString().padLeft(3)} min",
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                  Visibility(
                    // TODO
                    visible: _error != null,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          // Expand Stacktrace (modal, which obscures the rest)
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: BoxBorder.all(color: Colors.red),
                          ),
                          child: Text(
                            "Error",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.format_list_numbered),
                    iconAlignment: IconAlignment.end,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Domande",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButtonTheme.of(context).style?.copyWith(
                      fixedSize: WidgetStateProperty.all(Size(170.0, 30.0)),
                      padding: WidgetStateProperty.all(
                        EdgeInsetsGeometry.only(left: 15.0, right: 15.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewQuestions(
                              questions: _questionRepository.questions,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.checklist),
                    iconAlignment: IconAlignment.end,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Argomenti",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButtonTheme.of(context).style?.copyWith(
                      fixedSize: WidgetStateProperty.all(Size(170.0, 30.0)),
                      padding: WidgetStateProperty.all(
                        EdgeInsetsGeometry.only(left: 15.0, right: 15.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewTopics(
                              questionsNum: settings.quizQuestions,
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
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.history),
                    iconAlignment: IconAlignment.end,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Storico",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButtonTheme.of(context).style?.copyWith(
                      fixedSize: WidgetStateProperty.all(Size(170.0, 30.0)),
                      padding: WidgetStateProperty.all(
                        EdgeInsetsGeometry.only(left: 15.0, right: 15.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            // TODO: replace with QuizRepository
                            final sampleQuestions = [
                              Question(
                                id: 0,
                                body: "Quale protocollo opera al livello di trasporto del modello OSI?",
                                answers: ["HTTP", "TCP", "IP", "Ethernet"],
                                correctAnswer: 1,
                                topic: "Protocolli",
                              ),
                              Question(
                                id: 1,
                                body: "Quanti bit compongono un indirizzo IPv4?",
                                answers: ["16", "64", "32", "128"],
                                correctAnswer: 2,
                                topic: "Indirizzamento",
                              ),
                              Question(
                                id: 2,
                                body: "Qual è la funzione principale del protocollo ARP?",
                                answers: [
                                  "Assegnare indirizzi IP dinamicamente",
                                  "Instradare pacchetti tra reti diverse",
                                  "Risolvere un indirizzo IP in indirizzo MAC",
                                  "Garantire la consegna affidabile dei dati",
                                ],
                                correctAnswer: 2,
                                topic: "Protocolli",
                              ),
                              Question(
                                id: 3,
                                body: "Quale algoritmo di routing è basato sull'algoritmo di Dijkstra?",
                                answers: ["Distance Vector", "Path Vector", "Flooding", "Link State"],
                                correctAnswer: 3,
                                topic: "Routing",
                              ),
                              Question(
                                id: 4,
                                body: "Cosa indica la sigla NAT?",
                                answers: [
                                  "Network Access Token",
                                  "Network Address Translation",
                                  "Node Authentication Table",
                                  "Node Address Transfer",
                                ],
                                correctAnswer: 1,
                                topic: "Indirizzamento",
                              ),
                            ];

                            final qc1 = QuizCompleted(
                              questions: sampleQuestions,
                              questionNum: sampleQuestions.length,
                              shuffleAnswers: false,
                              timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
                              timeSpent: 487,
                              correctAnswers: 4,
                              grade: 26.0,
                            );
                            // Q0 TCP: correct, Q1 IPv4: wrong (picked 64), Q2 ARP: correct,
                            // Q3 Dijkstra: correct, Q4 NAT: correct
                            qc1.selectedAnswers[0] = 1;
                            qc1.selectedAnswers[1] = 1;
                            qc1.selectedAnswers[2] = 2;
                            qc1.selectedAnswers[3] = 3;
                            qc1.selectedAnswers[4] = 1;

                            final qc2 = QuizCompleted(
                              questions: sampleQuestions,
                              questionNum: sampleQuestions.length,
                              shuffleAnswers: false,
                              timestamp: DateTime.now().subtract(Duration(days: 7, hours: 5)),
                              timeSpent: 743,
                              correctAnswers: 2,
                              grade: 13.0,
                            );
                            // Q0 TCP: wrong (HTTP), Q1 IPv4: correct, Q2 ARP: wrong,
                            // Q3 Dijkstra: correct, Q4 NAT: wrong (null = unanswered)
                            qc2.selectedAnswers[0] = 0;
                            qc2.selectedAnswers[1] = 2;
                            qc2.selectedAnswers[2] = 0;
                            qc2.selectedAnswers[3] = 3;
                            qc2.selectedAnswers[4] = null;

                            final qc3 = QuizCompleted(
                              questions: sampleQuestions,
                              questionNum: sampleQuestions.length,
                              shuffleAnswers: false,
                              timestamp: DateTime.now().subtract(Duration(days: 14, hours: 1)),
                              timeSpent: 901,
                              correctAnswers: 5,
                              grade: 32.0,
                            );
                            // All correct
                            qc3.selectedAnswers[0] = 1;
                            qc3.selectedAnswers[1] = 2;
                            qc3.selectedAnswers[2] = 2;
                            qc3.selectedAnswers[3] = 3;
                            qc3.selectedAnswers[4] = 1;

                            return ViewHistory(quizList: [qc1, qc2, qc3]);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.bar_chart),
                    iconAlignment: IconAlignment.end,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Statistiche",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButtonTheme.of(context).style?.copyWith(
                      fixedSize: WidgetStateProperty.all(Size(170.0, 30.0)),
                      padding: WidgetStateProperty.all(
                        EdgeInsetsGeometry.only(left: 15.0, right: 15.0),
                      ),
                    ),
                    onPressed: null,
                    // () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) {
                    //         // TODO
                    //         return Text("");
                    //       },
                    //     ),
                    //   );
                    // },
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
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
                              return ViewSettings(
                                maxQuizPool:
                                    _questionRepository.questions.length,
                              );
                            },
                          ),
                        );
                      },
                      iconSize: 45,
                      icon: Icon(Icons.settings),
                    ),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
