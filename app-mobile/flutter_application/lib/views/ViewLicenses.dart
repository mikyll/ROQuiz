import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roquiz/model/license.dart';
import 'package:roquiz/widget/licenses_widget.dart';

class ViewLicenses extends StatelessWidget {
  const ViewLicenses({super.key});

  Future<List<License>> loadLicenses(BuildContext context) async {
    final bundle = DefaultAssetBundle.of(context);
    final licenses = await bundle.loadString("assets/licenses.json");

    return json
        .decode(licenses)
        .map<License>((license) => License.fromJson(license))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Licenses"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: FutureBuilder<List<License>>(
          future: loadLicenses(context),
          builder: (context, snapshot) {
            final licenses = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                } else {
                  return LicensesWidget(licenses: licenses!);
                }
            }
          },
        ),
      ),
    );
  }
}
