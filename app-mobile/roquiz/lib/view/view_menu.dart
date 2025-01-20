import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/themes.dart';
import 'package:roquiz/persistence/settings.dart';
import 'package:roquiz/view/view_info.dart';
import 'package:roquiz/widget/icon_button_widget.dart';

class ViewMenu extends StatefulWidget {
  const ViewMenu({super.key});

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Settings.SHOW_APP_LOGO
                      ? Column(children: [
                          SvgPicture.asset(
                            'assets/icons/logo.svg',
                            alignment: Alignment.center,
                            fit: BoxFit.fitWidth,
                            width: 200,
                            colorFilter: ColorFilter.mode(
                                themeProvider.isDarkMode
                                    ? Colors.indigo[300]!
                                    : Colors.indigo[600]!,
                                BlendMode.srcIn),
                          ),
                          const Text(
                            Settings.APP_TITLE,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])
                      : const Text(
                          Settings.APP_TITLE,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  Text(
                    "v${Settings.VERSION_NUMBER}",
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 1),
                  // BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "Avvia",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "Argomenti",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(direction: Axis.horizontal, children: [
                    const Icon(
                      Icons.format_list_numbered_rounded,
                    ),
                    Text(" Domande: X su Y"),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.timer_rounded,
                    ),
                    Text(" Tempo: N min"),
                  ]),
                  false
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "error",
                            style: const TextStyle(color: Colors.red),
                          ))
                      : const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      // _launchInBrowser("https://github.com/mikyll/ROQuiz");
                    },
                    child: Container(
                      color: Colors.indigo.withOpacity(0.35),
                      alignment: Alignment.center,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "Se l'app ti è piaciuta, considera di lasciare una stellina alla repository GitHub!\n\nBasta un click qui!",
                            maxLines: 6,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ),
                  const Spacer(flex: 5),
                ],
              ))),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: IconButton.filled(
              onPressed: () {},
              iconSize: 40,
              icon: Icon(
                Icons.settings,
              ),
            ),
          ),
          // IconButtonWidget(
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) =>
          //     //     return ViewSettings(
          //     //       qRepo: qRepo,
          //     //       settings: _settings,
          //     //       reloadTopics: loadTopics,
          //     //   )),
          //     // );
          //   },
          //   width: 60.0,
          //   height: 60.0,
          //   lightPalette: MyThemes.lightIconButtonPalette,
          //   darkPalette: MyThemes.darkIconButtonPalette,
          //   icon: Icons.settings,
          //   iconSize: 40,
          //   shadow: true,
          // ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 60,
            width: 60,
            child: IconButton.filled(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewInfo();
                }));
              },
              iconSize: 40,
              icon: Icon(
                Icons.info,
                color:
                    themeProvider.isDarkMode ? Color(0xff515b92) : Colors.white,
              ),
            ),
          ),
          // IconButtonWidget(
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       // return ViewInfo(settings: _settings);

          //       // TODO
          //       return ViewMenu();
          //     }));
          //   },
          //   width: 60.0,
          //   height: 60.0,
          //   lightPalette: MyThemes.lightIconButtonPalette,
          //   darkPalette: MyThemes.darkIconButtonPalette,
          //   icon: Icons.info,
          //   iconSize: 40,
          //   shadow: true,
          // ),
        ],
      ),
    );
  }
}
