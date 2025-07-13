import 'package:flutter/material.dart';
import 'package:roquiz/model/license.dart';

class LicensesWidget extends StatelessWidget {
  final List<License> licenses;

  const LicensesWidget({
    super.key,
    required this.licenses,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: licenses.length,
        itemBuilder: (context, index) {
          final license = licenses[index];

          return ListTile(
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SelectableText(
                license.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: SelectableText(
              license.text,
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
      );
}
