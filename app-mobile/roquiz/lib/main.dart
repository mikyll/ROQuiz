import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:roquiz/model/themes.dart';
import 'package:roquiz/view/view_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Settings _settings = await Settings.loadFromSharedPreferences();
  // print(_settings.toString());

  // TODO
  // if (getPlatformType() == PlatformType.DESKTOP) {
  //   DesktopWindow.setWindowSize(const Size(800, 800));
  // }

  SharedPreferences.getInstance().then((prefs) {
    // // TODO
    // var isDarkTheme =
    //     prefs.getBool("darkTheme") ?? false; // Settings.DEFAULT_DARK_THEME;
    // //isDarkTheme = true;
    // prefs.setBool("showStarMessage", true);

    return runApp(ROQuizApp());
  });
}

class ROQuizApp extends StatelessWidget {
  ROQuizApp({super.key});

  final ValueNotifier<ThemeMode> _notifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      builder: (context, mode, _) {
        return MaterialApp(
          title: "ROQuiz", // Settings.APP_TITLE,
          themeMode: mode,
          theme: MyThemes.themeLight,
          darkTheme: MyThemes.themeDark,
          home: ViewMenu(themeNotifier: _notifier, themeMode: mode),
        );
      },
      valueListenable: _notifier,
    );
  }
}
