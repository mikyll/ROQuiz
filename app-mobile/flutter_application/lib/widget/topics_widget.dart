import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/widget/Themes.dart';

class TopicsInfoWidget extends StatelessWidget {
  const TopicsInfoWidget({
    Key? key,
    required this.text,
    this.textSize = 18.0,
    this.textWeight = FontWeight.normal,
    required this.value,
    required this.color,
  }) : super(key: key);

  final String text;
  final int value;
  final double textSize;
  final FontWeight textWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 2.0),
      child: Row(children: [
        Expanded(
          child: Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: textWeight,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$value",
              style: TextStyle(
                fontSize: textSize,
                fontWeight: textWeight,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class TopicWidget extends StatelessWidget {
  const TopicWidget({
    Key? key,
    required this.onTap,
    required this.checkBoxValue,
    required this.onCheckBoxChanged,
    required this.onPressedButton,
    required this.text,
    required this.questionNum,
    required this.textSize,
    this.lightTextColor,
    this.darkTextColor,
    this.disabled = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final VoidCallback onPressedButton;
  final bool checkBoxValue;
  final Function(bool?) onCheckBoxChanged;
  final String text;
  final int questionNum;
  final double textSize;
  final Color? lightTextColor;
  final Color? darkTextColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);

    return InkWell(
      splashColor: disabled ? Colors.transparent : null,
      highlightColor: disabled ? Colors.transparent : null,
      hoverColor: disabled ? Colors.transparent : null,
      enableFeedback: true,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: checkBoxValue,
            onChanged: onCheckBoxChanged,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: _themeProvider.isDarkMode
                    ? (darkTextColor?.withOpacity(disabled ? 0.3 : 1.0) ??
                        Colors.white.withOpacity(disabled ? 0.3 : 1.0))
                    : (lightTextColor?.withOpacity(disabled ? 0.3 : 1.0) ??
                        Colors.black.withOpacity(disabled ? 0.3 : 1.0)),
              ),
            ),
          ),
          Text(
            "($questionNum)",
            style: TextStyle(
              fontSize: textSize,
              color: _themeProvider.isDarkMode
                  ? (darkTextColor?.withOpacity(disabled ? 0.3 : 1.0) ??
                      Colors.white.withOpacity(disabled ? 0.3 : 1.0))
                  : (lightTextColor?.withOpacity(disabled ? 0.3 : 1.0) ??
                      Colors.black.withOpacity(disabled ? 0.3 : 1.0)),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
            onPressed: onPressedButton,
          ),
        ],
      ),
    );
  }
}
