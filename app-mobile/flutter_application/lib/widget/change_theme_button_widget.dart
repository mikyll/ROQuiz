import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/widget/Themes.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  ChangeThemeButtonWidget({Key? key, this.value}) : super(key: key);

  bool? value;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (v) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);

          value = themeProvider.isDarkMode;
          provider.toggleTheme(v);
        });
  }
}
