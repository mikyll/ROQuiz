import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/utils/navigation.dart';
import 'package:roquiz/view/view_licenses.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
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
    final settings = Provider.of<Settings>(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: ConstrainedAppBar(
            maxWidth: 500.0,
            title: const Text("Info"),
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        "ROQuiz",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextTheme.of(context).displaySmall,
                      ),
                      Text(
                        "v${widget.packageInfo.version}+${widget.packageInfo.buildNumber}",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextTheme.of(context).titleMedium,
                      ),
                      const Spacer(flex: 1),
                      // textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 18),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextTheme.of(
                            context,
                          ).bodyLarge!.copyWith(height: 1.3),
                          children: [
                            TextSpan(
                              text:
                                  "ROQuiz è un'applicazione a quiz per ripassare la teoria del corso ",
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
                            TextSpan(text: ", dell'Università di Bologna. "),
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
                                  "Gli sviluppatori non si assumono responsabilità nel caso di errori nei quiz, né per usi impropri dell'applicazione. ",
                            ),
                            TextSpan(text: "Fatene buon uso e "),
                            TextSpan(
                              text: "buona fortuna",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: " con l'esame!"),
                          ],
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
                                    openUrl("https://github.com/mikyll");
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
                                    openUrl("https://github.com/mikyll/ROQuiz");
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
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: StarButton(
            size: 70.0,
            animate: settings.animations,
            onTap: !settings.animations
                ? () {
                    openUrl("https://github.com/mikyll/ROQuiz");
                  }
                : null,
            onMaxSize: settings.animations
                ? () {
                    openUrl("https://github.com/mikyll/ROQuiz");
                  }
                : null,
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
