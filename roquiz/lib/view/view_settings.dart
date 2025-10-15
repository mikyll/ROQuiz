import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/separator.dart';
import 'package:roquiz/widget/setting_entry.dart';

class ViewSettings extends StatefulWidget {
  final int maxQuizPool;

  const ViewSettings({super.key, required this.maxQuizPool});

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  final ScrollController scrollController = ScrollController();
  // TODO
  final TextEditingController writtenGradeController = TextEditingController();

  bool _isGradeValid(int? grade) {
    return grade != null && grade >= 0 && grade <= 32;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);
    writtenGradeController.text = settings.writtenGrade?.toString() ?? "";

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
                // TODO: key
                key: GlobalKey<FormState>(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  controller: scrollController,
                  shrinkWrap: true,
                  primary: false,
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

                    if (kDebugMode)
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
                          print(writtenGradeController.text);
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

                    if (kDebugMode)
                      SettingEntry(
                        label: "Domande quiz:",
                        tooltip: "Numero di domande presenti in ciascun quiz.",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10.0,
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO
                              },
                              icon: Icon(Icons.remove),
                            ),
                            SizedBox(
                              width: 40.0,
                              child: TextFormField(
                                initialValue: "${settings.quizQuestions}",
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
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                ),
                                onFieldSubmitted: (newValue) {
                                  // TODO: validate
                                  settings.quizQuestions =
                                      int.tryParse(newValue) ?? 16;
                                  SettingsManager.save(settings);
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),

                    if (kDebugMode)
                      SettingEntry(
                        label: "Timer (minuti):",
                        tooltip:
                            "Numero di minuti a disposizione per completare il quiz.",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10.0,
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO
                              },
                              icon: Icon(Icons.remove),
                            ),
                            SizedBox(
                              width: 40.0,
                              child: TextFormField(
                                initialValue: "${settings.quizTime}",
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
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                ),
                                onFieldSubmitted: (newValue) {
                                  // TODO: validate
                                  settings.quizTime =
                                      int.tryParse(newValue) ?? 16;
                                  SettingsManager.save(settings);
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO
                              },
                              icon: Icon(Icons.add),
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
                  onPressed: () {
                    // TODO
                  },
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
