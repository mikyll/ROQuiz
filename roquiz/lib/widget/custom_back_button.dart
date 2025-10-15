import 'package:flutter/material.dart';
import 'package:roquiz/model/style/theme_extensions.dart';

class CustomBackButton extends StatelessWidget {
  final Widget icon;
  final void Function()? onPressed;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.icon = const Icon(Icons.arrow_back_ios),
  });

  @override
  Widget build(BuildContext context) {
    final backButtonTheme = Theme.of(context).extension<BackButtonTheme>()!;

    return IconButton(
      icon: icon,
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(backButtonTheme.iconColor),
        overlayColor: WidgetStatePropertyAll(backButtonTheme.overlayColor),
        backgroundColor: WidgetStatePropertyAll(
          backButtonTheme.backgroundColor,
        ),
        iconSize: WidgetStatePropertyAll(backButtonTheme.iconSize),
      ),
      onPressed:
          onPressed ??
          () {
            Navigator.pop(context);
          },
    );
  }
}
