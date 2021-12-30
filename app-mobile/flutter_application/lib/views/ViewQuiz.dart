import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ViewQuiz extends StatelessWidget {
  const ViewQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Quiz"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
