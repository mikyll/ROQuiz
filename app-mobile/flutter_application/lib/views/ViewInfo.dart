import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/views/ViewCredits.dart';
import 'package:roquiz/views/ViewLicenses.dart';
import 'package:roquiz/model/Themes.dart';
import 'package:url_launcher/url_launcher.dart';

const DEFAULT_SIZE = 60.0;

class ViewInfo extends StatefulWidget {
  const ViewInfo({Key? key, required this.settings}) : super(key: key);

  final Settings settings;

  @override
  State<StatefulWidget> createState() => ViewInfoState();
}

class ViewInfoState extends State<ViewInfo> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  double _maxSize = 0.0;

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
    double physicalHeight = view.physicalSize.height;

    double devicePixelRatio = view.devicePixelRatio;
    double screenWidth = physicalWidth / devicePixelRatio;
    double screenHeight = physicalHeight / devicePixelRatio;

    _maxSize = (screenWidth < screenHeight ? screenWidth : screenHeight) * 0.8;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: DEFAULT_SIZE,
    );

    _animation = Tween<double>(begin: DEFAULT_SIZE, end: _maxSize).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _animationController.reset();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _launchInBrowser("https://github.com/mikyll/ROQuiz");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
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
                                    "https://github.com/mikyll/ROQuiz/issues/new/choose");
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // CAGATE
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Container(
            width: _animation.value,
            height: _animation.value,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? MyThemes.darkIconButtonPalette.color
                  : MyThemes.lightIconButtonPalette.color,
              borderRadius: BorderRadius.circular(1000),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(1000),
              onTapDown: (details) {
                _animationController.forward();
              },
              onTapUp: (details) {
                _animationController.reverse();
              },
              onTapCancel: () {
                _animationController.reverse();
              },
              child: Icon(Icons.star,
                  color: themeProvider.isDarkMode
                      ? Colors.red[900]
                      : Colors.yellow,
                  size: _animation.value * 0.9),
            ),
          );
        },
      ),
    );
  }
}
