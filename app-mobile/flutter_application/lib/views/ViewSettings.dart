import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';
import 'package:roquiz/widget/Themes.dart';
import 'package:roquiz/widget/change_theme_button_widget.dart';
import 'package:roquiz/widget/icon_button_widget.dart';

class ViewSettings extends StatefulWidget {
  ViewSettings({
    Key? key,
    required this.qRepo,
    required this.settings,
    required this.saveSettings,
  }) : super(key: key);

  final QuestionRepository qRepo;
  final Settings settings;
  final Function(int, int, bool, bool) saveSettings;

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  int _questionNumber = Settings.DEFAULT_QUESTION_NUMBER;
  int _timer = Settings.DEFAULT_TIMER;
  bool _shuffleAnswers = Settings.DEFAULT_SHUFFLE_ANSWERS;
  bool _darkTheme = Settings.DEFAULT_DARK_THEME;

  bool _isPressedQI = false;
  bool _isPressedQD = false;
  bool _isPressedTI = false;
  bool _isPressedTD = false;

  void _increaseQuestionNumber(int v) {
    setState(() {
      _questionNumber + v <= widget.qRepo.questions.length
          ? _questionNumber += v
          : _questionNumber = widget.qRepo.questions.length;
    });
  }

  void _decreaseQuestionNumber(int v) {
    setState(() {
      _questionNumber - v >= Settings.DEFAULT_QUESTION_NUMBER / 2
          ? _questionNumber -= v
          : _questionNumber = Settings.DEFAULT_QUESTION_NUMBER ~/ 2;
    });
  }

  void _increaseTimer(int v) {
    setState(() {
      _timer + v <= widget.qRepo.questions.length * 2
          ? _timer += v
          : _timer = widget.qRepo.questions.length * 2;
    });
  }

  void _decreaseTimer(int v) {
    setState(() {
      _timer - v >= Settings.DEFAULT_TIMER / 2
          ? _timer -= v
          : _timer = Settings.DEFAULT_TIMER ~/ 2;
    });
  }

  void _selectShuffleAnswer(bool value) {
    setState(() {
      _shuffleAnswers = value;
    });
  }

  void _reset(ThemeProvider _themeProvider) {
    setState(() {
      _questionNumber = Settings.DEFAULT_QUESTION_NUMBER;
      _timer = Settings.DEFAULT_TIMER;
      _shuffleAnswers = Settings.DEFAULT_SHUFFLE_ANSWERS;

      _themeProvider.toggleTheme(Settings.DEFAULT_DARK_THEME);
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _questionNumber = widget.settings.questionNumber;
      _timer = widget.settings.timer;
      _shuffleAnswers = widget.settings.shuffleAnswers;
      _darkTheme = widget.settings.darkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        // ask for save / discard ?
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Impostazioni"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              _themeProvider.toggleTheme(_darkTheme);
              // discard
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              // SETTING: QUESTIONS NUMBER
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: Text("Numero domande per quiz: ",
                              style: TextStyle(fontSize: 20))),
                      // DECREASE QUESTION NUMBER
                      IconButtonLongPressWidget(
                        onUpdate: () {
                          _decreaseQuestionNumber(1);
                        },
                        lightPalette: MyThemes.lightIconButtonPalette,
                        darkPalette: MyThemes.darkIconButtonPalette,
                        width: 40.0,
                        height: 40.0,
                        icon: Icons.remove,
                        iconSize: 35,
                      ),
                      // POOL SIZE COUNTER
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 35.0,
                          child: Text("$_questionNumber",
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                      // INCREASE POOL SIZE
                      IconButtonLongPressWidget(
                        onUpdate: () {
                          _increaseQuestionNumber(1);
                        },
                        lightPalette: MyThemes.lightIconButtonPalette,
                        darkPalette: MyThemes.darkIconButtonPalette,
                        width: 40.0,
                        height: 40.0,
                        icon: Icons.add,
                        iconSize: 35,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // SETTING: TIMER
                  Row(children: [
                    const Expanded(
                        child: Text("Timer (minuti): ",
                            style: TextStyle(fontSize: 20))),
                    // DECREASE TIMER
                    IconButtonLongPressWidget(
                      onUpdate: () {
                        _decreaseTimer(1);
                      },
                      lightPalette: MyThemes.lightIconButtonPalette,
                      darkPalette: MyThemes.darkIconButtonPalette,
                      width: 40.0,
                      height: 40.0,
                      icon: Icons.remove,
                      iconSize: 35,
                    ),
                    // TIMER COUNTER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: 35.0,
                        child: Text("$_timer",
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    // INCREASE TIMER
                    IconButtonLongPressWidget(
                      onUpdate: () {
                        _increaseTimer(1);
                      },
                      lightPalette: MyThemes.lightIconButtonPalette,
                      darkPalette: MyThemes.darkIconButtonPalette,
                      width: 40.0,
                      height: 40.0,
                      icon: Icons.add,
                      iconSize: 35,
                    ),
                  ]),

                  const SizedBox(height: 20),
                  // SETTING: SHUFFLE ANSWERS
                  Row(
                    children: [
                      const Expanded(
                          child: Text("Mescola risposte: ",
                              style: TextStyle(fontSize: 20))),
                      SizedBox(
                          width: 120.0,
                          child: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                                value: _shuffleAnswers,
                                onChanged: (bool? value) =>
                                    _selectShuffleAnswer(value!)),
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  // SETTING: DARK THEME
                  Row(
                    children: const [
                      Expanded(
                          child: Text("Tema scuro: ",
                              style: TextStyle(fontSize: 20))),
                      SizedBox(
                        width: 120.0,
                        child: ChangeThemeButtonWidget(),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(flex: 1),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.refresh,
                    size: 40.0,
                  ),
                  onPressed: () {
                    _reset(_themeProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  label: const Text(
                    "Ripristina",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // BUTTONS: Save, Cancel, Restore
        persistentFooterButtons: [
          Row(
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: ElevatedButton(
                  onPressed: () {
                    widget.saveSettings(_questionNumber, _timer,
                        _shuffleAnswers, _themeProvider.isDarkMode);
                    _darkTheme = _themeProvider.isDarkMode;
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      "Salva",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 5),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: ElevatedButton(
                  onPressed: () {
                    _themeProvider.toggleTheme(_darkTheme);

                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      "Cancella",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
