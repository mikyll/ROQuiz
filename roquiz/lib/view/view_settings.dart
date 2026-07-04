import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/icon_button_acceleration.dart';
import 'package:roquiz/widget/separator.dart';
import 'package:roquiz/widget/setting_entry.dart';

/// Rejects edits that would push the numeric value above [max] (e.g. a written
/// grade can't exceed 32). Assumes digits-only input is enforced upstream.
class _MaxValueInputFormatter extends TextInputFormatter {
  const _MaxValueInputFormatter(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final int? value = int.tryParse(newValue.text);
    if (value == null || value > max) {
      return oldValue;
    }
    return newValue;
  }
}

/// A settings entry the screen can scroll to when opened, so a caller (e.g. the
/// menu's quiz-summary links) can jump straight to the relevant control.
enum SettingsAnchor { quizQuestions, quizTime }

class ViewSettings extends StatefulWidget {
  final int maxQuizPool;

  /// When set, the screen scrolls this entry into view after its first layout.
  final SettingsAnchor? scrollTo;

  const ViewSettings({super.key, required this.maxQuizPool, this.scrollTo});

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  final ScrollController scrollController = ScrollController();
  // Anchors for [SettingsAnchor], so the screen can scroll a specific entry
  // into view when opened with widget.scrollTo set.
  final GlobalKey _quizQuestionsKey = GlobalKey();
  final GlobalKey _quizTimeKey = GlobalKey();
  // Stable key: recreating it on every build would tear down and rebuild the
  // Form subtree (the ListView), resetting the scroll position to the top.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TODO
  final TextEditingController writtenGradeController = TextEditingController();
  // The stepper fields use controllers (rather than initialValue) so the +/-
  // buttons can update what's shown: a FormField's initialValue only applies on
  // first build, so the value would otherwise never refresh on a rebuild.
  final TextEditingController quizQuestionsController = TextEditingController();
  final TextEditingController quizTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Seed the fields once. Reassigning controller.text on every build — and
    // saving a setting calls notifyListeners(), which rebuilds — would collapse
    // the cursor and make typing unusable.
    final settings = context.read<Settings>();
    writtenGradeController.text = settings.writtenGrade?.toString() ?? "";
    quizQuestionsController.text = settings.quizQuestions.toString();
    quizTimeController.text = settings.quizTime.toString();

    if (widget.scrollTo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToAnchor());
    }
  }

  /// Scrolls the entry named by [ViewSettings.scrollTo] into view. No-op if the
  /// target entry isn't currently rendered (its key has no context).
  void _scrollToAnchor() {
    final GlobalKey? key = switch (widget.scrollTo) {
      SettingsAnchor.quizQuestions => _quizQuestionsKey,
      SettingsAnchor.quizTime => _quizTimeKey,
      null => null,
    };
    final BuildContext? anchor = key?.currentContext;
    if (anchor == null) {
      return;
    }
    Scrollable.ensureVisible(
      anchor,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    writtenGradeController.dispose();
    quizQuestionsController.dispose();
    quizTimeController.dispose();
    super.dispose();
  }

  bool _isGradeValid(int? grade) {
    return grade != null && grade >= 0 && grade <= 32;
  }

  // Bounds for the stepper fields. Quiz questions can't exceed the available
  // pool (maxQuizPool); the time field is capped at its 3-digit width.
  static const int _minQuizQuestions = 1;
  static const int _minQuizTime = 1;
  static const int _maxQuizTime = 999;

  int get _maxQuizQuestions => widget.maxQuizPool < _minQuizQuestions
      ? _minQuizQuestions
      : widget.maxQuizPool;

  /// Sets the quiz-question count to [value] clamped to its valid range,
  /// syncing the field, the model and storage. Used by the +/- steppers and on
  /// submit; the live [TextFormField.onChanged] only updates the model so it
  /// doesn't move the caret while typing.
  void _setQuizQuestions(int value) {
    final settings = context.read<Settings>();
    final int clamped = value.clamp(_minQuizQuestions, _maxQuizQuestions);
    settings.quizQuestions = clamped;
    quizQuestionsController.text = clamped.toString();
    SettingsManager.save(settings);
  }

  /// Quiz-time counterpart of [_setQuizQuestions].
  void _setQuizTime(int value) {
    final settings = context.read<Settings>();
    final int clamped = value.clamp(_minQuizTime, _maxQuizTime);
    settings.quizTime = clamped;
    quizTimeController.text = clamped.toString();
    SettingsManager.save(settings);
  }

  /// Restores every setting to its default after a confirmation. Syncs the
  /// stepper/grade controllers so the visible fields reflect the reset (the
  /// switches/checkboxes refresh on their own via the save's notifyListeners).
  Future<void> _confirmRestoreDefaults() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ripristina impostazioni"),
          content: const Text(
            "Vuoi ripristinare tutte le impostazioni ai valori predefiniti?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Ripristina"),
            ),
          ],
        );
      },
    );

    if (!(confirmed ?? false) || !mounted) {
      return;
    }

    final settings = context.read<Settings>();
    settings.restoreDefaults();
    // The default question count may exceed a small pool; clamp it like the
    // stepper does so the value stays valid.
    settings.quizQuestions = settings.quizQuestions.clamp(
      _minQuizQuestions,
      _maxQuizQuestions,
    );
    writtenGradeController.text = settings.writtenGrade?.toString() ?? "";
    quizQuestionsController.text = settings.quizQuestions.toString();
    quizTimeController.text = settings.quizTime.toString();
    SettingsManager.save(settings);
  }

  /// A compact +/- stepper button. Kept small (no default 48px tap target) so a
  /// button + field + button fits the entry's fixed 150px control column.
  /// [onUpdate] fires once on tap and repeatedly while held (with acceleration).
  Widget _stepperButton(IconData icon, void Function() onUpdate) {
    return IconButtonAcceleration(
      onUpdate: onUpdate,
      icon: Icon(icon),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
    );
  }

  // Text style and horizontal padding shared by the stepper number fields and
  // by [_numberFieldWidth], so the measured width matches what's rendered.
  static const TextStyle _numberFieldStyle = TextStyle(fontSize: 16.0);
  static const double _numberFieldPadding = 8.0;

  /// Width that fits the field's max value (3 digits, e.g. "999"), so the value
  /// is never clipped. Measured from [_numberFieldStyle] rather than hard-coded.
  double _numberFieldWidth() {
    final TextPainter painter = TextPainter(
      text: const TextSpan(text: "000", style: _numberFieldStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    // text + padding on both sides + room for the caret. The caret allowance is
    // generous because, when the centered field is focused with 3 digits, the
    // cursor sits past the text and would otherwise clip the last digit.
    return painter.width + _numberFieldPadding * 2 + 16.0;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);

    return PopScope(
      canPop: true,
      // onPopInvokedWithResult: (didPop, result) {

      // },
      child: Scaffold(
        appBar: ConstrainedAppBar(
          maxWidth: 500.0,
          title: Text("Impostazioni"),
          leading: CustomBackButton(),
          // TODO
          // actionsPadding: EdgeInsets.only(right: 8.0),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.white),
                overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              ),
              onPressed: () {
                // TODO
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  controller: scrollController,
                  shrinkWrap: true,
                  primary: false,
                  // Build the whole (short, bounded) settings list up front rather
                  // than lazily: [_scrollToAnchor] uses Scrollable.ensureVisible on
                  // an entry's GlobalKey, which needs that entry already laid out.
                  // Without this the target is unbuilt below the fold (its context
                  // is null) and the scroll silently no-ops — most visibly in debug,
                  // where the extra kDebugMode entries push it further down.
                  scrollCacheExtent: ScrollCacheExtent.pixels(3000),
                  children: [
                    SizedBox(height: 10),
                    Separator(text: "Generale"),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Lingua:",
                        tooltip:
                            "Permette di impostare la lingua dell'applicazione.",
                        child: DropdownButtonFormField(
                          value: settings.language,
                          items: ["Italiano"].map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                              onTap: () {
                                settings.language = value;
                                SettingsManager.save(settings);
                              },
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    SettingEntry(
                      label: "Tema scuro:",
                      tooltip:
                          "Permette di impostare il tema dell'applicazione: chiaro o scuro.",
                      child: Switch(
                        value: settings.themeDark,
                        onChanged: (value) {
                          // TODO: why it's slow?
                          settings.themeDark = value;
                          SettingsManager.save(settings);
                        },
                      ),
                    ),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Controllo release app:",
                        tooltip:
                            "Se selezionata, all'avvio dell'app controlla se è presente una versione più recente dell'applicazione.",
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: settings.autoCheckRelease,
                            onChanged: (value) {
                              settings.autoCheckRelease = value!;
                              SettingsManager.save(settings);
                            },
                            splashRadius: 15,
                          ),
                        ),
                      ),

                    SettingEntry(
                      label: "Controllo nuove domande:",
                      tooltip:
                          "Se selezionata, all'avvio dell'app controlla se sono presenti nuove domande sulla repository remota.",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: settings.autoCheckQuestions,
                          onChanged: (value) {
                            settings.autoCheckQuestions = value!;
                            SettingsManager.save(settings);
                          },
                          splashRadius: 15,
                        ),
                      ),
                    ),
                    SettingEntry(
                      label: "Animazioni:",
                      tooltip:
                          "Se selezionato, abilita le animazioni (voto del quiz, stella, ...).",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: settings.animations,
                          onChanged: (value) {
                            settings.animations = value!;
                            SettingsManager.save(settings);
                          },
                          splashRadius: 15,
                        ),
                      ),
                    ),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Alert conferma:",
                        tooltip:
                            "Se selezionata, mostra degli alert di conferma.",
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            tristate: true,
                            value: settings.confirmationAlert,
                            onChanged: (value) {
                              settings.confirmationAlert = value;
                              SettingsManager.save(settings);
                            },
                            splashRadius: 15,
                          ),
                        ),
                      ),

                    SettingEntry(
                      label: "Nascondi risposte corrette:",
                      tooltip:
                          "Se selezionata, nasconde le risposte corrette nella lista delle domande.",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: settings.hideCorrectAnswersInEditMode,
                          onChanged: (value) {
                            settings.hideCorrectAnswersInEditMode = value!;
                            SettingsManager.save(settings);
                          },
                          splashRadius: 15,
                        ),
                      ),
                    ),

                    // TODO some:
                    //     - end quiz when there are answers not given
                    //     - new version/new questions
                    if (kDebugMode)
                      SettingEntry(
                        label: "GitHub token:",
                        tooltip:
                            "GitHub API token per poter fare richieste alla repository con rate limit incrementato."
                            " Le chiamate alla repository vengono effettuate ad esempio per controllare se ci sono aggiornamenti dell'app o delle domande.",
                        child: TextFormField(
                          decoration: InputDecoration(
                            hint: Text("token", textAlign: TextAlign.center),
                          ),
                          textAlign: TextAlign.center,
                          // TODO: pattern
                        ),
                      ),

                    SizedBox(height: 20.0),
                    Separator(text: "Quiz"),
                    SettingEntry(
                      label: "Voto prova scritta:",
                      tooltip:
                          "Permette di impostare il voto della prova scritta. Se impostato, il calcolo del voto dei quiz sarà più accurato.",
                      child: TextFormField(
                        controller: writtenGradeController,
                        decoration: InputDecoration(
                          hint: Text("[0, 32]", textAlign: TextAlign.center),
                        ),
                        maxLength: 2,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          const _MaxValueInputFormatter(32),
                        ],
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }

                          final int? grade = int.tryParse(value);

                          if (!_isGradeValid(grade)) {
                            return "Il voto dev'essere compreso tra 0 e 32.";
                          }

                          return null;
                        },
                        // TODO: fix this
                        // onFieldSubmitted: (newValue) {
                        //   settings.writtenGrade = int.tryParse(newValue);
                        //   SettingsManager.save(settings);
                        // },
                        onChanged: (value) {
                          settings.writtenGrade = int.tryParse(
                            writtenGradeController.text,
                          );
                          SettingsManager.save(settings);
                        },
                      ),
                    ),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Argomenti interi:",
                        tooltip:
                            "Se selezionata, come pool del quiz utilizza tutte le domande di ciascun argomento selezionato."
                            " È particolarmente utile quando si vogliono ripassare solamente certi argomenti.",
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: settings.fullTopics,
                            onChanged: (value) {
                              settings.fullTopics = value!;
                              SettingsManager.save(settings);
                            },
                            splashRadius: 15,
                          ),
                        ),
                      ),

                    SettingEntry(
                      key: _quizQuestionsKey,
                      label: "Domande quiz:",
                      tooltip: "Numero di domande presenti in ciascun quiz.",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8.0,
                        children: [
                          _stepperButton(
                            Icons.remove,
                            () => _setQuizQuestions(settings.quizQuestions - 1),
                          ),
                          SizedBox(
                            width: _numberFieldWidth(),
                            child: TextFormField(
                              controller: quizQuestionsController,
                              style: _numberFieldStyle,
                              maxLength: 3,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: _numberFieldPadding,
                                  vertical: 12.0,
                                ),
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                              ),
                              onChanged: (value) {
                                final int? parsed = int.tryParse(value);
                                if (parsed == null) {
                                  return;
                                }
                                settings.quizQuestions = parsed.clamp(
                                  _minQuizQuestions,
                                  _maxQuizQuestions,
                                );
                                SettingsManager.save(settings);
                              },
                              onFieldSubmitted: (value) => _setQuizQuestions(
                                int.tryParse(value) ?? settings.quizQuestions,
                              ),
                            ),
                          ),
                          _stepperButton(
                            Icons.add,
                            () => _setQuizQuestions(settings.quizQuestions + 1),
                          ),
                        ],
                      ),
                    ),

                    SettingEntry(
                      key: _quizTimeKey,
                      label: "Timer (minuti):",
                      tooltip:
                          "Numero di minuti a disposizione per completare il quiz.",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8.0,
                        children: [
                          _stepperButton(
                            Icons.remove,
                            () => _setQuizTime(settings.quizTime - 1),
                          ),
                          SizedBox(
                            width: _numberFieldWidth(),
                            child: TextFormField(
                              controller: quizTimeController,
                              style: _numberFieldStyle,
                              maxLength: 3,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: _numberFieldPadding,
                                  vertical: 12.0,
                                ),
                                counterStyle: TextStyle(
                                  height: double.minPositive,
                                ),
                                counterText: "",
                              ),
                              onChanged: (value) {
                                final int? parsed = int.tryParse(value);
                                if (parsed == null) {
                                  return;
                                }
                                settings.quizTime = parsed.clamp(
                                  _minQuizTime,
                                  _maxQuizTime,
                                );
                                SettingsManager.save(settings);
                              },
                              onFieldSubmitted: (value) => _setQuizTime(
                                int.tryParse(value) ?? settings.quizTime,
                              ),
                            ),
                          ),
                          _stepperButton(
                            Icons.add,
                            () => _setQuizTime(settings.quizTime + 1),
                          ),
                        ],
                      ),
                    ),
                    SettingEntry(
                      label: "Mescola risposte:",
                      tooltip:
                          "Se selezionata, mescola l'ordine delle risposte dei quiz."
                          " Questa opzione è utile per evitare di imparere l'ordine delle risposte nelle domande.",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: settings.shuffleAnswers,
                          onChanged: (value) {
                            settings.shuffleAnswers = value!;
                            SettingsManager.save(settings);
                          },
                          splashRadius: 15,
                        ),
                      ),
                    ),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Termina quiz allo scadere del tempo:",
                        tooltip:
                            "Se selezionata, termina il quiz allo scadere del tempo.",
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: settings.exceedTimeout,
                            onChanged: (value) {
                              settings.exceedTimeout = value!;
                              SettingsManager.save(settings);
                            },
                            splashRadius: 15,
                          ),
                        ),
                      ),

                    SizedBox(height: 20.0),
                    Separator(text: "Accessibilità"),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Layout per mancini:",
                        enabled: false,
                        tooltip:
                            "Se selezionata, imposta il layout dell'applicazione per facilitarne l'utilizzo ai mancini.",
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: settings.leftHandedLayout,
                            onChanged: (value) {
                              settings.leftHandedLayout = value!;
                              SettingsManager.save(settings);
                            },
                            splashRadius: 15,
                          ),
                        ),
                      ),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Tema per daltonici:",
                        enabled: false,
                        tooltip:
                            "Se selezionata, imposta il layout dell'applicazione per facilitarne l'utilizzo anche per le persone affette da daltonismo.",
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: false,
                            onChanged: null,
                            splashRadius: 15,
                          ),
                        ),
                      ),
                    SizedBox(height: 100),
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
                IconButton.filled(
                  onPressed: _confirmRestoreDefaults,
                  iconSize: 45,
                  icon: Icon(Icons.refresh, size: 40.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
