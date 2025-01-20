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

const LIGHT_BUTTON_COLOR = Color(0xff515b92);
const LIGHT_BUTTON_HOVER_COLOR = Color(0xff515b92);

const DARK_PRIMARY_COLOR = Color(0xffb7c4ff);

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
