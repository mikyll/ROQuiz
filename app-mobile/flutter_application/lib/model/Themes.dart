import 'package:flutter/material.dart';
import 'package:roquiz/model/palette.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider(bool darkThemeOn) {
    themeMode = darkThemeOn ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool darkThemeOn) async {
    themeMode = darkThemeOn ? ThemeMode.dark : ThemeMode.light;

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

  static final themeLight = ThemeData(
    colorSchemeSeed: Colors.indigo[400],
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
        color: Color.fromARGB(255, 77, 86, 175),
        shadowColor: Colors.black,
        elevation: 3.0),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          iconColor: MaterialStateProperty.all<Color>(Colors.white)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        splashFactory: InkSplash.splashFactory,
        overlayColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 91, 99, 181)),
        foregroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color.fromARGB(150, 255, 255, 255);
            } else {
              return const Color.fromARGB(255, 255, 255, 255);
            }
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color.fromARGB(150, 77, 86, 175);
            } else {
              return const Color.fromARGB(255, 77, 86, 175);
            }
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 255, 255)),
        fillColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return const Color.fromARGB(255, 77, 86, 175);
            } else {
              return const Color.fromARGB(255, 227, 225, 236);
            }
          },
        ),
        side: BorderSide(
          width: 1.3,
          color: Colors.grey[700]!,
        )),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 77, 86, 175)),
    ),
  );

  static final themeDark = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.indigo[100],
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
        color: Color.fromARGB(255, 35, 35, 35),
        shadowColor: Colors.black,
        elevation: 3.0),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      splashFactory: InkSplash.splashFactory,
      overlayColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 91, 99, 181)),
      foregroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const Color.fromARGB(150, 12, 40, 120);
          } else {
            return const Color.fromARGB(255, 12, 40, 120);
          }
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const Color.fromARGB(50, 182, 196, 255);
          } else {
            return const Color.fromARGB(255, 182, 196, 255);
          }
        },
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    )),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 12, 40, 120)),
      fillColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return const Color.fromARGB(255, 182, 196, 255);
          } else {
            return const Color.fromARGB(100, 182, 196, 255);
          }
        },
      ),
      side: const BorderSide(
        color: Color.fromARGB(100, 182, 196, 255),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 182, 196, 255)),
      trackColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(100, 182, 196, 255)),
    ),
  );

  /*static final themeOriginal = ThemeData();

  static final themeLight2 = ThemeData(
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

  static final themeDark2 = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.blue,
  );*/
}
