import 'package:flutter/material.dart';
import 'package:roquiz/model/Settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCredits extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Crediti"),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Expanded(
                    child: Text("Build macOS e iOS:",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _launchInBrowser("https://github.com/TryKatChup");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("TryKatChup",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                      const Text("&", style: TextStyle(fontSize: 18)),
                      InkWell(
                        onTap: () {
                          _launchInBrowser("https://github.com/Federicoand98");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Federyeeco",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                    ],
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Expanded(
                    child: Text("Spiegazione domande:",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _launchInBrowser("https://github.com/lollofred");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("LolloFred",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                      const Text("&", style: TextStyle(fontSize: 18)),
                      InkWell(
                        onTap: () {
                          _launchInBrowser(
                              "https://github.com/filippoveronesi");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("filovero98",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                    ],
                  ),
                ]),
              ]),
        ),
      ),
    );
  }
}
