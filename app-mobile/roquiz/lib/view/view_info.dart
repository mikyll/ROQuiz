import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/cli/utils/navigation.dart';
import 'package:roquiz/model/palette.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/themes.dart';

const DEFAULT_SIZE = 60.0;

class ViewInfo extends StatefulWidget {
  const ViewInfo({super.key});

  @override
  State<StatefulWidget> createState() => ViewInfoState();
}

class ViewInfoState extends State<ViewInfo> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  double _maxSize = 0.0;

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
        openUrl("https://github.com/mikyll/ROQuiz");
      }
    });

    // TODO: show star message
    // prefs.getBool("showStarMessage");
  }

  @override
  Widget build(BuildContext context) {
    final ContainerColors containerColors =
        Theme.of(context).extension<ContainerColors>()!;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Stack(alignment: Alignment.bottomCenter, children: [
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Info"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(Settings.APP_TITLE,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                Text("v1.11.0${Settings.VERSION_NUMBER}",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(flex: 1),
                Text(
                  "Applicazione per esercitarsi con i quiz del corso Ricerca Operativa M.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 4,
                  child: ListView(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("Sviluppata da: ",
                                  maxLines: 2, style: TextStyle(fontSize: 18)),
                            ),
                            InkWell(
                              onTap: () {
                                openUrl("https://github.com/mikyll");
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "mikyll",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  )
                                ],
                              ),
                            )
                          ]),
                      const SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                                child: Text("In collaborazione con: ",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 18))),
                            InkWell(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ViewCredits()));
                              // },
                              child: const Text("contributors",
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
                                child: Text("Repository GitHub: ",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 18))),
                            InkWell(
                              onTap: () {
                                openUrl("https://github.com/mikyll/ROQuiz");
                              },
                              child: const Text("mikyll/ROQuiz",
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
                                child: Text("Licenze: ",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 18))),
                            InkWell(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ViewLicenses()));
                              // },
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
                                  openUrl(
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
                Spacer(flex: 2)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                color: containerColors.backgroundColor,
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
                    color: containerColors.starColor,
                    size: _animation.value * 0.9),
              ),
            );
          },
        ),
      ),
      Positioned(
          bottom: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Ti sfido a premermi",
                  style: TextStyle(
                    fontSize: 24, // Adjust size based on your needs
                    fontWeight: FontWeight.bold, // Comic text is often bold
                    color: Colors.black, // Text color
                    letterSpacing:
                        1.5, // Slightly spaced letters for comic effect

                    // shadows: [
                    //   Shadow(
                    //     offset: Offset(10, 10), // Creates a shadow for depth
                    //     blurRadius: 4.0, // Slight blur for softer shadow
                    //     color: Colors.grey, // Shadow color
                    //   ),
                    // ],
                    decoration:
                        TextDecoration.none, // Remove underlines or similar
                  )),
            ),
          )
          // CircleAvatar(
          //   radius: 50,
          //   backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/56556806?v=4")
          // )
          ),
    ]);
  }
}
