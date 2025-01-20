import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:roquiz/model/themes.dart';
import 'package:roquiz/persistence/settings.dart';
import 'package:roquiz/view/view_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO
  // if (getPlatformType() == PlatformType.DESKTOP) {
  //   DesktopWindow.setWindowSize(const Size(800, 800));
  // }

  SharedPreferences.getInstance().then((prefs) {
    // TODO
    var isDarkTheme = prefs.getBool("darkTheme") ?? Settings.DEFAULT_DARK_THEME;
    //isDarkTheme = true;
    prefs.setBool("showStarMessage", true);

    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: const ROQuizApp(),
        create: (_) => ThemeProvider(isDarkTheme),
      ),
    );
  });
}

class ROQuizApp extends StatelessWidget {
  const ROQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return MaterialApp(
        title: Settings.APP_TITLE,
        themeMode: value.themeMode,
        theme: MyThemes.themeLight,
        darkTheme: MyThemes.themeDark,
        home: const ViewMenu(),
      );
    });
  }
}
