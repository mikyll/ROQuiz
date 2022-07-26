import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/views/ViewMenu.dart';

import 'package:roquiz/widget/Themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: true);

          return MaterialApp(
            title: 'ROquiz',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.themeLight2,
            darkTheme: MyThemes.themeDark2,
            home: const ViewMenu(),
          );
        });
  }
}
