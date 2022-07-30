import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/Themes.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (v) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);

          provider.toggleTheme(v);
        });
  }
}
