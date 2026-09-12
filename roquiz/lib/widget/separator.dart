import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String text;
  final double size;
  final double indent;

  const Separator({
    super.key,
    required this.text,
    this.size = 18.0,
    this.indent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent, right: indent),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: size, color: Colors.grey),
          ),
          Expanded(child: Divider(thickness: 2, indent: 10.0)),
        ],
      ),
    );
  }
}
