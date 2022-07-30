import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/palette.dart';
import 'package:roquiz/model/Themes.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    Key? key,
    this.onTap,
    this.onDoubleTap,
    this.width,
    this.height,
    this.lightPalette,
    this.darkPalette,
    this.iconSize,
    required this.icon,
  }) : super(key: key);

  final IconData icon;

  final IconButtonPalette? lightPalette;
  final IconButtonPalette? darkPalette;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final double? width;
  final double? height;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      borderRadius: BorderRadius.circular(30),
      color:
          _themeProvider.isDarkMode ? darkPalette!.color : lightPalette!.color,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        highlightColor: _themeProvider.isDarkMode
            ? darkPalette!.highlightColor
            : lightPalette!.highlightColor,
        hoverColor: _themeProvider.isDarkMode
            ? darkPalette!.hoverColor
            : lightPalette!.hoverColor,
        splashColor: _themeProvider.isDarkMode
            ? darkPalette!.splashColor
            : lightPalette!.splashColor,
        child: SizedBox(
          width: width,
          height: height,
          child: Icon(icon,
              color: _themeProvider.isDarkMode
                  ? darkPalette!.iconColor
                  : lightPalette!.iconColor,
              size: iconSize),
        ),
      ),
    );
  }
}

class IconButtonLongPressWidget extends StatefulWidget {
  const IconButtonLongPressWidget({
    Key? key,
    required this.onUpdate,
    this.minDelay = 50,
    this.initialDelay = 300,
    this.delaySteps = 5,
    this.width,
    this.height,
    this.lightPalette,
    this.darkPalette,
    this.iconSize,
    this.iconColor,
    required this.icon,
  })  : assert(minDelay <= initialDelay,
            "The minimum delay cannot be larger than the initial delay"),
        super(key: key);

  final IconData icon;
  final VoidCallback onUpdate;

  final IconButtonPalette? lightPalette;
  final IconButtonPalette? darkPalette;
  final double? width;
  final double? height;
  final double? iconSize;
  final Color? iconColor;

  final int minDelay;
  final int initialDelay;
  final int delaySteps;

  @override
  State<StatefulWidget> createState() {
    return _IconButtonLongPressWidgetState();
  }
}

class _IconButtonLongPressWidgetState extends State<IconButtonLongPressWidget> {
  bool _holding = false;

  void _startHolding() async {
    // Make sure this isn't called more than once for
    // whatever reason.
    if (_holding) return;
    _holding = true;

    // Calculate the delay decrease per step
    final step =
        (widget.initialDelay - widget.minDelay).toDouble() / widget.delaySteps;
    var delay = widget.initialDelay.toDouble();

    while (_holding) {
      widget.onUpdate();
      await Future.delayed(Duration(milliseconds: delay.round()));
      if (delay > widget.minDelay) delay -= step;
    }
  }

  void _stopHolding() {
    _holding = false;
  }

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      borderRadius: BorderRadius.circular(1000),
      color: _themeProvider.isDarkMode
          ? widget.darkPalette!.color
          : widget.lightPalette!.color,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10000),
        ),
        onTap: () => _stopHolding(),
        onTapDown: (_) => _startHolding(),
        onTapCancel: () => _stopHolding(),
        highlightColor: _themeProvider.isDarkMode
            ? widget.darkPalette!.highlightColor
            : widget.lightPalette!.highlightColor,
        hoverColor: _themeProvider.isDarkMode
            ? widget.darkPalette!.hoverColor
            : widget.lightPalette!.hoverColor,
        splashColor: _themeProvider.isDarkMode
            ? widget.darkPalette!.splashColor
            : widget.lightPalette!.splashColor,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Icon(widget.icon,
              color: widget.iconColor ??
                  (_themeProvider.isDarkMode
                      ? widget.darkPalette!.iconColor
                      : widget.lightPalette!.iconColor),
              size: widget.iconSize),
        ),
      ),
    );
  }
}
