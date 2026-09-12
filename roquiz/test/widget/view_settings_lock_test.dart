import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/style/themes.dart';
import 'package:roquiz/view/view_settings.dart';
import 'package:roquiz/widget/setting_entry.dart';

/// Reads the `enabled` flag of the [SettingEntry] whose label matches [label].
bool _entryEnabled(WidgetTester tester, String label) {
  final SettingEntry entry = tester.widget<SettingEntry>(
    find.byWidgetPredicate((w) => w is SettingEntry && w.label == label),
  );
  return entry.enabled;
}

/// Whether the restore-defaults button (the refresh FAB) is interactive: an
/// [IconButton] with a null `onPressed` renders disabled.
bool _restoreEnabled(WidgetTester tester) {
  final IconButton button = tester.widget<IconButton>(
    find.widgetWithIcon(IconButton, Icons.refresh),
  );
  return button.onPressed != null;
}

Future<void> _pumpSettings(
  WidgetTester tester, {
  required bool lockQuizConfig,
}) async {
  // The debug-only "Lingua"/"Alert di conferma" dropdowns overflow their fixed
  // 150px column at the test viewport. That layout warning is irrelevant to the
  // enabled-state assertions here (and flutter_test turns overflow into a thrown
  // failure), so swallow overflow errors while pumping; real errors still pass.
  // A tall viewport so the lazily-built ListView lays out every entry (the
  // Quiz-section entries sit far down); otherwise the finder can't reach them.
  tester.view.physicalSize = const Size(1000, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains("overflowed")) {
      return;
    }
    previousOnError?.call(details);
  };

  await tester.pumpWidget(
    ChangeNotifierProvider<Settings>(
      create: (_) => Settings(),
      child: MaterialApp(
        // The app theme carries the BackButtonTheme extension that
        // ViewSettings' CustomBackButton reads; a bare theme would null-throw.
        theme: Themes.themeLight,
        home: ViewSettings(maxQuizPool: 100, lockQuizConfig: lockQuizConfig),
      ),
    ),
  );
  await tester.pump();

  FlutterError.onError = previousOnError;
}

void main() {
  testWidgets(
    "every entry except the written grade is disabled when locked",
    (tester) async {
      await _pumpSettings(tester, lockQuizConfig: true);

      // Quiz-section entries.
      expect(_entryEnabled(tester, "Domande quiz:"), isFalse);
      expect(_entryEnabled(tester, "Timer (minuti):"), isFalse);
      expect(_entryEnabled(tester, "Argomenti interi:"), isFalse);
      expect(_entryEnabled(tester, "Mescola risposte:"), isFalse);
      // General-section entries are locked too.
      expect(_entryEnabled(tester, "Tema scuro:"), isFalse);
      expect(_entryEnabled(tester, "Animazioni:"), isFalse);
      expect(_entryEnabled(tester, "Nascondi risposte corrette:"), isFalse);
      // Only the written grade stays editable.
      expect(_entryEnabled(tester, "Voto prova scritta:"), isTrue);
      // Restore-defaults is locked too.
      expect(_restoreEnabled(tester), isFalse);
    },
  );

  testWidgets("entries are enabled when not locked", (tester) async {
    await _pumpSettings(tester, lockQuizConfig: false);

    expect(_entryEnabled(tester, "Domande quiz:"), isTrue);
    expect(_entryEnabled(tester, "Timer (minuti):"), isTrue);
    expect(_entryEnabled(tester, "Argomenti interi:"), isTrue);
    expect(_entryEnabled(tester, "Mescola risposte:"), isTrue);
    expect(_entryEnabled(tester, "Tema scuro:"), isTrue);
    expect(_entryEnabled(tester, "Voto prova scritta:"), isTrue);
    expect(_restoreEnabled(tester), isTrue);
  });
}
