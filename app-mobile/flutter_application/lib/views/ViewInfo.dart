import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/views/ViewCredits.dart';
import 'package:roquiz/views/ViewLicenses.dart';
import 'package:roquiz/model/Themes.dart';
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
  //double _screenHeight = 0.0;

  double _size = DEFAULT_SIZE;

  double _increment = 0.1;

  void _increaseSize() {
    setState(() {
      _size += _increment;
      _increment *= 1.2;
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    FlutterView view = PlatformDispatcher.instance.views.first;
    double physicalWidth = view.physicalSize.width;
    //double physicalHeight = view.physicalSize.height;

    double devicePixelRatio = view.devicePixelRatio;
    _screenWidth = physicalWidth / devicePixelRatio;
    //_screenHeight = physicalHeight / devicePixelRatio;
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
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text("${Settings.APP_TITLE} v${Settings.VERSION_NUMBER}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Expanded(
                        child: Text("Applicazione sviluppata da: ",
                            style: TextStyle(fontSize: 18)),
                      ),
                      InkWell(
                        onTap: () {
                          _launchInBrowser("https://github.com/mikyll");
                        },
                        child: const Text("mikyll",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline)),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Expanded(
                          child: Text("In collaborazione con: ",
                              style: TextStyle(fontSize: 18))),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewCredits()));
                        },
                        child: const Text("contributors",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline)),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Expanded(
                          child: Text("Repository GitHub: ",
                              style: TextStyle(fontSize: 18))),
                      InkWell(
                        onTap: () {
                          _launchInBrowser("https://github.com/mikyll/ROQuiz");
                        },
                        child: const Text("mikyll/ROQuiz",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline)),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Expanded(
                          child: Text("Licenze: ",
                              style: TextStyle(fontSize: 18))),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewLicenses()));
                        },
                        child: const Text("Visualizza le licenze",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline)),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text("Problemi con l'app? ",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                _launchInBrowser(
                                    "https://github.com/mikyll/ROQuiz/issues/new?title=[Mobile]+Titolo+Problema&body=Descrivi+qui+il+problema%2C+possibilmente+aggiungendo+una+o+pi%C3%B9+etichette.");
                              },
                              child: const Text("Apri una issue",
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline)),
                            ),
                            const Text(" su GitHub!",
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Container(
                  color: Colors.indigo.withOpacity(0.35),
                  alignment: Alignment.center,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Ti sfido a tenere premuta la stellina",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),
                ),
              ),
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
