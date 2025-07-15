import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/style/theme_provider.dart';
import 'package:roquiz/model/utils/navigation.dart';
import 'package:roquiz/view/view_licenses.dart';
import 'package:roquiz/widget/star_button.dart';
// import 'package:roquiz/cli/utils/navigation.dart';
// import 'package:roquiz/model/palette.dart';
// import 'package:roquiz/model/persistence/settings.dart';

class ViewInfo extends StatefulWidget {
  final PackageInfo packageInfo;

  const ViewInfo({super.key, required this.packageInfo});

  @override
  State<StatefulWidget> createState() => ViewInfoState();
}

class ViewInfoState extends State<ViewInfo> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
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
                  Text(
                    "ROQuiz",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "v${widget.packageInfo.version}+${widget.packageInfo.buildNumber}",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 1),
                  // textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 18),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "ROQuiz è un'applicazione per esercitarsi con i quiz del corso ",
                        ),
                        TextSpan(
                          text: "Ricerca Operativa M",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl(
                                "https://www.unibo.it/it/studiare/insegnamenti-competenze-trasversali-moocs/insegnamenti/insegnamento/2022/467997",
                              );
                            },
                        ),
                        TextSpan(text: ", dell'Università di Bologna.\n"),
                        // TextSpan(
                        //   text:
                        //       "L'obiettivo di ROQuiz è fornire supporto per il ripasso della teoria. ",
                        // ),
                        // TextSpan(
                        //   text:
                        //       "Non è un'applicazione ufficiale e non sostituisce in alcun modo la preparazione della teoria dell'esame, per cui è necessario studiare. ",
                        // ),
                        TextSpan(
                          text:
                              "Gli sviluppatori non si assumono responsabilità di alcun tipo nel caso di errori nei quiz, né per usi impropri dell'applicazione. ",
                        ),
                        TextSpan(text: "Fatene buon uso e "),
                        TextSpan(
                          text: "buona fortuna",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " con l'esame!"),
                      ],
                      style: TextStyle(fontSize: 18),
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
                              child: Text(
                                "Sviluppata da: ",
                                maxLines: 2,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // openUrl("https://github.com/mikyll");
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "mikyll",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                "In collaborazione con: ",
                                maxLines: 2,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            InkWell(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ViewCredits()));
                              // },
                              child: const Text(
                                "contributors",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                "Repository GitHub: ",
                                maxLines: 2,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // openUrl("https://github.com/mikyll/ROQuiz");
                              },
                              child: const Text(
                                "mikyll/ROQuiz",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                "Licenze: ",
                                maxLines: 1,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewLicenses(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Visualizza le licenze",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                "Problemi con l'app? ",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // openUrl(
                                    //   "https://github.com/mikyll/ROQuiz/issues/new/choose",
                                    // );
                                  },
                                  child: const Text(
                                    "Apri una issue",
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const Text(
                                  " su GitHub!",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: StarButton(
            size: 70.0,
            onMaxSize: () {
              openUrl("https://github.com/mikyll/ROQuiz");
            },
          ),
          // CircleAvatar(
          //   radius: 50,
          //   backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/56556806?v=4")
          // )
        ),
      ],
    );
  }
}
