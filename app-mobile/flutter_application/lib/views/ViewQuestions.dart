// costruisce il widget in base alle domande che gli vengono passate

import 'package:flutter/material.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';

class ViewQuestions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ViewQuestionsState();
}

class ViewQuestionsState extends State<ViewQuestions> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ask for save / discard ?
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.indigo[900],
          appBar: AppBar(
            title: const Text("Argomenti"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container()),
    );
  }
}
