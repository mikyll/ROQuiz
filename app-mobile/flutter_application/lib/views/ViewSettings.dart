import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';

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

  void _selectDarkTheme(bool value) {
    setState(() {
      _darkTheme = value;
    });
  }

  void _reset() {
    setState(() {
      _questionNumber = Settings.DEFAULT_QUESTION_NUMBER;
      _timer = Settings.DEFAULT_TIMER;
      _shuffleAnswers = Settings.DEFAULT_SHUFFLE_ANSWERS;
      _darkTheme = Settings.DEFAULT_DARK_THEME;
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
    return WillPopScope(
      onWillPop: () async {
        // ask for save / discard ?
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          title: const Text("Impostazioni"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // discard
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SETTING: QUESTIONS NUMBER
              Row(
                children: [
                  const Expanded(
                      child: Text("Numero domande per quiz: ",
                          style: TextStyle(fontSize: 20))),
                  // DECREASE QUESTION NUMBER
                  GestureDetector(
                    onTap: () {
                      _decreaseQuestionNumber(1);
                    },
                    onLongPressStart: (_) async {
                      _isPressedQD = true;
                      do {
                        _decreaseQuestionNumber(10);
                        await Future.delayed(const Duration(milliseconds: 500));
                      } while (_isPressedQD);
                    },
                    onLongPressEnd: (_) =>
                        {setState(() => _isPressedQD = false)},
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: const Icon(
                          Icons.remove,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                  GestureDetector(
                    onTap: () {
                      _increaseQuestionNumber(1);
                    },
                    onLongPressStart: (_) async {
                      _isPressedQI = true;
                      do {
                        _increaseQuestionNumber(10);
                        await Future.delayed(const Duration(milliseconds: 500));
                      } while (_isPressedQI);
                    },
                    onLongPressEnd: (_) =>
                        {setState(() => _isPressedQI = false)},
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
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

                GestureDetector(
                  onTap: () {
                    _decreaseTimer(1);
                  },
                  onLongPressStart: (_) async {
                    _isPressedTD = true;
                    do {
                      _decreaseTimer(10);
                      await Future.delayed(const Duration(milliseconds: 500));
                    } while (_isPressedTD);
                  },
                  onLongPressEnd: (_) => {setState(() => _isPressedTD = false)},
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Icon(
                        Icons.remove,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // TIMER COUNTER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 35.0,
                    child:
                        Text("$_timer", style: const TextStyle(fontSize: 20)),
                  ),
                ),
                // INCREASE TIMER
                GestureDetector(
                  onTap: () {
                    _increaseTimer(1);
                  },
                  onLongPressStart: (_) async {
                    _isPressedTI = true;
                    do {
                      _increaseTimer(10);
                      await Future.delayed(const Duration(milliseconds: 500));
                    } while (_isPressedTI);
                  },
                  onLongPressEnd: (_) => {setState(() => _isPressedTI = false)},
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                    child: Checkbox(
                        checkColor: Colors.black,
                        value: _shuffleAnswers,
                        onChanged: (bool? value) =>
                            _selectShuffleAnswer(value!)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // SETTING: DARK THEME
              Row(
                children: [
                  const Expanded(
                      child:
                          Text("Tema scuro: ", style: TextStyle(fontSize: 20))),
                  SizedBox(
                    width: 120.0,
                    child: Checkbox(
                        checkColor: Colors.black,
                        value: _darkTheme,
                        onChanged: (bool? value) => _selectDarkTheme(value!)),
                  ),
                ],
              ),
            ],
          ),
        ),
        // BUTTONS: Save, Cancel, Restore
        persistentFooterButtons: [
          Row(
            children: [
              InkWell(
                enableFeedback: true,
                onTap: () {
                  widget.saveSettings(
                      _questionNumber, _timer, _shuffleAnswers, _darkTheme);
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Salva",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                enableFeedback: true,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Cancella",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const Spacer(flex: 5),
              InkWell(
                enableFeedback: true,
                onTap: () {
                  _reset();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Ripristina",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
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
