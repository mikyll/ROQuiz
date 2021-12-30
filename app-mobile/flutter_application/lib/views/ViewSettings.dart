import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/widget/change_theme_button.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ViewSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? 'DarkTheme'
        : 'LightTheme';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Impostazioni"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          ChangeThemeButtonWidget(),
        ],
      ),
      body: Center(
        child: Text(
          'Hello $text!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
