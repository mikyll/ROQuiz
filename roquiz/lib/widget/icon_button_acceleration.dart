import 'package:flutter/material.dart';

class IconButtonAcceleration extends StatefulWidget {
  // Acceleration stuff
  final int minDelay;
  final int initialDelay;
  final int delaySteps;
  final void Function()? onUpdate;

  // Default properties
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final void Function()? onPressed;
  final void Function(bool)? onHover;
  final void Function()? onLongPress;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final bool? isSelected;
  final Widget? selectedIcon;
  final Widget icon;

  const IconButtonAcceleration({
    super.key,
    // Acceleration stuff
    this.minDelay = 15,
    this.initialDelay = 200,
    this.delaySteps = 3,
    this.onUpdate,
    // Default parameters
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.onPressed,
    this.onHover,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
    required this.icon,
  }) : assert(
         minDelay <= initialDelay,
         "The minimum delay cannot be larger than the initial delay",
       );

  @override
  State<StatefulWidget> createState() => IconButtonAccelerationState();
}

class IconButtonAccelerationState extends State<IconButtonAcceleration> {
  bool _holding = false;
  // Identifies the current press. Bumped on every release so a leftover loop
  // whose `await` is still pending exits instead of resuming into the next
  // press — otherwise rapid taps stack concurrent loops and skip steps.
  int _holdSession = 0;

  void _startHolding() async {
    // Make sure this isn't called more than once for
    // whatever reason.
    if (_holding) {
      return;
    }

    final session = ++_holdSession;
    setState(() {
      _holding = true;
    });

    // Calculate the delay decrease per step
    final step =
        (widget.initialDelay - widget.minDelay).toDouble() / widget.delaySteps;
    var delay = widget.initialDelay.toDouble();

    while (_holding &&
        session == _holdSession &&
        mounted &&
        widget.onUpdate != null) {
      widget.onUpdate!();
      await Future.delayed(Duration(milliseconds: delay.round()));
      if (delay > widget.minDelay) {
        delay -= step;
      }
    }
  }

  void _stopHolding() {
    if (!_holding) {
      return;
    }
    _holdSession++;
    setState(() {
      _holding = false;
    });
  }

  @override
  void dispose() {
    _holding = false;
    _holdSession++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When an [onUpdate] is supplied the button drives its action through the
    // press-and-hold loop, so give it a no-op onPressed (unless the caller set
    // one) to keep it visually enabled and tappable.
    final onPressed =
        widget.onPressed ?? (widget.onUpdate != null ? () {} : null);

    final button = IconButton(
      iconSize: widget.iconSize,
      visualDensity: widget.visualDensity,
      padding: widget.padding,
      alignment: widget.alignment,
      // splashRadius: widget.splashRadius,
      color: widget.color,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      disabledColor: widget.disabledColor,
      onPressed: onPressed,
      onHover: widget.onHover,
      onLongPress: widget.onLongPress,
      mouseCursor: widget.mouseCursor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      tooltip: widget.tooltip,
      enableFeedback: widget.enableFeedback,
      constraints: widget.constraints,
      style: widget.style,
      isSelected: widget.isSelected,
      selectedIcon: widget.selectedIcon,
      icon: widget.icon,
    );

    // No acceleration callback: behave like a plain IconButton.
    if (widget.onUpdate == null) {
      return button;
    }

    // A pointer press fires [onUpdate] once immediately and then repeats with
    // a shrinking delay while held; releasing (or cancelling) stops the loop.
    // A quick tap therefore yields a single update.
    return Listener(
      onPointerDown: (_) => _startHolding(),
      onPointerUp: (_) => _stopHolding(),
      onPointerCancel: (_) => _stopHolding(),
      child: button,
    );
  }
}
