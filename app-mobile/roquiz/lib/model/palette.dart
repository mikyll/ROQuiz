import 'package:flutter/material.dart';

class ContainerColors extends ThemeExtension<ContainerColors> {
  const ContainerColors({
    required this.backgroundColor,
    required this.starColor,
  });

  final Color backgroundColor;
  final Color starColor;

  @override
  ContainerColors copyWith({Color? backgroundColor, Color? starColor}) {
    return ContainerColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      starColor: starColor ?? this.starColor,
    );
  }

  @override
  ContainerColors lerp(ContainerColors? other, double t) {
    if (other is! ContainerColors) {
      return this;
    }
    return ContainerColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      starColor: Color.lerp(starColor, other.starColor, t)!,
    );
  }
}

const Color BUTTON_COLOR_LIGHT = Color(0xff515b92);
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

  IconButtonPalette(
      {this.color,
      this.focusColor,
      this.highlightColor,
      this.hoverColor,
      this.iconColor,
      this.overlayColor,
      this.splashColor});
}
