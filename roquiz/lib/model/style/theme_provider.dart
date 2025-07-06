import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider(bool isDarkTheme) {
    _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;
  bool isDarkTheme() => _themeMode == ThemeMode.dark;

  void setTheme(ThemeMode darkTheme) async {
    _themeMode = darkTheme;

    notifyListeners();
  }

  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    notifyListeners();
  }
}
