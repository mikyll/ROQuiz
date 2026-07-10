import 'dart:ui';

import 'package:flutter/material.dart';

class ClearButtonTheme extends ThemeExtension<ClearButtonTheme> {
  final Color iconColor;
  final Color overlayColor;
  final Color backgroundColor;
  final double iconSize;

  const ClearButtonTheme({
    required this.iconColor,
    this.overlayColor = Colors.transparent,
    this.backgroundColor = Colors.transparent,
    this.iconSize = 24.0,
  });

  @override
  ThemeExtension<ClearButtonTheme> copyWith({
    Color? iconColor,
    Color? overlayColor,
    Color? backgroundColor,
    double? iconSize,
  }) {
    return ClearButtonTheme(
      iconColor: iconColor ?? this.iconColor,
      overlayColor: overlayColor ?? this.overlayColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconSize: iconSize ?? this.iconSize,
    );
  }

  @override
  ThemeExtension<ClearButtonTheme> lerp(
    covariant ThemeExtension<ClearButtonTheme>? other,
    double t,
  ) {
    if (other is! ClearButtonTheme) {
      return this;
    }
    return ClearButtonTheme(
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
    );
  }
}

class BackButtonTheme extends ThemeExtension<BackButtonTheme> {
  final Color iconColor;
  final Color overlayColor;
  final Color backgroundColor;
  final double iconSize;

  const BackButtonTheme({
    this.iconColor = Colors.white,
    this.overlayColor = const Color(0x19ffffff),
    this.backgroundColor = const Color(0x00ffffff),
    this.iconSize = 24.0,
  });

  @override
  ThemeExtension<BackButtonTheme> copyWith({
    Color? iconColor,
    Color? overlayColor,
    Color? backgroundColor,
    double? iconSize,
  }) {
    return BackButtonTheme(
      iconColor: iconColor ?? this.iconColor,
      overlayColor: overlayColor ?? this.overlayColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconSize: iconSize ?? this.iconSize,
    );
  }

  @override
  ThemeExtension<BackButtonTheme> lerp(
    covariant ThemeExtension<BackButtonTheme>? other,
    double t,
  ) {
    if (other is! BackButtonTheme) {
      return this;
    }
    return BackButtonTheme(
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
    );
  }
}

// TODO: small button on top of card
//class QuestionCardButton

class StarButtonTheme extends ThemeExtension<StarButtonTheme> {
  final Color backgroundColor;
  final Color starColor;

  const StarButtonTheme({
    required this.backgroundColor,
    required this.starColor,
  });

  @override
  StarButtonTheme copyWith({Color? backgroundColor, Color? starColor}) {
    return StarButtonTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      starColor: starColor ?? this.starColor,
    );
  }

  @override
  StarButtonTheme lerp(StarButtonTheme? other, double t) {
    if (other is! StarButtonTheme) {
      return this;
    }
    return StarButtonTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      starColor: Color.lerp(starColor, other.starColor, t)!,
    );
  }
}

class QuestionCardPalette extends ThemeExtension<QuestionCardPalette> {
  final Color backgroundColor;
  final Color textColor;
  final Color selectedTextColor;

  const QuestionCardPalette({
    required this.backgroundColor,
    required this.textColor,
    required this.selectedTextColor,
  });

  @override
  ThemeExtension<QuestionCardPalette> copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? selectedTextColor,
  }) {
    return QuestionCardPalette(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
    );
  }

  @override
  ThemeExtension<QuestionCardPalette> lerp(
    covariant ThemeExtension<QuestionCardPalette>? other,
    double t,
  ) {
    if (other is! QuestionCardPalette) {
      return this;
    }
    return QuestionCardPalette(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      selectedTextColor: Color.lerp(
        selectedTextColor,
        other.selectedTextColor,
        t,
      )!,
    );
  }
}

class CustomSearchBarTheme extends ThemeExtension<CustomSearchBarTheme> {
  const CustomSearchBarTheme({
    required this.lensIconColor,
    required this.lensIconOpenColor,
    required this.lensIconOverlayColor,
    required this.backgroundColor,
    required this.textColor,
    required this.labelTextColor,
    required this.crossIconColor,
  });

  final Color lensIconColor;
  final Color lensIconOpenColor;
  final Color lensIconOverlayColor;
  final Color backgroundColor;
  final Color textColor;
  final Color labelTextColor;
  final Color crossIconColor;

  @override
  CustomSearchBarTheme copyWith({
    Color? lensIconColor,
    Color? lensIconOpenColor,
    Color? lensIconOverlayColor,
    Color? backgroundColor,
    Color? textColor,
    Color? labelTextColor,
    Color? crossIconColor,
  }) {
    return CustomSearchBarTheme(
      lensIconColor: lensIconColor ?? this.lensIconColor,
      lensIconOpenColor: lensIconOpenColor ?? this.lensIconOpenColor,
      lensIconOverlayColor: lensIconOverlayColor ?? this.lensIconOverlayColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      labelTextColor: labelTextColor ?? this.labelTextColor,
      crossIconColor: crossIconColor ?? this.crossIconColor,
    );
  }

  @override
  CustomSearchBarTheme lerp(CustomSearchBarTheme? other, double t) {
    if (other is! CustomSearchBarTheme) {
      return this;
    }
    return CustomSearchBarTheme(
      lensIconColor: Color.lerp(lensIconColor, other.lensIconColor, t)!,
      lensIconOpenColor: Color.lerp(
        lensIconOpenColor,
        other.lensIconOpenColor,
        t,
      )!,
      lensIconOverlayColor: Color.lerp(
        lensIconOverlayColor,
        other.lensIconOverlayColor,
        t,
      )!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      labelTextColor: Color.lerp(labelTextColor, other.labelTextColor, t)!,
      crossIconColor: Color.lerp(crossIconColor, other.crossIconColor, t)!,
    );
  }
}

const Color BUTTON_COLOR_LIGHT = Color.fromARGB(255, 7, 12, 39);
const Color BUTTON_HOVER_COLOR_LIGHT = Color(0xff515b92);

// Light
// Icon-button background: matches the ElevatedButton background (0xff515b92,
// also the StarButton colour) so icon buttons and elevated buttons — e.g. the
// quiz nav arrows in ViewQuiz — read as the same colour rather than two slightly
// different indigos.
const Color BACKGROUND_COLOR_LIGHT = Color(0xff515b92);
const Color FOREGROUND_COLOR_LIGHT = Color(0xffffffff);
const Color OVERLAY_COLOR_LIGHT = Color(0xff5b63b5);

// Dark
const Color BACKGROUND_COLOR_DARK = Color(0xffb7c4ff);
const Color FOREGROUND_COLOR_DARK = Color(0xff0c2978);
const Color OVERLAY_COLOR_DARK = Color(0xff5b63b5);

class LightContainerPalette {
  final Color backgroundColor = Color(0xff515b92);
}

class DarkContainerPalette {
  final Color backgroundColor = Color(0xffb7c4ff);
}

class IconButtonPalette {
  Color? color;
  Color? focusColor;
  Color? highlightColor;
  Color? hoverColor;
  Color? iconColor;
  Color? overlayColor;
  Color? splashColor;

  IconButtonPalette({
    this.color,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.iconColor,
    this.overlayColor,
    this.splashColor,
  });
}
