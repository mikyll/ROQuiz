import 'package:flutter/material.dart';

class SettingEntry extends StatelessWidget {
  final String label;
  final Widget child;
  final String? tooltip;

  const SettingEntry({
    super.key,
    required this.label,
    required this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final Widget row = Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 18.0))),
        SizedBox(width: 150.0, child: child),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: tooltip != null
          ? Tooltip(
              waitDuration: Duration(milliseconds: 500),
              textAlign: TextAlign.center,
              margin: EdgeInsets.all(5.0),
              constraints: BoxConstraints(maxWidth: 300.0),
              message: tooltip,
              child: row,
            )
          : row,
    );
  }
}
