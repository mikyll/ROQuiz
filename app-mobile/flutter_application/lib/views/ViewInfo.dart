import 'package:flutter/material.dart';

class ViewInfoWidget extends StatelessWidget {
  const ViewInfoWidget({Key? key}) : super(key: key);

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
