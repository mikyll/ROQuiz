import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/palette.dart';
import 'package:roquiz/model/Themes.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    Key? key,
    this.borderRadius = 30,
    this.onTap,
    this.onDoubleTap,
    this.width,
    this.height,
    this.lightPalette,
    this.darkPalette,
    this.iconSize,
    this.shadow = false,
    required this.icon,
  }) : super(key: key);

  final IconData icon;

  final double borderRadius;
  final IconButtonPalette? lightPalette;
  final IconButtonPalette? darkPalette;
  final Function()? onTap;
  final Function()? onDoubleTap;
  final double? width;
  final double? height;
  final double? iconSize;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Opacity(
      opacity: onTap == null && onDoubleTap == null ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? darkPalette!.color
              : lightPalette!.color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow
              ? const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          highlightColor: themeProvider.isDarkMode
              ? darkPalette!.highlightColor
              : lightPalette!.highlightColor,
          hoverColor: themeProvider.isDarkMode
              ? darkPalette!.hoverColor
              : lightPalette!.hoverColor,
          splashColor: themeProvider.isDarkMode
              ? darkPalette!.splashColor
              : lightPalette!.splashColor,
          child: SizedBox(
            width: width,
            height: height,
            child: Icon(icon,
                color: themeProvider.isDarkMode
                    ? darkPalette!.iconColor
                    : lightPalette!.iconColor,
                size: iconSize),
          ),
        ),
      ),
    );
  }
}

class IconButtonLongPressWidget extends StatefulWidget {
  const IconButtonLongPressWidget({
    Key? key,
    this.minDelay = 50,
    this.initialDelay = 300,
    this.delaySteps = 5,
    this.borderRadius = 1000,
    this.onUpdate,
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
  final Function? onUpdate;

  final IconButtonPalette? lightPalette;
  final IconButtonPalette? darkPalette;
  final double? width;
  final double? height;
  final double? iconSize;
  final Color? iconColor;

  final int minDelay;
  final int initialDelay;
  final int delaySteps;
  final double borderRadius;

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

    while (_holding && widget.onUpdate != null) {
      widget.onUpdate!();
      await Future.delayed(Duration(milliseconds: delay.round()));
      if (delay > widget.minDelay) delay -= step;
    }
  }

  void _stopHolding() {
    _holding = false;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      color: themeProvider.isDarkMode
          ? widget.darkPalette!.color
          : widget.lightPalette!.color,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        onTap: widget.onUpdate != null ? () => _stopHolding() : null,
        onTapDown: widget.onUpdate != null ? (_) => _startHolding() : null,
        onTapCancel: widget.onUpdate != null ? () => _stopHolding() : null,
        highlightColor: themeProvider.isDarkMode
            ? widget.darkPalette!.highlightColor
            : widget.lightPalette!.highlightColor,
        hoverColor: themeProvider.isDarkMode
            ? widget.darkPalette!.hoverColor
            : widget.lightPalette!.hoverColor,
        splashColor: themeProvider.isDarkMode
            ? widget.darkPalette!.splashColor
            : widget.lightPalette!.splashColor,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Icon(widget.icon,
              color: widget.iconColor ??
                  (themeProvider.isDarkMode
                      ? widget.darkPalette!.iconColor
                      : widget.lightPalette!.iconColor),
              size: widget.iconSize),
        ),
      ),
    );
  }
}
