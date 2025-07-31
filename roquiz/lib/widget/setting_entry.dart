import 'package:flutter/material.dart';

class SettingEntry extends StatelessWidget {
  final String label;
  final Widget child;

  const SettingEntry({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 18.0)),
          ),
          Flexible(fit: FlexFit.tight, child: child),
        ],
      ),
    );
  }
}
