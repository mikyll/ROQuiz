import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/AppUpdater.dart';
import 'package:roquiz/model/PlatformType.dart';
import 'package:roquiz/model/Utils.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/model/Themes.dart';
import 'package:roquiz/views/ViewEdit.dart';
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
    required this.reloadTopics,
  }) : super(key: key);

  final QuestionRepository qRepo;
  final Settings settings;
  final Function() reloadTopics;

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  final TextEditingController _questionNumberController =
      TextEditingController();
  final TextEditingController _timerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _checkAppUpdate = Settings.DEFAULT_CHECK_APP_UPDATE;
  bool _checkQuestionsUpdate = Settings.DEFAULT_CHECK_QUESTIONS_UPDATE;
  bool _maxQuestionPerTopic = Settings.DEFAULT_SHUFFLE_ANSWERS;
  int _questionNumber = Settings.DEFAULT_QUESTION_NUMBER;
  int _timer = Settings.DEFAULT_TIMER;
  bool _shuffleAnswers = Settings.DEFAULT_SHUFFLE_ANSWERS;
  bool _confirmAlerts = Settings.DEFAULT_CONFIRM_ALERTS;
  bool _darkTheme = Settings.DEFAULT_DARK_THEME; // previous value

  /// For Desktop platform: when a user leaves the Settings page with the
  /// file picker dialog still open and then select a file, the upload will
  /// fail.
  bool _wentBack = false;
  bool _isLoading = false;

  // Useful when checking for new questions: if the new questions exceeds the
  // Settings values bounds, thenupdate the pool (questionNumber) settings.
  void _updateQuizDefaults() {
    int? qNum, timer;

    setState(() {
      if (_questionNumber > widget.qRepo.questions.length) {
        _questionNumber = widget.qRepo.questions.length;
        qNum = _questionNumber;
      }
      if (_timer > widget.qRepo.questions.length * 2) {
        _timer = widget.qRepo.questions.length * 2;
        timer = _timer;
      }

      _questionNumberController.text = "$_questionNumber";
      _timerController.text = "$_timer";
    });

    // TODO
    _saveSettings(null, null, null, qNum, timer, null, null, null);

    setState(() {
      if (widget.qRepo.questions.length < 16) {
        Settings.DEFAULT_QUESTION_NUMBER = widget.qRepo.questions.length;
        Settings.DEFAULT_TIMER = (2 *
            Settings.DEFAULT_QUESTION_NUMBER ~/
            Settings.DEFAULT_QUESTION_NUMBER);
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
        ConfirmationAlert.showConfirmationDialog(
          context,
          "Nuova Versione App",
          "È stata trovata una versione più recente dell'applicazione.\n"
              "Versione attuale: v${Settings.VERSION_NUMBER}\n"
              "Nuova versione: $newVersion\n"
              "Scaricare la nuova versione?",
          confirmButton: "Sì",
          cancelButton: "No",
          onConfirm: () {
            // Link for latest release
            //_launchInBrowser("https://github.com/mikyll/ROQuiz/releases/latest");
            // Link to download specific version
            _launchInBrowser(newVersionDownloadURL);
          },
          onCancel: () {},
        );
      } else {
        ConfirmationAlert.showConfirmationDialog(
          context,
          "Nessuna Nuova Versione",
          "L'applicazione è aggiornata all'ultima versione disponibile (${Settings.VERSION_NUMBER}).",
          confirmButton: "",
          cancelButton: "Ok",
          onConfirm: null,
          onCancel: () {},
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      ConfirmationAlert.showConfirmationDialog(
        context,
        "Errore Durante il Controllo",
        error.toString(),
        confirmButton: "",
        cancelButton: "Ok",
        onConfirm: null,
        onCancel: () {},
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
        ConfirmationAlert.showConfirmationDialog(
          context,
          "Nuove Domande",
          "È stata trovata una versione più recente del file contenente le domande.\n"
              "Versione attuale: ${widget.qRepo.questions.length} domande (${Utils.getParsedDateTime(widget.qRepo.lastQuestionUpdate)}).\n"
              "Nuova versione: $qNum domande (${Utils.getParsedDateTime(date)}).\n"
              "Scaricare il nuovo file?",
          confirmButton: "Sì",
          cancelButton: "No",
          onConfirm: () {
            setState(() {
              _isLoading = false;
              widget.qRepo.update().then((value) {
                widget.reloadTopics();
                _updateQuizDefaults();
              });
            });
          },
          onCancel: () {},
        );
      } else {
        ConfirmationAlert.showConfirmationDialog(
          context,
          "Nessuna Nuova Domanda",
          "Non sono state trovate nuove domande. Il file è aggiornato all'ultima versione (${Utils.getParsedDateTime(widget.qRepo.lastQuestionUpdate)}).",
          confirmButton: "",
          cancelButton: "Ok",
          onConfirm: null,
          onCancel: () {},
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      ConfirmationAlert.showConfirmationDialog(
        context,
        "Errore Durante il Controllo",
        error.toString(),
        confirmButton: "",
        cancelButton: "Ok",
        onConfirm: null,
        onCancel: () {},
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

      ConfirmationAlert.showConfirmationDialog(
        context,
        res > 0 ? "File Caricato" : "File Non Valido",
        res > 0
            ? "Il file domande personalizzato è stato caricato correttamente.\n"
                "Numero domande: $res"
            : err,
        confirmButton: "",
        cancelButton: "Ok",
        onConfirm: null,
        onCancel: () {},
      );
    }
    setState(() {
      _isLoading = false;

      _updateQuizDefaults();
    });
  }

  void _resetQuestionNumber() {
    setState(() {
      _questionNumber = Settings.DEFAULT_QUESTION_NUMBER;

      _questionNumberController.text = "$_questionNumber";
    });
  }

  bool _canDecreaseQuestionNumber(int value) {
    return !_maxQuestionPerTopic &&
        _questionNumber - value >= Settings.MIN_QUESTIONS;
  }

  bool _canIncreaseQuestionNumber(int value) {
    return !_maxQuestionPerTopic &&
        _questionNumber + value <= widget.qRepo.questions.length;
  }

  void _updateQuestionNumber(int value) {
    setState(() {
      _questionNumber = value;

      if (value < Settings.MIN_QUESTIONS) {
        _questionNumber = Settings.MIN_QUESTIONS;
      }

      if (value > widget.qRepo.questions.length) {
        _questionNumber = widget.qRepo.questions.length;
      }

      // Update controller value
      _questionNumberController.text = "$_questionNumber";
    });
  }

  void _resetTimer() {
    setState(() {
      _timer = Settings.DEFAULT_TIMER;

      _timerController.text = "$_timer";
    });
  }

  bool _canDecreaseTimer(int value) {
    return _timer - value >= Settings.MIN_TIMER;
  }

  bool _canIncreaseTimer(int value) {
    return _timer + value <= widget.qRepo.questions.length * 2;
  }

  void _updateTimer(int value) {
    setState(() {
      _timer = value;

      if (value < Settings.MIN_TIMER) {
        _timer = Settings.MIN_TIMER;
      }

      if (value > widget.qRepo.questions.length * 2) {
        _timer = widget.qRepo.questions.length * 2;
      }

      // Update controller value
      _timerController.text = "$_timer";
    });
  }

  void _resetMaxQuestionPerTopic() {
    setState(
        () => _maxQuestionPerTopic = Settings.DEFAULT_MAX_QUESTIONS_PER_TOPIC);
  }

  void _selectMaxQuestionPerTopic(bool value) {
    setState(() => _maxQuestionPerTopic = value);
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

  void _reset(ThemeProvider themeProvider) {
    _resetCheckAppUpdate();
    _resetCheckQuestionsUpdate();
    _resetMaxQuestionPerTopic();
    _resetQuestionNumber();
    _resetTimer();
    _resetShuffleAnswers();
    _resetConfirmAlerts();
  }

  bool _isDefault(ThemeProvider themeProvider) {
    return _checkAppUpdate == Settings.DEFAULT_CHECK_APP_UPDATE &&
        _checkQuestionsUpdate == Settings.DEFAULT_CHECK_QUESTIONS_UPDATE &&
        _maxQuestionPerTopic == Settings.DEFAULT_MAX_QUESTIONS_PER_TOPIC &&
        _questionNumber == Settings.DEFAULT_QUESTION_NUMBER &&
        _timer == Settings.DEFAULT_TIMER &&
        _shuffleAnswers == Settings.DEFAULT_SHUFFLE_ANSWERS &&
        _confirmAlerts == Settings.DEFAULT_CONFIRM_ALERTS;
  }

  bool _isChanged(ThemeProvider themeProvider) {
    return _checkAppUpdate != widget.settings.checkAppUpdate ||
        _checkQuestionsUpdate != widget.settings.checkQuestionsUpdate ||
        _maxQuestionPerTopic != widget.settings.maxQuestionPerTopic ||
        _questionNumber != widget.settings.questionNumber ||
        _timer != widget.settings.timer ||
        _shuffleAnswers != widget.settings.shuffleAnswers ||
        _confirmAlerts != widget.settings.confirmAlerts ||
        themeProvider.isDarkMode != widget.settings.darkTheme;
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _loadSettings() {
    setState(() {
      _checkQuestionsUpdate = widget.settings.checkQuestionsUpdate;
      _maxQuestionPerTopic = widget.settings.maxQuestionPerTopic;
      _questionNumber = widget.settings.questionNumber;
      _timer = widget.settings.timer;
      _shuffleAnswers = widget.settings.shuffleAnswers;
      _confirmAlerts = widget.settings.confirmAlerts;
      _darkTheme = widget.settings.darkTheme;

      _questionNumberController.text = "$_questionNumber";
      _timerController.text = "$_timer";
    });
  }

  void _saveSettings(
      bool? appUpdateCheck,
      bool? questionsUpdateCheck,
      bool? maxQuestionPerTopic,
      int? qNum,
      int? timer,
      bool? shuffle,
      bool? confirmAlerts,
      bool? dTheme) {
    setState(() {
      if (appUpdateCheck != null) {
        widget.settings.checkAppUpdate = appUpdateCheck;
      }
      if (questionsUpdateCheck != null) {
        widget.settings.checkQuestionsUpdate = questionsUpdateCheck;
      }
      if (maxQuestionPerTopic != null) {
        widget.settings.maxQuestionPerTopic = maxQuestionPerTopic;
      }
      if (qNum != null) {
        widget.settings.questionNumber = qNum;
      }
      if (timer != null) {
        widget.settings.timer = timer;
      }
      if (shuffle != null) {
        widget.settings.shuffleAnswers = shuffle;
      }
      if (confirmAlerts != null) {
        widget.settings.confirmAlerts = confirmAlerts;
      }
      if (dTheme != null) {
        widget.settings.darkTheme = dTheme;
      }
      widget.settings.saveToSharedPreferences();
      widget.reloadTopics();
    });
  }

  void _showBackConfirmDialog(ThemeProvider themeProvider) {
    ConfirmationAlert.showConfirmationDialog(
      context,
      "Modifiche Non Salvate",
      "Uscire senza salvare?",
      onConfirm: () {
        // Discard settings (Confirm)
        setState(() => _wentBack = true);
        themeProvider.toggleTheme(_darkTheme);
        Navigator.pop(context);
      },
      onCancel: () {},
    );
  }

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return PopScope(
      canPop: !(_isChanged(themeProvider) && widget.settings.confirmAlerts),
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        _showBackConfirmDialog(themeProvider);
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
                _showBackConfirmDialog(themeProvider);
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
            padding: const EdgeInsets.all(15.0),
            controller: _scrollController,
            shrinkWrap: true,
            primary: false,
            children: [
              // SETTING: New App Version Check
              getPlatformType() == PlatformType.WEB
                  ? const SizedBox.shrink()
                  : Row(
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
                            child: const Text(
                              "Controllo nuove versioni app: ",
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 120.0,
                            child: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: _checkAppUpdate,
                                onChanged: (bool? value) =>
                                    _selectCheckAppUpdate(value!),
                              ),
                            ))
                      ],
                    ),
              const SizedBox(height: 20),
              // SETTING: New Questions Check
              getPlatformType() == PlatformType.WEB
                  ? const SizedBox.shrink()
                  : Row(
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
                            child: const Text(
                              "Controllo nuove domande: ",
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
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
              getPlatformType() == PlatformType.WEB
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "File domande: ",
                            maxLines: 2,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 100.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButtonWidget(
                                  tooltip: _isLoading ? null : "Modifica",
                                  onTap: _isLoading
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ViewEdit(
                                                qRepo: widget.qRepo,
                                                settings: widget.settings,
                                                reloadTopics:
                                                    widget.reloadTopics,
                                                updateQuizDefaults:
                                                    _updateQuizDefaults,
                                              ),
                                            ),
                                          );
                                        },
                                  lightPalette: MyThemes.lightIconButtonPalette,
                                  darkPalette: MyThemes.darkIconButtonPalette,
                                  width: 40.0,
                                  height: 40.0,
                                  icon: Icons.edit,
                                  iconSize: 35,
                                  borderRadius: 5,
                                ),
                                const Spacer(flex: 1),
                                IconButtonWidget(
                                  tooltip: _isLoading ? null : "Carica un file",
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
              // SETTING: USE MAX NUMBER OF QUESTIONS FOR EACH TOPIC
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onDoubleTap: () {
                          _resetMaxQuestionPerTopic();
                        },
                        child: const Text("Quiz su argomenti interi: ",
                            maxLines: 3, style: TextStyle(fontSize: 20))),
                  ),
                  SizedBox(
                      width: 120.0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: _maxQuestionPerTopic,
                            onChanged: (bool? value) =>
                                _selectMaxQuestionPerTopic(value!)),
                      ))
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
                        onDoubleTap: !_maxQuestionPerTopic
                            ? () {
                                _resetQuestionNumber();
                              }
                            : null,
                        child: const Text("Numero domande per quiz: ",
                            maxLines: 3, style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 5.0),
                  // DECREASE POOL SIZE (QUESTION NUMBER)
                  IconButtonLongPressWidget(
                    onUpdate: _canDecreaseQuestionNumber(1)
                        ? () {
                            _updateQuestionNumber(_questionNumber - 1);
                          }
                        : null,
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
                      width: 40.0,
                      child: TextField(
                        key: UniqueKey(),
                        enabled: !_maxQuestionPerTopic,
                        controller: _questionNumberController,
                        onEditingComplete: () {
                          _updateQuestionNumber(
                              int.tryParse(_questionNumberController.text) ??
                                  _questionNumber);
                        },
                        onSubmitted: (value) {
                          _updateQuestionNumber(
                              int.tryParse(value) ?? _questionNumber);
                        },
                        onTapOutside: (_) {
                          _updateQuestionNumber(
                              int.tryParse(_questionNumberController.text) ??
                                  _questionNumber);
                        },
                        maxLength: 3,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: const TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: ""),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  // INCREASE POOL SIZE (QUESTION NUMBER)
                  IconButtonLongPressWidget(
                    onUpdate: _canIncreaseQuestionNumber(1)
                        ? () {
                            _updateQuestionNumber(_questionNumber + 1);
                          }
                        : null,
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
                          maxLines: 2, style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 5.0),
                // DECREASE TIMER
                IconButtonLongPressWidget(
                  onUpdate: _canDecreaseTimer(1)
                      ? () {
                          _updateTimer(_timer - 1);
                        }
                      : null,
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
                    width: 40.0,
                    child: TextField(
                      key: UniqueKey(),
                      controller: _timerController,
                      onEditingComplete: () {
                        _updateTimer(
                            int.tryParse(_timerController.text) ?? _timer);
                      },
                      onSubmitted: (value) {
                        _updateTimer(int.tryParse(value) ?? _timer);
                      },
                      onTapOutside: (_) {
                        _updateTimer(
                            int.tryParse(_timerController.text) ?? _timer);
                      },
                      maxLength: 3,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: const TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: ""),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                // INCREASE TIMER
                IconButtonLongPressWidget(
                  onUpdate: _canIncreaseTimer(1)
                      ? () {
                          _updateTimer(_timer + 1);
                        }
                      : null,
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
                            maxLines: 2, style: TextStyle(fontSize: 20))),
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
                            maxLines: 2, style: TextStyle(fontSize: 20))),
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
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tema scuro: ",
                      maxLines: 2,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
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
          tooltip: _isDefault(themeProvider) ? null : "Ripristina",
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
                      onPressed: !_isChanged(themeProvider)
                          ? null
                          : () {
                              _saveSettings(
                                _checkAppUpdate,
                                _checkQuestionsUpdate,
                                _maxQuestionPerTopic,
                                _questionNumber,
                                _timer,
                                _shuffleAnswers,
                                _confirmAlerts,
                                themeProvider.isDarkMode,
                              );

                              setState(() {
                                _darkTheme = themeProvider.isDarkMode;
                              });
                              themeProvider.toggleTheme(_darkTheme);
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
                      onPressed: !_isChanged(themeProvider)
                          ? null
                          : () {
                              _loadSettings();
                              themeProvider.toggleTheme(_darkTheme);
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
