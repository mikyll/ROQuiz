import 'package:flutter/material.dart';
import 'package:roquiz/model/Contribution.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsWidget extends StatelessWidget {
  final List<Contribution> credits;

  const CreditsWidget({
    Key? key,
    required this.credits,
  }) : super(key: key);

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25.0),
          itemCount: credits.length,
          itemBuilder: (context, index) {
            final contribution = credits[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text("${contribution.task}: ",
                          style: const TextStyle(fontSize: 18))),
                  InkWell(
                    onTap: () {
                      _launchInBrowser(contribution.url);
                    },
                    child: Text(contribution.author,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
