import 'package:flutter/material.dart';
import 'package:roquiz/model/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}

class MyThemes {
  static final IconButtonPalette lightIconButtonPalette = IconButtonPalette(
      color: const Color.fromARGB(255, 77, 86, 175),
      highlightColor: const Color.fromARGB(255, 130, 136, 199),
      hoverColor: const Color.fromARGB(255, 91, 99, 181),
      iconColor: const Color.fromARGB(255, 255, 255, 255),
      splashColor: const Color.fromARGB(255, 160, 164, 212));

  static final IconButtonPalette darkIconButtonPalette = IconButtonPalette(
      color: const Color.fromARGB(255, 182, 196, 255),
      highlightColor: const Color.fromARGB(255, 132, 150, 215),
      hoverColor: const Color.fromARGB(255, 169, 184, 244),
      iconColor: const Color.fromARGB(255, 12, 40, 120),
      splashColor: const Color.fromARGB(255, 103, 124, 193));

  static final themeLight2 = ThemeData(
    colorSchemeSeed: Colors.indigo[900],
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    )))),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255)),
      fillColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 77, 86, 175)),
    ),
  );

  static final themeDark2 = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.indigo[100],
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    )))),
    checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 12, 40, 120)),
        fillColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 182, 196, 255))),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 182, 196, 255)),
      trackColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(100, 182, 196, 255)),
    ),
  );

  static final themeOriginal = ThemeData();

  static final themeLight = ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        primaryContainer: Colors.cyan,
        secondaryContainer: Colors.cyan,
        brightness: Brightness.light,
        background: Color.fromARGB(255, 26, 35, 126),
        onBackground: Colors.black,
        error: Colors.red,
        primary: Colors.lightBlue,
        onPrimary: Colors.black,
        secondary: Colors.purple,
        onSecondary: Colors.indigo,
        onError: Colors.red,
        surface: Colors.orange,
        onSurface: Colors.orange,
      ),
      splashColor: Colors.blue,
      hoverColor: Colors.indigo,
      //scaffoldBackgroundColor: Colors.indigo[900],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)))),
      )
      //colorScheme: ColorScheme.dark(),
      );

  static final themeDark = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.blue,
  );
}
