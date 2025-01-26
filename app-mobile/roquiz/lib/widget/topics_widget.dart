import 'package:flutter/material.dart';

class TopicsInfoWidget extends StatelessWidget {
  const TopicsInfoWidget({
    Key? key,
    this.onTap,
    this.textSize = 18.0,
    this.textWeight = FontWeight.normal,
    required this.text,
    required this.value,
    required this.color,
  }) : super(key: key);

  final String text;
  final int value;
  final double textSize;
  final FontWeight textWeight;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 2.0),
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
}

class TopicWidget extends StatelessWidget {
  const TopicWidget({
    Key? key,
    required this.checkBoxValue,
    required this.text,
    required this.questionNum,
    required this.textSize,
    this.onTap,
    this.onPressedButton,
    this.onCheckBoxChanged,
    this.lightTextColor,
    this.darkTextColor,
    this.disabled = false,
  }) : super(key: key);

  final Function()? onTap;
  final Function()? onPressedButton;
  final bool checkBoxValue;
  final Function(bool?)? onCheckBoxChanged;
  final String text;
  final int questionNum;
  final double textSize;
  final Color? lightTextColor;
  final Color? darkTextColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: InkWell(
              splashColor: disabled ? Colors.transparent : null,
              highlightColor: disabled ? Colors.transparent : null,
              hoverColor: disabled ? Colors.transparent : null,
              enableFeedback: true,
              onTap: onTap != null ? () => onTap!() : null,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: checkBoxValue,
                          onChanged: onCheckBoxChanged != null
                              ? (value) => onCheckBoxChanged!(value)
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: textSize,
                          // color: themeProvider.isDarkMode
                          //     ? (darkTextColor
                          //             ?.withOpacity(disabled ? 0.3 : 1.0) ??
                          //         Colors.white
                          //             .withOpacity(disabled ? 0.3 : 1.0))
                          //     : (lightTextColor
                          //             ?.withOpacity(disabled ? 0.3 : 1.0) ??
                          //         Colors.black
                          //             .withOpacity(disabled ? 0.3 : 1.0)),
                        ),
                      ),
                    ),
                    Text(
                      "($questionNum)",
                      style: TextStyle(
                        fontSize: textSize,
                        // color: themeProvider.isDarkMode
                        //     ? (darkTextColor
                        //             ?.withOpacity(disabled ? 0.3 : 1.0) ??
                        //         Colors.white.withOpacity(disabled ? 0.3 : 1.0))
                        //     : (lightTextColor
                        //             ?.withOpacity(disabled ? 0.3 : 1.0) ??
                        //         Colors.black.withOpacity(disabled ? 0.3 : 1.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              // color: themeProvider.isDarkMode
              //     ? (darkTextColor?.withOpacity(1.0) ??
              //         Colors.white.withOpacity(1.0))
              //     : (lightTextColor?.withOpacity(1.0) ??
              //         Colors.black.withOpacity(1.0)),
            ),
            // hoverColor: themeProvider.isDarkMode
            //     ? MyThemes.darkIconButtonPalette.hoverColor
            //     : MyThemes.lightIconButtonPalette.hoverColor,
            onPressed:
                onPressedButton != null ? () => onPressedButton!() : null,
          ),
        ],
      ),
    );
  }
}
