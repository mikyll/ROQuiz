import 'package:flutter/material.dart';

class BackButtonPalette extends ThemeExtension<BackButtonPalette> {
  // final Color iconColor;
  // final Color overlayColor;
  // final Color backgroundColor;
  // final double iconSize;

  @override
  ThemeExtension<BackButtonPalette> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<BackButtonPalette> lerp(
    covariant ThemeExtension<BackButtonPalette>? other,
    double t,
  ) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}

// TODO: small button on top of card
//class QuestionCardButton

class StarButtonPalette extends ThemeExtension<StarButtonPalette> {
  final Color backgroundColor;
  final Color starColor;

  const StarButtonPalette({
    required this.backgroundColor,
    required this.starColor,
  });

  @override
  StarButtonPalette copyWith({Color? backgroundColor, Color? starColor}) {
    return StarButtonPalette(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      starColor: starColor ?? this.starColor,
    );
  }

  @override
  StarButtonPalette lerp(StarButtonPalette? other, double t) {
    if (other is! StarButtonPalette) {
      return this;
    }
    return StarButtonPalette(
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

class CustomSearchBarPalette extends ThemeExtension<CustomSearchBarPalette> {
  const CustomSearchBarPalette({
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
  CustomSearchBarPalette copyWith({
    Color? lensIconColor,
    Color? lensIconOpenColor,
    Color? lensIconOverlayColor,
    Color? backgroundColor,
    Color? textColor,
    Color? labelTextColor,
    Color? crossIconColor,
  }) {
    return CustomSearchBarPalette(
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
  CustomSearchBarPalette lerp(CustomSearchBarPalette? other, double t) {
    if (other is! CustomSearchBarPalette) {
      return this;
    }
    return CustomSearchBarPalette(
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
const Color BACKGROUND_COLOR_LIGHT = Color(0xff4d57af);
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
