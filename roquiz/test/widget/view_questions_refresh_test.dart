import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/style/themes.dart';
import 'package:roquiz/view/view_questions.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/select_all_checkbox.dart';

/// Drives the real edit flow to prove that, after editing auto-saves on exit,
/// the underlying [ViewQuestions] list reflects the change (the bug report:
/// "going back to view_questions, these are still not updated").
void main() {
  Widget harness(QuestionRepository repo) {
    return ChangeNotifierProvider<Settings>.value(
      value: Settings(),
      child: MaterialApp(
        theme: Themes.themeLight,
        home: ViewQuestions(questions: repo.questions, repository: repo),
      ),
    );
  }

  testWidgets("ViewQuestions reflects edits made in the editor", (tester) async {
    final repo = QuestionRepository();
    repo.questions = [
      Question(id: 0, topic: "T", body: "First question", answers: ["a", "b"], correctAnswer: 0),
      Question(id: 1, topic: "T", body: "Second question", answers: ["a", "b"], correctAnswer: 1),
    ];

    await tester.pumpWidget(harness(repo));
    await tester.pumpAndSettle();

    expect(find.text("First question"), findsOneWidget);
    expect(find.text("Second question"), findsOneWidget);

    // Open the editor.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Select all, then delete — a change the editor should auto-save on exit.
    await tester.tap(find.byType(SelectAllCheckbox));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Leave the editor via the system back gesture (routes through PopScope).
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // Back on ViewQuestions: the deleted questions must be gone.
    expect(repo.questions, isEmpty);
    expect(find.text("First question"), findsNothing);
    expect(find.text("Second question"), findsNothing);
  });

  testWidgets("ViewQuestions reflects edits when leaving via the back button", (
    tester,
  ) async {
    final repo = QuestionRepository();
    repo.questions = [
      Question(id: 0, topic: "T", body: "First question", answers: ["a", "b"], correctAnswer: 0),
      Question(id: 1, topic: "T", body: "Second question", answers: ["a", "b"], correctAnswer: 1),
    ];

    await tester.pumpWidget(harness(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SelectAllCheckbox));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Leave via the on-screen back button (the editor's, i.e. the topmost).
    await tester.tap(find.byType(CustomBackButton).last);
    await tester.pumpAndSettle();

    expect(repo.questions, isEmpty);
    expect(find.text("First question"), findsNothing);
    expect(find.text("Second question"), findsNothing);
  });

  testWidgets("ViewQuestions shows a question added in the editor", (
    tester,
  ) async {
    final repo = QuestionRepository();
    repo.questions = [
      Question(id: 0, topic: "T", body: "First question", answers: ["a", "b"], correctAnswer: 0),
    ];

    await tester.pumpWidget(harness(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Open the add dialog and fill it in.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, "Corpo"),
      "Brand new question",
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, "Risposta 1"),
      "answer one",
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, "Risposta 2"),
      "answer two",
    );
    await tester.pumpAndSettle();
    // Mark the first answer correct.
    await tester.tap(find.byIcon(Icons.radio_button_off).first);
    await tester.pumpAndSettle();
    // Confirm.
    await tester.tap(find.widgetWithText(ElevatedButton, "Conferma"));
    await tester.pumpAndSettle();

    // Leave the editor.
    await tester.tap(find.byType(CustomBackButton).last);
    await tester.pumpAndSettle();

    expect(repo.questions.length, 2);
    expect(find.text("Brand new question"), findsOneWidget);

    // Regression: searching after the edit must operate on the refreshed set,
    // not the stale original list. The added question must be findable and the
    // total (denominator) must reflect the new count.
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "Brand");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text("Brand new question"), findsOneWidget);
    expect(find.textContaining("Trovate: 1/2"), findsOneWidget);
  });
}
