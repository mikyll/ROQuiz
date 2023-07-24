import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roquiz/model/Contribution.dart';
import 'package:roquiz/widget/credits_widget.dart';

class ViewCredits extends StatelessWidget {
  const ViewCredits({Key? key}) : super(key: key);

  Future<List<Contribution>> loadCredits(BuildContext context) async {
    final bundle = DefaultAssetBundle.of(context);
    final contributors = await bundle.loadString("assets/credits.json");

    return json
        .decode(contributors)
        .map<Contribution>((contributor) => Contribution.fromJson(contributor))
        .toList();
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
        child: FutureBuilder<List<Contribution>>(
          future: loadCredits(context),
          builder: (context, snapshot) {
            final licenses = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                } else {
                  return CreditsWidget(credits: licenses!);
                }
            }
          },
        ),
      ),
    );
  }

  /*Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text("Build macOS e iOS:",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _launchInBrowser(
                                        "https://github.com/TryKatChup");
                                  },
                                  child: const Text("TryKatChup",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                const Text(" &",
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _launchInBrowser(
                                    "https://github.com/Federicoand98");
                              },
                              child: const Text("Federyeeco",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text("Spiegazione domande:",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _launchInBrowser(
                                        "https://github.com/lollofred");
                                  },
                                  child: const Text("LolloFred",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                const Text(" &",
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _launchInBrowser(
                                    "https://github.com/filippoveronesi");
                              },
                              child: const Text("filovero98",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text("Nuove domande:",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _launchInBrowser(
                                        "https://github.com/RedDuality");
                                  },
                                  child: const Text("RedDuality",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                //const Text(" &",
                                //    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            /*InkWell(
                              onTap: () {
                                _launchInBrowser(
                                    "https://github.com/filippoveronesi");
                              },
                              child: const Text("filovero98",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline)),
                            ),*/
                          ],
                        ),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }*/
}
