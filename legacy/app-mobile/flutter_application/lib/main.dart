import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/PlatformType.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/views/ViewMenu.dart';

import 'package:roquiz/model/Themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desktop_window/desktop_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (getPlatformType() == PlatformType.DESKTOP) {
    DesktopWindow.setWindowSize(const Size(800, 800));
  }

  SharedPreferences.getInstance().then((prefs) {
    // Read from the SharedPreferences
    var isDarkTheme = prefs.getBool("darkTheme") ?? Settings.DEFAULT_DARK_THEME;

    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: const MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
