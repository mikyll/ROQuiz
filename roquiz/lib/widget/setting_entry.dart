import 'package:flutter/material.dart';

class SettingEntry extends StatelessWidget {
  final String label;
  final Widget child;
  final String? tooltip;

  /// When false the label is greyed out and the control beside it is dimmed and
  /// made non-interactive (wrapped in an [IgnorePointer]), so the whole entry
  /// reads as disabled and won't react to hover/taps. The [child] should still
  /// disable its own behaviour too (e.g. a [Checkbox] with `onChanged: null`) so
  /// it paints in its disabled state.
  final bool enabled;

  /// Optional hidden action bound to the label: tapping the label text runs it.
  /// Deliberately gives no visual affordance (no underline/cursor change) — it's
  /// a discreet shortcut, not an advertised button. Ignored when [enabled] is
  /// false.
  final VoidCallback? onLabelTap;

  /// Optional visible control shown just before [child] (e.g. a refresh
  /// [IconButton] to run a check on demand). Dimmed and made non-interactive
  /// along with [child] when [enabled] is false.
  final Widget? action;

  const SettingEntry({
    super.key,
    required this.label,
    required this.child,
    this.tooltip,
    this.enabled = true,
    this.onLabelTap,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    Widget labelText = Text(
      label,
      style: TextStyle(
        fontSize: 18.0,
        color: enabled ? null : Theme.of(context).disabledColor,
      ),
    );

    // The hidden label action: a transparent, opaque-hit tap target over just
    // the label glyphs (the Align below shrinks it to the text's width). No
    // visual change, so the shortcut stays discreet.
    if (enabled && onLabelTap != null) {
      labelText = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onLabelTap,
        child: labelText,
      );
    }

    // Put an optional action button right beside the control, while keeping the
    // control itself centered in the column (aligned with the checkboxes in the
    // rows that have no action): an invisible mirror of the action on the far
    // side balances the row, so [child] stays dead-centre and the real action
    // sits immediately to its left.
    final Widget trailing = action == null
        ? child
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              action!,
              // A little breathing room between the button and the control (and
              // the same on the far side, so [child] stays centred).
              const SizedBox(width: 12.0),
              child,
              const SizedBox(width: 12.0),
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: action!,
              ),
            ],
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            // Align keeps the tooltip's hit area shrunk to the text's width,
            // so it triggers only on hovering the label glyphs and not the
            // empty space across the rest of the entry.
            child: Align(
              alignment: Alignment.centerLeft,
              child: tooltip != null
                  ? Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      textAlign: TextAlign.center,
                      margin: EdgeInsets.all(5.0),
                      constraints: BoxConstraints(maxWidth: 300.0),
                      message: tooltip,
                      child: labelText,
                    )
                  : labelText,
            ),
          ),
          SizedBox(
            width: 150.0,
            // Dim the control to match the greyed label: an unchecked disabled
            // Checkbox otherwise looks the same as an enabled one. IgnorePointer
            // stops it from reacting to hover/taps (e.g. a disabled dropdown's
            // InputDecorator would otherwise still paint a hover highlight).
            child: enabled
                ? trailing
                : IgnorePointer(child: Opacity(opacity: 0.5, child: trailing)),
          ),
        ],
      ),
    );
  }
}
