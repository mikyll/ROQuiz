import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/AppUpdater.dart';
import 'package:roquiz/model/Utils.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/model/Themes.dart';
import 'package:roquiz/widget/change_theme_button_widget.dart';
import 'package:roquiz/widget/confirmation_alert.dart';
import 'package:roquiz/widget/icon_button_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({
    Key? key,
    required this.qRepo,
    required this.settings,
    required this.saveSettings,
    required this.reloadTopics,
  }) : super(key: key);

  final QuestionRepository qRepo;
  final Settings settings;
  final Function(bool? appCheck, bool? qCheck, int? qNum, int? timer,
      bool? shuffle, bool? confirmAlerts, bool? dTheme) saveSettings;
  final Function() reloadTopics;

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  final ScrollController _scrollController = ScrollController();

  bool _checkAppUpdate = Settings.DEFAULT_CHECK_APP_UPDATE;
  bool _checkQuestionsUpdate = Settings.DEFAULT_CHECK_QUESTIONS_UPDATE;
  int _questionNumber = Settings.DEFAULT_QUESTION_NUMBER;
  int _timer = Settings.DEFAULT_TIMER;
  bool _shuffleAnswers = Settings.DEFAULT_SHUFFLE_ANSWERS;
  bool _confirmAlerts = Settings.DEFAULT_CONFIRM_ALERTS;
  bool _darkTheme = Settings.DEFAULT_DARK_THEME; // previous value

  bool _wentBack =
      false; // to check if the user went back while choosing the questions file
  bool _isLoading = false;

  void _updateQuizDefaults() {
    setState(() {
      // If the new questions exceeds the Settings values bounds, update the settings
      int? qNum, timer;
      if (_questionNumber > widget.qRepo.questions.length) {
        _questionNumber = widget.qRepo.questions.length;
        qNum = _questionNumber;
      }
      if (_timer > widget.qRepo.questions.length * 2) {
        _timer = widget.qRepo.questions.length * 2;
        timer = _timer;
      }
      widget.saveSettings(null, null, qNum, timer, null, null, null);

      if (widget.qRepo.questions.length < 16) {
        Settings.DEFAULT_QUESTION_NUMBER = widget.qRepo.questions.length;
        Settings.DEFAULT_TIMER = Settings.DEFAULT_QUESTION_NUMBER + 2;
      } else {
        Settings.DEFAULT_QUESTION_NUMBER = 16;
        Settings.DEFAULT_TIMER = Settings.DEFAULT_QUESTION_NUMBER + 2;
      }
    });
  }

  void _checkNewVersion() {
    print("Versione corrente: ${Settings.VERSION_NUMBER}");

    setState(() {
      _isLoading = true;
    });

    AppUpdater.checkNewVersion(Settings.VERSION_NUMBER).then((result) {
      setState(() {
        _isLoading = false;
      });

      bool newVersionPresent = result.$1;
      String newVersion = result.$2;
      String newVersionDownloadURL = result.$3;

      if (newVersionPresent) {
        _showConfirmationDialog(
          context,
          "Nuova Versione App",
          "È stata trovata una versione più recente dell'applicazione.\n"
              "Versione attuale: v${Settings.VERSION_NUMBER}\n"
              "Nuova versione: $newVersion\n"
              "Scaricare la nuova versione?",
          "Sì",
          "No",
          () {
            //_launchInBrowser("https://github.com/mikyll/ROQuiz/releases/latest");
            _launchInBrowser(newVersionDownloadURL);
            Navigator.pop(context);
          },
          () => Navigator.pop(context),
        );
      } else {
        _showConfirmationDialog(
          context,
          "Nessuna Nuova Versione",
          "L'applicazione è aggiornata all'ultima versione disponibile (${Settings.VERSION_NUMBER}).",
          "",
          "Ok",
          null,
          () => Navigator.pop(context),
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      _showConfirmationDialog(
        context,
        "Errore Durante il Controllo",
        error.toString(),
        "",
        "Ok",
        null,
        () => Navigator.pop(context),
      );
    });
  }

  void _resetCheckAppUpdate() {
    setState(() => _checkAppUpdate = Settings.DEFAULT_CHECK_APP_UPDATE);
  }

  void _selectCheckAppUpdate(bool value) {
    setState(() {
      _checkAppUpdate = value;
    });
  }

  void _checkNewQuestions() {
    print("Versione corrente: ${widget.qRepo.lastQuestionUpdate}");

    setState(() {
      _isLoading = true;
    });

    widget.qRepo.checkQuestionUpdates().then((result) {
      setState(() {
        _isLoading = false;
      });
      bool newQuestionsPresent = result.$1;
      DateTime date = result.$2;
      int qNum = result.$3;
      if (newQuestionsPresent) {
        _showConfirmationDialog(
          context,
          "Nuove Domande",
          "È stata trovata una versione più recente del file contenente le domande.\n"
              "Versione attuale: ${widget.qRepo.questions.length} domande (${Utils.getParsedDateTime(widget.qRepo.lastQuestionUpdate)}).\n"
              "Nuova versione: $qNum domande (${Utils.getParsedDateTime(date)}).\n"
              "Scaricare il nuovo file?",
          "Sì",
          "No",
          () {
            setState(() {
              widget.qRepo.update();
            });
            _updateQuizDefaults();
            Navigator.pop(context);
          },
          () => Navigator.pop(context),
        );
      } else {
        _showConfirmationDialog(
          context,
          "Nessuna Nuova Domanda",
          "Non sono state trovate nuove domande. Il file è aggiornato all'ultima versione (${Utils.getParsedDateTime(widget.qRepo.lastQuestionUpdate)}).",
          "",
          "Ok",
          null,
          () => Navigator.pop(context),
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      _showConfirmationDialog(
        context,
        "Errore Durante il Controllo",
        error.toString(),
        "",
        "Ok",
        null,
        () => Navigator.pop(context),
      );
    });
  }

  void _resetCheckQuestionsUpdate() {
    setState(
        () => _checkQuestionsUpdate = Settings.DEFAULT_CHECK_QUESTIONS_UPDATE);
  }

  void _selectCheckQuestionsUpdate(bool value) {
    setState(() {
      _checkQuestionsUpdate = value;
    });
  }

  void _loadQuestionFilePath() async {
    setState(() {
      _isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["txt"]);

    // For Desktop platform: when a user leaves the Settings page, and then uploads a questions file.
    if (_wentBack) {
      return;
    }

    if (result != null) {
      File file = File(result.files.single.path!);

      String content = await file.readAsString();

      int res;
      String err;
      (res, err) = QuestionRepository.isValidErrors(content);
      if (res > 0) {
        widget.qRepo.updateQuestionsDate(QuestionRepository.CUSTOM_DATE);
        await widget.qRepo.updateQuestionsFile(content);
        widget.reloadTopics();
      }

      _showConfirmationDialog(
        context,
        res > 0 ? "File Caricato" : "File Non Valido",
        res > 0
            ? "Il file domande personalizzato è stato caricato correttamente.\n"
                "Numero domande: $res"
            : err,
        "",
        "Ok",
        null,
        () => Navigator.pop(context),
      );
    }
    setState(() {
      _isLoading = false;

      _updateQuizDefaults();
    });
  }

  void _resetQuestionNumber() {
    setState(() => _questionNumber = Settings.DEFAULT_QUESTION_NUMBER);
  }

  void _increaseQuestionNumber(int v) {
    setState(() {
      _questionNumber + v <= widget.qRepo.questions.length
          ? _questionNumber += v
          : _questionNumber = widget.qRepo.questions.length;
    });
  }

  void _decreaseQuestionNumber(int v) {
    setState(() {
      _questionNumber - v >= 1 ? _questionNumber -= v : _questionNumber = 1;
    });
  }

  void _resetTimer() {
    setState(() => _timer = Settings.DEFAULT_TIMER);
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
      _timer - v >= 2 ? _timer -= v : _timer = 2;
    });
  }

  void _resetShuffleAnswers() {
    setState(() => _shuffleAnswers = Settings.DEFAULT_SHUFFLE_ANSWERS);
  }

  void _selectShuffleAnswers(bool value) {
    setState(() {
      _shuffleAnswers = value;
    });
  }

  void _resetConfirmAlerts() {
    setState(() => _confirmAlerts = Settings.DEFAULT_CONFIRM_ALERTS);
  }

  void _selectConfirmAlerts(bool value) {
    setState(() {
      _confirmAlerts = value;
    });
  }

  void _resetTheme(ThemeProvider themeProvider) {
    setState(() {
      themeProvider.toggleTheme(Settings.DEFAULT_DARK_THEME);
    });
  }

  void _reset(ThemeProvider themeProvider) {
    _resetCheckAppUpdate();
    _resetCheckQuestionsUpdate();
    _resetQuestionNumber();
    _resetTimer();
    _resetShuffleAnswers();
    _resetConfirmAlerts();
    _resetTheme(themeProvider);
  }

  bool _isDefault(ThemeProvider themeProvider) {
    return _checkAppUpdate == Settings.DEFAULT_CHECK_APP_UPDATE &&
        _checkQuestionsUpdate == Settings.DEFAULT_CHECK_QUESTIONS_UPDATE &&
        _questionNumber == Settings.DEFAULT_QUESTION_NUMBER &&
        _timer == Settings.DEFAULT_TIMER &&
        _shuffleAnswers == Settings.DEFAULT_SHUFFLE_ANSWERS &&
        _confirmAlerts == Settings.DEFAULT_CONFIRM_ALERTS &&
        themeProvider.isDarkMode == Settings.DEFAULT_DARK_THEME;
  }

  bool _isChanged(ThemeProvider themeProvider) {
    return _checkAppUpdate != widget.settings.checkAppUpdate ||
        _checkQuestionsUpdate != widget.settings.checkQuestionsUpdate ||
        _questionNumber != widget.settings.questionNumber ||
        _timer != widget.settings.timer ||
        _shuffleAnswers != widget.settings.shuffleAnswers ||
        _confirmAlerts != widget.settings.confirmAlerts ||
        themeProvider.isDarkMode != widget.settings.darkTheme;
  }

  void _showConfirmationDialog(
      BuildContext context,
      String title,
      String content,
      String confirmButton,
      String cancelButton,
      void Function()? onConfirm,
      void Function()? onCancel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationAlert(
              title: title,
              content: content,
              buttonConfirmText: confirmButton,
              buttonCancelText: cancelButton,
              onConfirm: onConfirm,
              onCancel: onCancel);
        });
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _checkQuestionsUpdate = widget.settings.checkQuestionsUpdate;
      _questionNumber = widget.settings.questionNumber;
      _timer = widget.settings.timer;
      _shuffleAnswers = widget.settings.shuffleAnswers;
      _confirmAlerts = widget.settings.confirmAlerts;
      _darkTheme = widget.settings.darkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        if (_isChanged(themeProvider) && widget.settings.confirmAlerts) {
          _showConfirmationDialog(
            context,
            "Modifiche Non Salvate",
            "Uscire senza salvare?",
            "Conferma",
            "Annulla",
            () {
              // Discard settings (Confirm)
              setState(() => _wentBack = true);
              themeProvider.toggleTheme(_darkTheme);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            () {
              Navigator.pop(context);
            },
          );
        } else {
          setState(() => _wentBack = true);
          themeProvider.toggleTheme(_darkTheme);
          Navigator.pop(context);
        }

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
              if (_isChanged(themeProvider) && widget.settings.confirmAlerts) {
                _showConfirmationDialog(
                  context,
                  "Modifiche Non Salvate",
                  "Uscire senza salvare?",
                  "Conferma",
                  "Annulla",
                  () {
                    // Discard settings (Confirm)
                    setState(() => _wentBack = true);
                    themeProvider.toggleTheme(_darkTheme);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  () {
                    Navigator.pop(context);
                  },
                );
              } else {
                setState(() => _wentBack = true);
                themeProvider.toggleTheme(_darkTheme);
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(25.0),
            controller: _scrollController,
            shrinkWrap: true,
            primary: false,
            children: [
              // SETTING: New App Version Check
              Row(
                children: [
                  IconButtonWidget(
                    onTap: _isLoading
                        ? null
                        : () {
                            _checkNewVersion();
                          },
                    lightPalette: MyThemes.lightIconButtonPalette,
                    darkPalette: MyThemes.darkIconButtonPalette,
                    width: 40.0,
                    height: 40.0,
                    icon: Icons.sync_rounded,
                    iconSize: 35,
                    borderRadius: 5,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetCheckAppUpdate();
                        },
                        child: const Text("Controllo nuove versioni app: ",
                            softWrap: true, style: TextStyle(fontSize: 20))),
                  ),
                  SizedBox(
                      width: 120.0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: _checkAppUpdate,
                            onChanged: (bool? value) =>
                                _selectCheckAppUpdate(value!)),
                      ))
                ],
              ),
              const SizedBox(height: 20),
              // SETTING: New Questions Check
              Row(
                children: [
                  IconButtonWidget(
                    onTap: _isLoading
                        ? null
                        : () {
                            _checkNewQuestions();
                          },
                    lightPalette: MyThemes.lightIconButtonPalette,
                    darkPalette: MyThemes.darkIconButtonPalette,
                    width: 40.0,
                    height: 40.0,
                    icon: Icons.sync_rounded,
                    iconSize: 35,
                    borderRadius: 5,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetCheckQuestionsUpdate();
                        },
                        child: const Text("Controllo nuove domande: ",
                            softWrap: true, style: TextStyle(fontSize: 20))),
                  ),
                  SizedBox(
                      width: 120.0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: _checkQuestionsUpdate,
                            onChanged: (bool? value) =>
                                _selectCheckQuestionsUpdate(value!)),
                      ))
                ],
              ),
              const SizedBox(height: 20),
              // SETTING: Questions File
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          // TO-DO: edit
                        },
                        child: const Text("File domande: ",
                            style: TextStyle(fontSize: 20))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      width: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: IconButtonWidget(
                              onTap: true
                                  ? null
                                  : () {
                                      print("TO-DO: Edit question file.");
                                    },
                              lightPalette: MyThemes.lightIconButtonPalette,
                              darkPalette: MyThemes.darkIconButtonPalette,
                              width: 40.0,
                              height: 40.0,
                              icon: Icons.edit,
                              iconSize: 35,
                              borderRadius: 5,
                            ),
                          ),
                          const Spacer(flex: 1),
                          IconButtonWidget(
                            onTap: _isLoading
                                ? null
                                : () {
                                    _loadQuestionFilePath();
                                  },
                            lightPalette: MyThemes.lightIconButtonPalette,
                            darkPalette: MyThemes.darkIconButtonPalette,
                            width: 40.0,
                            height: 40.0,
                            icon: Icons.file_open_outlined,
                            iconSize: 35,
                            borderRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // SETTING: QUIZ QUESTION NUMBER
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetQuestionNumber();
                        },
                        child: const Text("Numero domande per quiz: ",
                            style: TextStyle(fontSize: 20))),
                  ),
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
                Expanded(
                  child: InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onDoubleTap: () {
                        _resetTimer();
                      },
                      child: const Text("Timer (minuti): ",
                          style: TextStyle(fontSize: 20))),
                ),
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
                    child:
                        Text("$_timer", style: const TextStyle(fontSize: 20)),
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
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetShuffleAnswers();
                        },
                        child: const Text("Mescola risposte: ",
                            style: TextStyle(fontSize: 20))),
                  ),
                  SizedBox(
                      width: 120.0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: _shuffleAnswers,
                            onChanged: (bool? value) =>
                                _selectShuffleAnswers(value!)),
                      ))
                ],
              ),
              const SizedBox(height: 20),
              // SETTING: CONFIRM ALERTS
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetConfirmAlerts();
                        },
                        child: const Text("Alert di conferma: ",
                            style: TextStyle(fontSize: 20))),
                  ),
                  SizedBox(
                      width: 120.0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: _confirmAlerts,
                            onChanged: (bool? value) =>
                                _selectConfirmAlerts(value!)),
                      ))
                ],
              ),
              const SizedBox(height: 20),
              // SETTING: DARK THEME
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetTheme(themeProvider);
                        },
                        child: const Text("Tema scuro: ",
                            style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(
                    width: 120.0,
                    child: ChangeThemeButtonWidget(),
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: IconButtonWidget(
          onTap: _isDefault(themeProvider)
              ? null
              : () {
                  _reset(themeProvider);
                },
          width: 60.0,
          height: 60.0,
          lightPalette: MyThemes.lightIconButtonPalette,
          darkPalette: MyThemes.darkIconButtonPalette,
          icon: Icons.refresh,
          iconSize: 45,
          shadow: true,
        ),
        // BUTTONS: Save, Cancel
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                  top: BorderSide(color: Theme.of(context).disabledColor))),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.saveSettings(
                            _checkAppUpdate,
                            _checkQuestionsUpdate,
                            _questionNumber,
                            _timer,
                            _shuffleAnswers,
                            _confirmAlerts,
                            themeProvider.isDarkMode);
                        _darkTheme = themeProvider.isDarkMode;

                        setState(() => _wentBack = true);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: 100.0,
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
                        themeProvider.toggleTheme(_darkTheme);

                        setState(() => _wentBack = true);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: 100.0,
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
              )),
        ),
      ),
    );
  }
}
