import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/setting_type.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/widget/settings/setting_checkbox.dart';
import 'package:roquiz/widget/settings/setting_checkbox_button.dart';
import 'package:roquiz/widget/settings/setting_spinner.dart';
import 'package:roquiz/widget/settings/setting_switch.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({super.key});

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  final ScrollController _scrollController = ScrollController();
  Settings _settings = Settings.fromDefault();

  void _goBack(context, {bool showDialog = false}) {
    bool shouldPop = true;

    if (showDialog) {
      // TODO
      // shouldPop = await dialog ?? false;
    }

    if (shouldPop) {
      Navigator.pop(context);
    }
  }

  void _initSettings() {
    Settings.loadFromSharedPreferences().then((settingsPref) {
      setState(() {
        _settings = settingsPref;
      });
    });
  }

  List<Widget> _buildSettingEntriesList() {
    List<Widget> widgets = [];

    // TEST
    Settings s = Settings.fromDefault();

    // TODO
    for (String key in s.getKeys()) {
      Widget w;

      SettingType type = s.getType(key);
      String label = s.getLabel(key);
      String description = s.getDescription(key);

      switch (type) {
        case SettingType.toggleCheckbox:
          w = SettingCheckboxWidget(
            label: label,
            description: description,
            onChanged: (_) {},
          );
          break;

        case SettingType.toggleSwitch:
          w = SettingSwitchWidget(
            label: label,
            description: description,
            onChanged: (_) {},
          );
          break;

        case SettingType.spinner:
          w = SettingSpinnerWidget(
            label: label,
            description: description,
            onChanged: (_) {},
          );
          break;

        case SettingType.toggleCheckboxAndButton:
          w = SettingCheckboxAndButtonWidget(
            label: label,
            description: description,
            onChanged: (_) {},
            onClick: () {},
          );
          break;
        default:
          w = Text("Error");
      }
      widgets.add(w);
    }

    // widgets.addAll(
    //   [
    //     Switch(
    //       value: themeProvider.themeMode == ThemeMode.dark,
    //       onChanged: (_) {
    //         themeProvider.setTheme(ThemeMode.system);
    //       },
    //     ),
    //     Switch(
    //       value: themeProvider.themeMode == ThemeMode.dark,
    //       onChanged: (isDarkMode) {
    //         themeProvider.toggleTheme();
    //       },
    //     ),
    //   ],
    // );

    return widgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool canPop = false;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _goBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Impostazioni"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: ListView(
              padding: const EdgeInsets.all(15.0),
              controller: _scrollController,
              shrinkWrap: true,
              primary: false,
              children: _buildSettingEntriesList()),
        ),
      ),
    );
  }
}
