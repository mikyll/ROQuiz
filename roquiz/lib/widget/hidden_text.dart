import 'package:flutter/material.dart';

// This class is used as a workaround to make a newline when selecting
// text from multiple widgets, in the same SelectionArea.
class HiddenText extends StatelessWidget {
  final String text;
  final double size;

  const HiddenText({super.key, this.text = "\n ", this.size = 6.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      child: Text(
        text,
        style: TextStyle(fontSize: size),
        selectionColor: Colors.transparent,
      ),
    );
  }
}
