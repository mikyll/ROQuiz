import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/widget/Themes.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget(
      {Key? key,
      required this.defaultColor,
      required this.selectedColor,
      required this.correctColor,
      required this.wrongColor,
      required this.correctNotGivenColor})
      : super(key: key);

  final Color defaultColor;
  final Color selectedColor;
  final Color correctColor;
  final Color wrongColor;
  final Color correctNotGivenColor;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
