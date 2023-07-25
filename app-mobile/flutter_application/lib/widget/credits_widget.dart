import 'package:flutter/material.dart';
import 'package:roquiz/model/Contribution.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsWidget extends StatefulWidget {
  final List<Contribution> credits;

  const CreditsWidget({
    Key? key,
    required this.credits,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreditsWidgetState();
}

class CreditsWidgetState extends State<CreditsWidget> {
  List<Contribution> credits = [];
  final List<Contribution> alreadyAddedCredits = [];
  final List<Widget> creditWidgets = [];

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  bool _containsContribution(
      List<Contribution> contributionList, Contribution other) {
    for (Contribution contribution in contributionList) {
      if (contribution.task == other.task) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      credits = widget.credits;
    });

    for (int i = 0; i < credits.length; i++) {
      Contribution contribution = credits[i];

      bool alreadyPresent =
          _containsContribution(alreadyAddedCredits, contribution);

      Padding widget = Padding(
        padding: EdgeInsets.only(top: !alreadyPresent ? 20.0 : 5.0),
        child: Row(
          children: [
            Expanded(
                child: Text(!alreadyPresent ? "${contribution.task}: " : "",
                    style: const TextStyle(fontSize: 18))),
            Row(
              children: [
                Text(!alreadyPresent ? "" : "&  ",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18)),
                InkWell(
                  onTap: () {
                    _launchInBrowser(contribution.url);
                  },
                  child: Text(contribution.author,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ],
        ),
      );
      setState(() {
        creditWidgets.add(widget);

        if (!alreadyPresent) {
          alreadyAddedCredits.add(contribution);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25.0),
          itemCount: widget.credits.length,
          itemBuilder: (context, index) {
            return creditWidgets[index];
          },
        ),
      );
}
