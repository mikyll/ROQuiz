import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  // SharedPreferences.getInstance().then((prefs) {
  //   // // TODO
  //   // var isDarkTheme =
  //   //     prefs.getBool("darkTheme") ?? false; // Settings.DEFAULT_DARK_THEME;
  //   // //isDarkTheme = true;
  //   // prefs.setBool("showStarMessage", true);

    
  // });

  bool isDarkTheme = false;

    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: ROQuizApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
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
        home: ViewMenu(),
      );
    });
  }
}
