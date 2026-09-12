import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/quiz/question.dart';

/// End-to-end check of the "persist user edits" path: [QuestionRepository.
/// saveQuestions] must write the working set to the Hive box such that a fresh
/// repository reloads it exactly (and as a custom copy, so remote updates leave
/// it alone).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp("qrepo_persist_test");
    Hive.init(tmp.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(QuestionRepository.boxName);
    await Hive.close();
    await tmp.delete(recursive: true);
  });

  test("edited questions persist across repository reloads", () async {
    // Seed the box with a non-custom set so init() loads from the box and never
    // needs the bundled asset (unavailable in a plain unit test).
    final seed = [
      Question(id: 0, topic: "T", body: "Q1", answers: ["a", "b"], correctAnswer: 0),
      Question(id: 1, topic: "T", body: "Q2", answers: ["a", "b", "c"], correctAnswer: 2),
    ];
    final box = await Hive.openBox(QuestionRepository.boxName);
    await box.put("content", seed.map((q) => q.toYaml()).join("\n"));
    await box.put("format", "yaml");
    await box.put("custom", false);
    await box.close();

    final repo = QuestionRepository();
    await repo.init();
    expect(repo.questions.length, 2);
    expect(repo.isCustom, isFalse);

    // Simulate an editing session: add a question whose text exercises the
    // YAML-hostile characters (colon-space, quotes).
    final edited = List<Question>.from(repo.questions)
      ..add(
        Question(
          id: 2,
          topic: "T",
          body: 'Custom Q: tricky "quoted" body?',
          answers: ["first: with colon", 'second "quoted"', "third"],
          correctAnswer: 1,
        ),
      );
    await repo.saveQuestions(edited);
    expect(repo.isCustom, isTrue);

    // A brand-new repository over the same box must reload the saved edits.
    final reloaded = QuestionRepository();
    await reloaded.init();
    expect(reloaded.isCustom, isTrue);
    expect(reloaded.questions.length, 3);
    expect(reloaded.questions.last.body, 'Custom Q: tricky "quoted" body?');
    expect(reloaded.questions.last.answers, [
      "first: with colon",
      'second "quoted"',
      "third",
    ]);
    expect(reloaded.questions.last.correctAnswer, 1);
  });
}
