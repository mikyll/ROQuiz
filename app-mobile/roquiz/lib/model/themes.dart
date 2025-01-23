import 'package:flutter/material.dart';
import 'package:roquiz/model/palette.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider(bool isDarkTheme) {
    _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode darkTheme) async {
    _themeMode = darkTheme;

    notifyListeners();
  }

  void toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();
  }
}

class MyThemes {
  static final IconButtonPalette lightIconButtonPalette = IconButtonPalette(
    color: const Color.fromARGB(255, 77, 86, 175),
    highlightColor: const Color.fromARGB(255, 130, 136, 199),
    hoverColor: const Color.fromARGB(255, 91, 99, 181),
    iconColor: const Color.fromARGB(255, 255, 255, 255),
    splashColor: const Color.fromARGB(255, 160, 164, 212),
    overlayColor: const Color.fromARGB(255, 91, 99, 181),
  );

  static final IconButtonPalette darkIconButtonPalette = IconButtonPalette(
    color: const Color.fromARGB(255, 182, 196, 255),
    highlightColor: const Color.fromARGB(255, 132, 150, 215),
    hoverColor: const Color.fromARGB(255, 91, 99, 181),
    iconColor: const Color.fromARGB(255, 12, 40, 120),
    splashColor: const Color.fromARGB(255, 103, 124, 193),
    overlayColor: const Color.fromARGB(255, 91, 99, 181),
  );

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
        iconColor: WidgetStatePropertyAll(Colors.white),
        splashFactory: InkSplash.splashFactory,
        overlayColor:
            WidgetStatePropertyAll(const Color.fromARGB(255, 91, 99, 181)),
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
        foregroundColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color.fromARGB(150, 255, 255, 255);
            } else {
              return const Color.fromARGB(255, 255, 255, 255);
            }
          },
        ),
        backgroundColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color.fromARGB(150, 77, 86, 175);
            } else {
              return const Color(0xff515b92);
            }
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
        checkColor:
            WidgetStatePropertyAll(const Color.fromARGB(255, 255, 255, 255)),
        fillColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
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
      thumbColor:
          WidgetStatePropertyAll(const Color.fromARGB(255, 77, 86, 175)),
    ),
    extensions: <ThemeExtension<dynamic>>[
      const ContainerColors(
        backgroundColor: Color(0xff515b92),
        starColor: Color(0xffffeb3b),
      ),
    ],
  );

  static final themeDark = ThemeData(
    colorSchemeSeed: Colors.indigo[100],
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
        color: Color.fromARGB(255, 35, 35, 35),
        shadowColor: Colors.black,
        elevation: 3.0),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.white),
        splashFactory: InkSplash.splashFactory,
        overlayColor:
            WidgetStatePropertyAll(const Color.fromARGB(255, 91, 99, 181)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateTextStyle.resolveWith(
          (Set<WidgetState> states) {
            return TextStyle(color: Colors.black, inherit: false);
          },
        ),
        splashFactory: InkSplash.splashFactory,
        overlayColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 91, 99, 181),
        ),
        foregroundColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color.fromARGB(149, 17, 28, 59);
            } else {
              return const Color.fromARGB(255, 12, 40, 120);
            }
          },
        ),
        backgroundColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color.fromARGB(50, 182, 196, 255);
            } else {
              return const Color.fromARGB(255, 182, 196, 255);
            }
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor:
          WidgetStatePropertyAll(const Color.fromARGB(255, 12, 40, 120)),
      fillColor: WidgetStateColor.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
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
      thumbColor:
          WidgetStatePropertyAll(const Color.fromARGB(255, 182, 196, 255)),
      trackColor:
          WidgetStatePropertyAll(const Color.fromARGB(100, 182, 196, 255)),
    ),
    extensions: <ThemeExtension<dynamic>>[
      const ContainerColors(
          backgroundColor: Color(0xffb7c4ff), starColor: Color(0xffb71c1c)),
    ],
  );
}
