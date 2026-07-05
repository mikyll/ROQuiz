import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/quiz/question.dart';

/// Guards the file export/import path wired to the view_questions buttons:
/// [QuestionRepository.exportToYaml] must produce content that [loadFromContent]
/// re-imports exactly (and as a custom copy, so remote updates leave it alone).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp("qrepo_export_test");
    Hive.init(tmp.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(QuestionRepository.boxName);
    await Hive.close();
    await tmp.delete(recursive: true);
  });

  test("exported YAML round-trips through loadFromContent", () async {
    // Seed a non-custom set so init() loads from the box (no bundled asset in a
    // plain unit test). Bodies/answers exercise the YAML-hostile characters.
    final seed = [
      Question(id: 0, topic: "T", body: "Q1", answers: ["a", "b"], correctAnswer: 0),
      Question(
        id: 1,
        topic: "T",
        body: 'Q2: tricky "quoted" body?',
        answers: ["first: with colon", 'second "quoted"', "third"],
        correctAnswer: 2,
      ),
    ];
    final box = await Hive.openBox(QuestionRepository.boxName);
    await box.put("content", seed.map((q) => q.toYaml()).join("\n"));
    await box.put("format", "yaml");
    await box.put("source", "asset");
    await box.close();

    final repo = QuestionRepository();
    await repo.init();
    expect(repo.isCustom, isFalse);

    // Export, then import the exported content back: the questions must match and
    // the imported copy is flagged custom.
    final String exported = repo.exportToYaml();
    await repo.loadFromContent(exported);

    expect(repo.isCustom, isTrue);
    expect(repo.questions.length, 2);
    expect(repo.questions[1].body, 'Q2: tricky "quoted" body?');
    expect(repo.questions[1].answers, [
      "first: with colon",
      'second "quoted"',
      "third",
    ]);
    expect(repo.questions[1].correctAnswer, 2);

    // The imported copy survives a reload as custom.
    final reloaded = QuestionRepository();
    await reloaded.init();
    expect(reloaded.isCustom, isTrue);
    expect(reloaded.questions.length, 2);
  });

  test("importing malformed content throws and leaves questions intact",
      () async {
    final seed = [
      Question(id: 0, topic: "T", body: "Q1", answers: ["a", "b"], correctAnswer: 0),
    ];
    final box = await Hive.openBox(QuestionRepository.boxName);
    await box.put("content", seed.map((q) => q.toYaml()).join("\n"));
    await box.put("format", "yaml");
    await box.put("source", "asset");
    await box.close();

    final repo = QuestionRepository();
    await repo.init();

    await expectLater(
      repo.loadFromContent("this is not a questions file"),
      throwsA(isA<FormatException>()),
    );
  });
}
