import 'package:flutter/material.dart';
import 'package:roquiz/widget/separator.dart';
import 'package:roquiz/widget/setting_entry.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({super.key});

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onPopInvoked: (_) {
      //   // todo
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
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700.0),
              child: Form(
                // TODO: key
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  controller: _scrollController,
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    Separator(text: "Generale"),
                    SettingEntry(
                      label: "Lingua:",
                      child: DropdownButtonFormField(
                        value: "Italiano",
                        items: ["Italiano", "English"]
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                        onChanged: (_) {},
                      ),
                    ),
                    SettingEntry(
                      label: "Controllo release app:",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(value: false, onChanged: (_) {}),
                      ),
                    ),
                    SettingEntry(
                      label: "Controllo nuove domande:",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(value: false, onChanged: (_) {}),
                      ),
                    ),
                    SettingEntry(
                      label: "Animazioni:",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(value: false, onChanged: (_) {}),
                      ),
                    ),
                    SettingEntry(
                      label: "Alert conferma:",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          tristate: true,
                          value: null,
                          onChanged: (_) {},
                        ),
                      ),
                    ),

                    //   some:
                    //     - end quiz when there are answers not given
                    //     - new version/new questions
                    SettingEntry(
                      label: "Tema scuro:",
                      child: Switch(value: false, onChanged: (_) {}),
                    ),
                    SizedBox(height: 20.0),
                    Separator(text: "Quiz"),
                    SettingEntry(
                      label: "Quiz su argomenti:",
                      child: Switch(value: false, onChanged: (_) {}),
                    ),
                    SettingEntry(
                      label: "Pool quiz:",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          Text("  __  "),
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
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          Text("  __  "),
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
                        child: Checkbox(value: true, onChanged: (_) {}),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Separator(text: "Accessibilità"),
                    SettingEntry(
                      label: "Layout per mancini:",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(value: false, onChanged: (_) {}),
                      ),
                    ),
                    SettingEntry(
                      label: "Tema daltonici:",
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(value: false, onChanged: (_) {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
