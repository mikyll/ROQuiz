import 'package:flutter/material.dart';

class AnimatedStarTheme extends ThemeExtension<AnimatedStarTheme> {
  const AnimatedStarTheme({
    required this.backgroundColor,
    required this.starColor,
  });

  final Color backgroundColor;
  final Color starColor;

  @override
  AnimatedStarTheme copyWith({Color? backgroundColor, Color? starColor}) {
    return AnimatedStarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      starColor: starColor ?? this.starColor,
    );
  }

  @override
  AnimatedStarTheme lerp(AnimatedStarTheme? other, double t) {
    if (other is! AnimatedStarTheme) {
      return this;
    }
    return AnimatedStarTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      starColor: Color.lerp(starColor, other.starColor, t)!,
    );
  }
}

class SearchBarTheme extends ThemeExtension<SearchBarTheme> {
  const SearchBarTheme({
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
  SearchBarTheme copyWith({
    Color? lensIconColor,
    Color? lensIconOpenColor,
    Color? lensIconOverlayColor,
    Color? backgroundColor,
    Color? textColor,
    Color? labelTextColor,
    Color? crossIconColor,
  }) {
    return SearchBarTheme(
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
  SearchBarTheme lerp(SearchBarTheme? other, double t) {
    if (other is! SearchBarTheme) {
      return this;
    }
    return SearchBarTheme(
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

class QuestionWidgetTheme extends ThemeExtension<QuestionWidgetTheme> {
  const QuestionWidgetTheme({
    required this.defaultAnswerColor,
    required this.selectedAnswerColor,
    required this.correctAnswerColor,
    required this.correctNotSelectedAnswerColor,
    required this.wrongAnswerColor,
    required this.backgroundQuizColor,
    required this.textColor,
  });

  final Color defaultAnswerColor;
  final Color selectedAnswerColor;
  final Color correctAnswerColor;
  final Color correctNotSelectedAnswerColor;
  final Color wrongAnswerColor;
  final Color backgroundQuizColor;
  final Color textColor;

  @override
  QuestionWidgetTheme copyWith({
    Color? defaultAnswerColor,
    Color? selectedAnswerColor,
    Color? correctAnswerColor,
    Color? correctNotSelectedAnswerColor,
    Color? wrongAnswerColor,
    Color? backgroundQuizColor,
    Color? textColor,
  }) {
    return QuestionWidgetTheme(
      defaultAnswerColor: defaultAnswerColor ?? this.defaultAnswerColor,
      selectedAnswerColor: selectedAnswerColor ?? this.selectedAnswerColor,
      correctAnswerColor: correctAnswerColor ?? this.correctAnswerColor,
      correctNotSelectedAnswerColor:
          correctNotSelectedAnswerColor ?? this.correctNotSelectedAnswerColor,
      wrongAnswerColor: wrongAnswerColor ?? this.wrongAnswerColor,
      backgroundQuizColor: backgroundQuizColor ?? this.backgroundQuizColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  QuestionWidgetTheme lerp(QuestionWidgetTheme? other, double t) {
    if (other is! QuestionWidgetTheme) {
      return this;
    }
    return QuestionWidgetTheme(
      defaultAnswerColor: Color.lerp(
        defaultAnswerColor,
        other.defaultAnswerColor,
        t,
      )!,
      selectedAnswerColor: Color.lerp(
        selectedAnswerColor,
        other.selectedAnswerColor,
        t,
      )!,
      correctAnswerColor: Color.lerp(
        correctAnswerColor,
        other.correctAnswerColor,
        t,
      )!,
      correctNotSelectedAnswerColor: Color.lerp(
        correctNotSelectedAnswerColor,
        other.correctNotSelectedAnswerColor,
        t,
      )!,
      wrongAnswerColor: Color.lerp(
        wrongAnswerColor,
        other.wrongAnswerColor,
        t,
      )!,
      backgroundQuizColor: Color.lerp(
        backgroundQuizColor,
        other.backgroundQuizColor,
        t,
      )!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
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
