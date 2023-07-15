import 'package:flutter/material.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/views/ViewQuiz.dart';
import 'package:roquiz/views/ViewSettings.dart';
import 'package:roquiz/views/ViewTopics.dart';
import 'package:roquiz/views/ViewInfo.dart';
import 'package:roquiz/model/Themes.dart';
import 'package:roquiz/widget/icon_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ViewMenu extends StatefulWidget {
  const ViewMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final QuestionRepository qRepo = QuestionRepository();

  String _qRepoLoadingError = "";

  final Settings _settings = Settings();
  bool _topicsPresent = false;
  final List<bool> _selectedTopics = [];
  int _quizPool = 0;

  late Future<int> _quizQuestionNumber;
  late Future<int> _timer;

  void _initTopics() {
    setState(() {
      for (int i = 0; i < qRepo.topics.length; i++) {
        _selectedTopics.add(true);
        _quizPool += qRepo.qNumPerTopic[i];
      }
    });
  }

  void resetTopics() {
    setState(() {
      for (int i = 0; i < _selectedTopics.length; i++) {
        _selectedTopics[i] = true;
      }
      _quizPool = qRepo.questions.length;
    });
  }

  List<Question> _getPoolFromSelected() {
    List<Question> res = [];
    for (int i = 0, j = 0; i < _selectedTopics.length; i++) {
      if (_selectedTopics[i]) {
        for (int k = 0; k < qRepo.getQuestionNumPerTopic()[i]; j++, k++) {
          res.add(qRepo.getQuestions()[j]);
        }
      } else {
        j += qRepo.getQuestionNumPerTopic()[i];
      }
    }

    return res;
  }

  void updateQuizPool(int v) {
    setState(() {
      _quizPool = v;
    });
  }

  void saveSettings(
      int qNum, int timer, bool shuffle, bool confirmAlerts, bool dTheme) {
    setState(() {
      _settings.questionNumber = qNum;
      _settings.timer = timer;
      _settings.shuffleAnswers = shuffle;
      _settings.confirmAlerts = confirmAlerts;
      _settings.darkTheme = dTheme;
      _settings.saveSettings();
      resetTopics();
    });
  }

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      //print(packageInfo.appName);
      //print(packageInfo.packageName);
      setState(
        () {
          Settings.VERSION_NUMBER = packageInfo.version;
        },
      );

      //print(Settings.VERSION_NUMBER);
      //print(packageInfo.buildNumber);
    });

    _settings.loadSettings();
    qRepo
        .loadFile("assets/domande.txt")
        .then(
          (_) => {
            _initTopics(),
            setState(
              () {
                _topicsPresent = qRepo.hasTopics();
              },
            )
          },
        )
        .onError((error, stackTrace) =>
            {setState(() => _qRepoLoadingError = error.toString())});

    _quizQuestionNumber = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("questionNumber") ?? -1;
    });
    _timer = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("timer") ?? -1;
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<List>(
              future: Future.wait([_quizQuestionNumber, _timer]),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(flex: 2),
                              const Text("ROQuiz",
                                  style: TextStyle(
                                    fontSize: 54,
                                    fontWeight: FontWeight
                                        .bold, /*fontStyle: FontStyle.italic*/
                                  )),
                              Text(
                                "v${Settings.VERSION_NUMBER}",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(flex: 1),
                              // BUTTONS
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: ElevatedButton(
                                  onPressed: qRepo.questions.isEmpty
                                      ? null
                                      : () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewQuiz(
                                                        questions:
                                                            _getPoolFromSelected(),
                                                        settings: _settings,
                                                      )));
                                        },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    child: const Text(
                                      "Avvia",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: ElevatedButton(
                                  onPressed: _topicsPresent
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewTopics(
                                                        qRepo: qRepo,
                                                        settings: _settings,
                                                        updateQuizPool:
                                                            updateQuizPool,
                                                        selectedTopics:
                                                            _selectedTopics,
                                                      )));
                                        }
                                      : null,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    child: const Text(
                                      "Argomenti",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.format_list_numbered_rounded,
                                    ),
                                    Text(
                                        "Domande: ${_settings.questionNumber} su $_quizPool"),
                                    const SizedBox(width: 20),
                                    const Icon(
                                      Icons.timer_rounded,
                                    ),
                                    Text("Tempo: ${_settings.timer} min"),
                                  ]),
                              _qRepoLoadingError.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        _qRepoLoadingError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ))
                                  : const SizedBox(height: 50),
                              InkWell(
                                onTap: () {
                                  _launchInBrowser(
                                      "https://github.com/mikyll/ROQuiz");
                                },
                                child: Container(
                                  color: Colors.indigo.withOpacity(0.35),
                                  height: 120,
                                  alignment: Alignment.center,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "Se l'app ti è piaciuta, considera di lasciare una stellina alla repository GitHub!\n\nBasta un click qui!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                  ),
                                ),
                              ),
                              const Spacer(flex: 5),
                            ],
                          ));
                    }
                }
              })),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButtonWidget(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewSettings(
                            qRepo: qRepo,
                            settings: _settings,
                            saveSettings: saveSettings,
                          )));
            },
            width: 60.0,
            height: 60.0,
            lightPalette: MyThemes.lightIconButtonPalette,
            darkPalette: MyThemes.darkIconButtonPalette,
            icon: Icons.settings,
            iconSize: 40,
          ),
          const SizedBox(height: 10.0),
          IconButtonWidget(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewInfo(settings: _settings)));
            },
            width: 60.0,
            height: 60.0,
            lightPalette: MyThemes.lightIconButtonPalette,
            darkPalette: MyThemes.darkIconButtonPalette,
            icon: Icons.info,
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}
