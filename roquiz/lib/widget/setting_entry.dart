import 'package:flutter/material.dart';

class SettingEntry extends StatelessWidget {
  final String label;
  final Widget child;
  final String? tooltip;

  /// When false the label is greyed out and the control beside it is dimmed,
  /// so the whole entry reads as disabled. The [child] should still be made
  /// non-interactive by its caller (e.g. a [Checkbox] with `onChanged: null`).
  final bool enabled;

  const SettingEntry({
    super.key,
    required this.label,
    required this.child,
    this.tooltip,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget labelText = Text(
      label,
      style: TextStyle(
        fontSize: 18.0,
        color: enabled ? null : Theme.of(context).disabledColor,
      ),
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
            // Checkbox otherwise looks the same as an enabled one.
            child: enabled ? child : Opacity(opacity: 0.5, child: child),
          ),
        ],
      ),
    );
  }
}
