import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ViewSettings extends StatefulWidget {
  ViewSettings({
    Key? key,
    required this.qRepo,
    required this.settings,
  }) : super(key: key);

  final QuestionRepository qRepo;
  Settings settings;

  @override
  State<StatefulWidget> createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
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
