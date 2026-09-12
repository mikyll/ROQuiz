import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/widget/confirmation_dialog.dart';

/// Pumps a button that calls [maybeConfirm] and records its result.
Future<bool?> _run(
  WidgetTester tester, {
  required ConfirmationLevel userLevel,
  required ConfirmationLevel minLevel,
}) async {
  bool? result;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await maybeConfirm(
                context,
                userLevel: userLevel,
                minLevel: minLevel,
                title: "T",
                message: "M",
              );
            },
            child: const Text("go"),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text("go"));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  testWidgets('below threshold proceeds without showing a dialog', (
    tester,
  ) async {
    final result = await _run(
      tester,
      userLevel: ConfirmationLevel.none,
      minLevel: ConfirmationLevel.soft,
    );
    expect(find.byType(AlertDialog), findsNothing);
    expect(result, isTrue);
  });

  testWidgets('at/above threshold shows a dialog; confirm returns true', (
    tester,
  ) async {
    await _run(
      tester,
      userLevel: ConfirmationLevel.soft,
      minLevel: ConfirmationLevel.soft,
    );
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text("Conferma"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('full-tier site does not prompt a soft user', (tester) async {
    final result = await _run(
      tester,
      userLevel: ConfirmationLevel.soft,
      minLevel: ConfirmationLevel.full,
    );
    expect(find.byType(AlertDialog), findsNothing);
    expect(result, isTrue);
  });

  testWidgets('cancel returns false', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await maybeConfirm(
                  context,
                  userLevel: ConfirmationLevel.full,
                  minLevel: ConfirmationLevel.soft,
                  title: "T",
                  message: "M",
                );
              },
              child: const Text("go"),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text("go"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Annulla"));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });
}
