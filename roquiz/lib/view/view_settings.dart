import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/widget/separator.dart';
import 'package:roquiz/widget/setting_entry.dart';

class ViewSettings extends StatelessWidget {
  final int maxQuizPool;

  const ViewSettings({super.key, required this.maxQuizPool});

  bool _isGradeValid(int? grade) {
    return grade != null && grade >= 0 && grade <= 32;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    // TODO
    final TextEditingController writtenGradeController =
        TextEditingController();

    final settings = Provider.of<Settings>(context);

    return PopScope(
      canPop: true,
      // onPopInvokedWithResult: (didPop, result) {

      // },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Impostazioni"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actionsPadding: EdgeInsets.only(right: 8.0),
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
              constraints: BoxConstraints(maxWidth: 700.0),
              child: Form(
                // TODO: key
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  controller: scrollController,
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    SizedBox(height: 10),
                    Separator(text: "Generale"),
                    SettingEntry(
                      label: "Lingua:",
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
                      label: "Controllo release app:",
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
                    SettingEntry(
                      label: "Alert conferma:",
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

                    //   some:
                    //     - end quiz when there are answers not given
                    //     - new version/new questions
                    SettingEntry(
                      label: "Tema scuro:",
                      child: Switch(
                        value: settings.themeDark,
                        onChanged: (value) {
                          // TODO: why it's slow?
                          settings.themeDark = value;
                          SettingsManager.save(settings);
                        },
                      ),
                    ),
                    SettingEntry(
                      label: "GitHub token:",
                      child: TextFormField(
                        decoration: InputDecoration(hint: Text("token")),
                        // TODO: pattern
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Separator(text: "Quiz"),
                    SettingEntry(
                      label: "Voto scritto:",
                      child: TextFormField(
                        initialValue: settings.writtenGrade?.toString() ?? "",
                        decoration: InputDecoration(hint: Text("es: 32")),
                        maxLength: 2,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                        onFieldSubmitted: (newValue) {
                          settings.writtenGrade = int.tryParse(newValue!);
                          SettingsManager.save(settings);
                        },
                        // onChanged: (value) {
                        //   print(writtenGradeController.text);
                        //   settings.writtenGrade = int.tryParse(
                        //     writtenGradeController.text,
                        //   );
                        //   SettingsManager.save(settings);
                        // },
                      ),
                    ),
                    SettingEntry(
                      label: "Argomenti interi:",
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
                      label: "Domande quiz:",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10.0,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          SizedBox(
                            width: 40.0,
                            child: TextFormField(
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
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                    SettingEntry(
                      label: "Timer (minuti):",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10.0,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          SizedBox(
                            width: 40.0,
                            child: TextFormField(
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
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                    SettingEntry(
                      label: "Mescola risposte:",
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

                    SettingEntry(
                      label: "Termina quiz allo scadere del tempo:",
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
                    SettingEntry(
                      label: "Layout per mancini:",
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
                    SettingEntry(
                      label: "Tema per daltonici:",
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: IconButton.filled(
          onPressed: () {
            // TODO
          },
          iconSize: 45,
          icon: Icon(Icons.refresh, size: 40.0),
        ),
      ),
    );
  }
}
