import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:provider/provider.dart';

import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/persistence/completed_quiz_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/view/view_history.dart';
import 'package:roquiz/view/view_info.dart';
import 'package:roquiz/view/view_questions.dart';
import 'package:roquiz/view/view_quiz.dart';
import 'package:roquiz/view/view_settings.dart';
import 'package:roquiz/view/view_statistics.dart';
import 'package:roquiz/view/view_topics.dart';

class ViewMenu extends StatefulWidget {
  final PackageInfo packageInfo;
  final CompletedQuizRepository completedQuizRepository;

  const ViewMenu({
    super.key,
    required this.packageInfo,
    required this.completedQuizRepository,
  });

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  static const double _maxContentWidth = 500.0;

  final QuestionRepository _questionRepository = QuestionRepository();

  Map<String, bool> _selectedTopics = {};

  String? _error;

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

  void _openSettings({SettingsAnchor? scrollTo}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ViewSettings(
            maxQuizPool: _questionRepository.questions.length,
            scrollTo: scrollTo,
          );
        },
      ),
    );
  }

  void _openTopics() {
    final settings = Provider.of<Settings>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ViewTopics(
            questionsNum: settings.quizQuestions,
            questionsPerTopic: _questionRepository.getGroupedQuestions(),
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
  }

  void _initQuestionRepository() async {
    _questionRepository
        .init()
        .then((_) {
          setState(() {
            _selectedTopics = {
              for (var value in _questionRepository.getGroupedQuestions().keys)
                value: true,
            };
            _error = null;
          });
          // Fast path is done (local/asset questions are shown); now check the
          // remote for a newer file in the background and refresh the topic
          // list if one was downloaded. Failures are non-fatal.
          _checkForNewerQuestions();
        })
        .onError((error, stackTrace) {
          setState(() {
            _error = error.toString();
          });
        });
  }

  void _checkForNewerQuestions() async {
    bool updated;
    try {
      updated = await _questionRepository.updateFromRemoteIfNewer();
    } catch (_) {
      // Offline / API error: keep the questions we already have.
      return;
    }
    if (!updated || !mounted) {
      return;
    }
    setState(() {
      // Re-derive the topic selection over the new question set, dropping
      // topics that no longer exist and defaulting new ones to selected.
      final grouped = _questionRepository.getGroupedQuestions();
      _selectedTopics = {
        for (var topic in grouped.keys) topic: _selectedTopics[topic] ?? true,
      };
    });
  }

  @override
  void initState() {
    super.initState();

    _initQuestionRepository();
  }

  // A secondary menu entry: label on the left, icon on the right.
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 220.0,
      height: 48.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButtonTheme.of(context).style?.copyWith(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15.0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            // Center the content when there's room, but scroll instead of
            // overflowing on short screens (landscape, split-screen, etc.).
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
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

                            // Start quiz (primary call to action)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                              ),
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
                                            completedQuizRepository:
                                                widget.completedQuizRepository,
                                            maxQuizPool: _questionRepository
                                                .questions
                                                .length,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
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

                            // Quiz summary (questions / time)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.format_list_numbered_rounded,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(text: "Domande: "),
                                              TextSpan(
                                                text:
                                                    "${settings.quizQuestions}",
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => _openSettings(
                                                    scrollTo: SettingsAnchor
                                                        .quizQuestions,
                                                  ),
                                              ),
                                              const TextSpan(text: " su "),
                                              TextSpan(
                                                text:
                                                    "${_getQuizPool().length}",
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = _openTopics,
                                              ),
                                            ],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.timer_rounded),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(text: "Tempo: "),
                                              TextSpan(
                                                text:
                                                    "${settings.quizTime} min",
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () =>
                                                          _openSettings(
                                                            scrollTo:
                                                                SettingsAnchor
                                                                    .quizTime,
                                                          ),
                                              ),
                                            ],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            if (_error != null)
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            // Secondary navigation
                            _buildMenuButton(
                              icon: Icons.format_list_numbered,
                              label: "Domande",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ViewQuestions(
                                        questions:
                                            _questionRepository.questions,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildMenuButton(
                              icon: Icons.checklist,
                              label: "Argomenti",
                              onPressed: _openTopics,
                            ),
                            const SizedBox(height: 10),
                            _buildMenuButton(
                              icon: Icons.history,
                              label: "Storico",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ViewHistory(
                                        completedQuizRepository:
                                            widget.completedQuizRepository,
                                        maxQuizPool: _questionRepository
                                            .questions
                                            .length,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildMenuButton(
                              icon: Icons.bar_chart,
                              label: "Statistiche",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ViewStatistics(
                                        completedQuizRepository:
                                            widget.completedQuizRepository,
                                        maxQuizPool: _questionRepository
                                            .questions
                                            .length,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
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
                      onPressed: () => _openSettings(),
                      iconSize: 45,
                      icon: const Icon(Icons.settings),
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
                      icon: const Icon(Icons.info),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
