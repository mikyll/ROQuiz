import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isDarkTheme = false;

  return runApp(ROQuizApp());
}

class ROQuizApp extends StatelessWidget {
  const ROQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          title: Settings.APP_TITLE,
          themeMode: value.themeMode,
          theme: MyThemes.themeLight,
          darkTheme: MyThemes.themeDark,
          home: ViewMenu(),
        );
      },
    );
  }
}
