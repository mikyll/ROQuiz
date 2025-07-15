import 'package:flutter/material.dart' hide SearchBarTheme;
import 'package:roquiz/model/style/palettes.dart';

class Themes {
  static final themeLight = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo[400],
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      color: Color.fromARGB(255, 77, 86, 175),
      shadowColor: Colors.black,
      elevation: 3.0,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(FOREGROUND_COLOR_LIGHT),
        backgroundColor: WidgetStatePropertyAll(BACKGROUND_COLOR_LIGHT),
        splashFactory: InkSplash.splashFactory,
        overlayColor: WidgetStatePropertyAll(OVERLAY_COLOR_LIGHT),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        splashFactory: InkSplash.splashFactory,
        overlayColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 91, 99, 181),
        ),
        textStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          return TextStyle(color: Colors.black, inherit: false);
        }),
        foregroundColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return const Color.fromARGB(150, 255, 255, 255);
          } else {
            return const Color.fromARGB(255, 255, 255, 255);
          }
        }),
        backgroundColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return const Color.fromARGB(150, 77, 86, 175);
          } else {
            return const Color(0xff515b92);
          }
        }),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        iconColor: WidgetStatePropertyAll(FOREGROUND_COLOR_LIGHT),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(
        const Color.fromARGB(255, 255, 255, 255),
      ),
      side: BorderSide(width: 1.3, color: Colors.grey[700]!),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(
        const Color.fromARGB(255, 77, 86, 175),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      const StarButtonTheme(
        backgroundColor: Color(0xff515b92),
        starColor: Color(0xffffeb3b),
      ),
      const QuestionWidgetTheme(
        defaultAnswerColor: Color(0x333f51b5),
        selectedAnswerColor: Color(0x7f3f51b5),
        correctAnswerColor: Color(0x7f2aff31),
        correctNotSelectedAnswerColor: Color(0xcc1b5e20),
        wrongAnswerColor: Color(0xccff1100),
        backgroundQuizColor: Color(0x1900bbd4),
        textColor: Color(0xff000000),
      ),
      const SearchBarTheme(
        lensIconColor: Color(0xffffffff),
        lensIconOpenColor: Color(0xff9e9e9e),
        lensIconOverlayColor: Color(0x7f5b63b5),
        backgroundColor: Color(0xffffffff),
        textColor: Color(0xff000000),
        labelTextColor: Color(0xff5B5B5B),
        crossIconColor: Color(0xffffffff),
      ),
    ],
  );

  static final themeDark = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo[100],
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      color: Color.fromARGB(255, 35, 35, 35),
      shadowColor: Colors.black,
      elevation: 3.0,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(FOREGROUND_COLOR_DARK),
        backgroundColor: WidgetStatePropertyAll(BACKGROUND_COLOR_DARK),
        splashFactory: InkSplash.splashFactory,
        overlayColor: WidgetStatePropertyAll(OVERLAY_COLOR_DARK),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          return TextStyle(color: Colors.black, inherit: false);
        }),
        splashFactory: InkSplash.splashFactory,
        overlayColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 91, 99, 181),
        ),
        foregroundColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return const Color.fromARGB(149, 17, 28, 59);
          } else {
            return const Color.fromARGB(255, 12, 40, 120);
          }
        }),
        backgroundColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return const Color.fromARGB(50, 182, 196, 255);
          } else {
            return const Color.fromARGB(255, 182, 196, 255);
          }
        }),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        iconColor: WidgetStatePropertyAll(FOREGROUND_COLOR_DARK),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color.fromARGB(255, 150, 150, 150); // Disabled color
        }
        return const Color.fromARGB(255, 12, 40, 120); // Enabled color
      }),
      side: const BorderSide(color: Color.fromARGB(100, 182, 196, 255)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(
        const Color.fromARGB(255, 182, 196, 255),
      ),
      trackColor: WidgetStatePropertyAll(
        const Color.fromARGB(100, 182, 196, 255),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      const StarButtonTheme(
        backgroundColor: Color(0xffb7c4ff),
        starColor: Color(0xffb71c1c),
      ),
      const QuestionWidgetTheme(
        defaultAnswerColor: Color(0x333f51b5),
        selectedAnswerColor: Color(0x7f3f51b5),
        correctAnswerColor: Color(0x7f2aff31),
        correctNotSelectedAnswerColor: Color(0xcc1b5e20),
        wrongAnswerColor: Color(0xccff1100),
        backgroundQuizColor: Color(0x1900bbd4),
        textColor: Color(0xffffffff),
      ),
      const SearchBarTheme(
        lensIconColor: Color(0xffffffff),
        lensIconOpenColor: Color(0xff9e9e9e),
        lensIconOverlayColor: Color(0x7fb7c4ff),
        backgroundColor: Color(0xff000000),
        textColor: Color(0xffffffff),
        labelTextColor: Color(0xff5B5B5B),
        crossIconColor: Color(0xffffffff),
      ),
    ],
  );
}
