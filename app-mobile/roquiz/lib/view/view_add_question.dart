import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:roquiz/model/palette.dart';
import 'package:roquiz/persistence/settings.dart';

class ViewAddQuestion extends StatefulWidget {
  const ViewAddQuestion({super.key});

  @override
  State<StatefulWidget> createState() => ViewAddQuestionState();
}

class ViewAddQuestionState extends State<ViewAddQuestion> with TickerProviderStateMixin {

  String _buildURL() {
    String res = "https://github.com/mikyll/ROQuiz/blob/main/.github/ISSUE_TEMPLATE/new_question.it.yaml";

    return res;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Aggiungi Domanda"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text("Nuova Domanda",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const Spacer(flex: 2),
              Expanded(
                flex: 4,
                child: Form(
                  child: ListView(
                    
                    children: [
                        DropdownButtonFormField(
                            decoration: InputDecoration(label: Text("Argomento")),
                            items: [
                                DropdownMenuItem(key: Key("1"), value: 2, child: Text("Programmazione Matematica")),
                                DropdownMenuItem(key: Key("2"), value: 1, child: Text("Programmazione Lineare")),
                            ], onChanged: (_) {},
                        ),
                        TextFormField(maxLines: 5, decoration: InputDecoration(label: Text("Domanda")),),
                        TextFormField(decoration: InputDecoration(label: Text("Risposta A")),),
                        TextFormField(decoration: InputDecoration(label: Text("Risposta B")),),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(onPressed: () {}, child: Text("Aggiungi"),),
    );
  }
}
