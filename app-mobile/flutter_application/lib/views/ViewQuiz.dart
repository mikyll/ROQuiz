import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ViewQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Quiz"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
