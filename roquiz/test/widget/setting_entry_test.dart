import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roquiz/widget/setting_entry.dart';

/// Guards the hidden label-tap shortcut on [SettingEntry]: tapping the label
/// text fires [onLabelTap], and a disabled entry ignores it.
void main() {
  Widget harness(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets("tapping the label fires onLabelTap", (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      harness(
        SettingEntry(
          label: "Controllo aggiornamenti app:",
          onLabelTap: () => taps++,
          child: const SizedBox(),
        ),
      ),
    );

    await tester.tap(find.text("Controllo aggiornamenti app:"));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets("a disabled entry ignores the label tap", (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      harness(
        SettingEntry(
          label: "Controllo nuove domande:",
          enabled: false,
          onLabelTap: () => taps++,
          child: const SizedBox(),
        ),
      ),
    );

    await tester.tap(find.text("Controllo nuove domande:"));
    await tester.pump();

    expect(taps, 0);
  });
}
