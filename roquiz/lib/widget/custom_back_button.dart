import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roquiz/model/style/theme_extensions.dart';

class CustomBackButton extends StatefulWidget {
  final Widget icon;
  final void Function()? onPressed;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.icon = const Icon(Icons.arrow_back_ios),
  });

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  void _goBack() {
    final onPressed = widget.onPressed;
    if (onPressed != null) {
      onPressed();
    } else {
      Navigator.pop(context);
    }
  }

  // Escape triggers the back button, but only for the button on the topmost
  // route — otherwise every back button still mounted in the navigation stack
  // would fire at once.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) {
      return false;
    }
    _goBack();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final backButtonTheme = Theme.of(context).extension<BackButtonTheme>()!;

    return IconButton(
      icon: widget.icon,
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(backButtonTheme.iconColor),
        overlayColor: WidgetStatePropertyAll(backButtonTheme.overlayColor),
        backgroundColor: WidgetStatePropertyAll(
          backButtonTheme.backgroundColor,
        ),
        iconSize: WidgetStatePropertyAll(backButtonTheme.iconSize),
      ),
      onPressed: _goBack,
    );
  }
}
