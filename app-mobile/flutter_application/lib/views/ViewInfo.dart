import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:roquiz/model/Settings.dart';
import 'package:roquiz/widget/Themes.dart';
import 'package:roquiz/widget/change_theme_button_widget.dart';
import 'package:roquiz/widget/icon_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

const DEFAULT_SIZE = 50.0;

class ViewInfo extends StatefulWidget {
  const ViewInfo({Key? key, required this.settings}) : super(key: key);

  final Settings settings;

  @override
  State<StatefulWidget> createState() => ViewInfoState();
}

class ViewInfoState extends State<ViewInfo> with TickerProviderStateMixin {
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;

  double _size = DEFAULT_SIZE;

  double _increment = 1.0;

  void _increaseSize() {
    setState(() {
      _size += _increment;
      _increment *= 1.1;
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _screenWidth = (window.physicalSize.shortestSide / window.devicePixelRatio);
    _screenHeight = (window.physicalSize.longestSide / window.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Info"),
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
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Text(
                  "ROQuiz v${Settings.VERSION_NUMBER}${Settings.VERSION_SUFFIX}",
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                  child: Text("Applicazione sviluppata da:",
                      style: TextStyle(fontSize: 18)),
                ),
                InkWell(
                  onTap: () {
                    _launchInBrowser("https://github.com/mikyll");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("mikyll",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                    child: Text("Repository GitHub:",
                        style: TextStyle(fontSize: 18))),
                InkWell(
                  onTap: () {
                    _launchInBrowser("https://github.com/mikyll/ROQuiz");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("mikyll/ROQuiz",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                  child: Text("Problemi con l'app?",
                      style: TextStyle(fontSize: 18)),
                ),
                InkWell(
                  onTap: () {
                    _launchInBrowser(
                        "https://github.com/mikyll/ROQuiz/issues/new?title=[Mobile]+Titolo+Problema&body=Descrivi+qui+il+problema%2C+possibilmente+aggiungendo+una+o+pi%C3%B9+etichette.");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Apri una issue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ),
                const Text("su GitHub!", style: TextStyle(fontSize: 18)),
              ]),
              const SizedBox(height: 50),
              Container(
                color: Colors.indigo.withOpacity(0.35),
                height: 60,
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Ti sfido a tenere premuta la stellina",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ),
              ),
              const Spacer(flex: 3)
            ],
          ),
        ),
      ),
      // CAGATE
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IconButtonLongPressWidget(
        onUpdate: () {
          if (_size == 0.0) {
            return;
          }
          if (_size < _screenWidth - 100.0) {
            _increaseSize();
          } else {
            _size = 1.0;
            _increment = 0.0;
            _launchInBrowser("https://github.com/mikyll/ROQuiz");
          }
        },
        width: _size,
        height: _size,
        icon: Icons.star,
        iconSize: _size * 0.8,
        iconColor: Colors.yellow,
        lightPalette: MyThemes.lightIconButtonPalette,
        darkPalette: MyThemes.darkIconButtonPalette,
      ),
    );
  }
}
