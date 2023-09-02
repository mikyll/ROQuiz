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
}
