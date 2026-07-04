import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/quiz/question.dart';

/// Drives the Option-B remote-update policy without real network access:
///   - a non-custom file (asset/remote) is auto-updated when the remote is newer;
///   - a custom file is never overwritten — it only flags [isUpdateAvailable],
///     which the user resolves with [applyRemoteUpdate] / [dismissRemoteUpdate].
/// Also covers migration of pre-[QuestionSource] boxes (the legacy `custom` bool).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp("qrepo_update_test");
    Hive.init(tmp.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(QuestionRepository.boxName);
    await Hive.close();
    await tmp.delete(recursive: true);
  });

  final localQuestions = [
    Question(id: 0, topic: "T", body: "Local Q", answers: ["a", "b"], correctAnswer: 0),
  ];

  // A valid remote file (the remote source is Domande.txt — TXT format).
  const remoteTxt = "@Remote ===\n"
      "Remote Q?\n"
      "A. first\n"
      "B. second\n"
      "B\n";

  /// A [MockClient] that answers the GitHub commits API with [commitDate] and
  /// serves [remoteTxt] as the raw questions file.
  http.Client mockRemote(DateTime commitDate) {
    return MockClient((request) async {
      if (request.url.host == "api.github.com") {
        return http.Response(
          jsonEncode([
            {
              "commit": {
                "committer": {"date": commitDate.toUtc().toIso8601String()},
              },
            },
          ]),
          200,
        );
      }
      if (request.url.host == "raw.githubusercontent.com") {
        return http.Response(remoteTxt, 200);
      }
      return http.Response("not found", 404);
    });
  }

  /// Seeds the box with a saved copy so init() never needs the bundled asset.
  Future<void> seedBox({
    required String source,
    DateTime? currentFileDate,
    DateTime? lastKnownRemoteDate,
    List<Question>? questions,
    bool? legacyCustom,
  }) async {
    final box = await Hive.openBox(QuestionRepository.boxName);
    await box.put(
      "content",
      (questions ?? localQuestions).map((q) => q.toYaml()).join("\n"),
    );
    await box.put("format", "yaml");
    if (source.isNotEmpty) await box.put("source", source);
    if (currentFileDate != null) {
      await box.put("lastUpdate", currentFileDate.toIso8601String());
    }
    if (lastKnownRemoteDate != null) {
      await box.put("lastKnownRemoteDate", lastKnownRemoteDate.toIso8601String());
    }
    if (legacyCustom != null) await box.put("custom", legacyCustom);
    await box.close();
  }

  group("migration from legacy boxes", () {
    test("legacy custom:true migrates to a custom source", () async {
      await seedBox(source: "", legacyCustom: true);
      final repo = QuestionRepository();
      await repo.init();
      expect(repo.source, QuestionSource.custom);
      expect(repo.isCustom, isTrue);
    });

    test("legacy non-epoch date (no custom flag) migrates to remote", () async {
      await seedBox(
        source: "",
        legacyCustom: false,
        currentFileDate: DateTime.utc(2024),
      );
      final repo = QuestionRepository();
      await repo.init();
      expect(repo.source, QuestionSource.remote);
      expect(repo.isCustom, isFalse);
    });
  });

  group("non-custom file auto-updates", () {
    test("a newer remote is downloaded and applied", () async {
      await seedBox(source: "remote", currentFileDate: DateTime.utc(2020));
      final repo = QuestionRepository(client: mockRemote(DateTime.utc(2026)));
      await repo.init();

      final applied = await repo.checkForRemoteUpdate();
      expect(applied, isTrue);
      expect(repo.source, QuestionSource.remote);
      expect(repo.questions.length, 1);
      expect(repo.questions.single.body, "Remote Q?");
      expect(repo.lastQuestionUpdate, DateTime.utc(2026));
    });

    test("an up-to-date file is left untouched", () async {
      await seedBox(source: "remote", currentFileDate: DateTime.utc(2026));
      final repo = QuestionRepository(client: mockRemote(DateTime.utc(2020)));
      await repo.init();

      final applied = await repo.checkForRemoteUpdate();
      expect(applied, isFalse);
      expect(repo.questions.single.body, "Local Q");
    });
  });

  group("asset fallback and error surfacing (requirement 1)", () {
    test("no saved copy falls back to the asset silently", () async {
      final repo = QuestionRepository();
      await repo.init();
      expect(repo.source, QuestionSource.asset);
      expect(repo.questions, isNotEmpty);
      expect(repo.lastLoadError, isNull);
    });

    test("a corrupt saved copy falls back to the asset AND surfaces an error, "
        "without destroying the corrupt blob", () async {
      final box = await Hive.openBox(QuestionRepository.boxName);
      await box.put("content", "this is not a question list");
      await box.put("format", "yaml");
      await box.put("source", "custom");
      await box.close();

      final repo = QuestionRepository();
      await repo.init();
      expect(repo.source, QuestionSource.asset);
      expect(repo.questions, isNotEmpty, reason: "asset fallback loaded");
      expect(repo.lastLoadError, isNotNull, reason: "error must be surfaced");

      // The unreadable blob is preserved (not overwritten by the asset).
      final reopened = await Hive.openBox(QuestionRepository.boxName);
      expect(reopened.get("content"), "this is not a question list");
      await reopened.close();
    });
  });

  group("custom file is never overwritten", () {
    test("checkForRemoteUpdate only flags, keeping the custom set", () async {
      await seedBox(source: "custom");
      final repo = QuestionRepository(client: mockRemote(DateTime.utc(2026)));
      await repo.init();

      final applied = await repo.checkForRemoteUpdate();
      expect(applied, isFalse, reason: "must never auto-apply over custom");
      expect(repo.isUpdateAvailable, isTrue);
      expect(repo.isCustom, isTrue);
      expect(repo.questions.single.body, "Local Q");
    });

    test("applyRemoteUpdate switches to the remote copy", () async {
      await seedBox(source: "custom");
      final repo = QuestionRepository(client: mockRemote(DateTime.utc(2026)));
      await repo.init();
      await repo.checkForRemoteUpdate();

      await repo.applyRemoteUpdate();
      expect(repo.isUpdateAvailable, isFalse);
      expect(repo.source, QuestionSource.remote);
      expect(repo.isCustom, isFalse);
      expect(repo.questions.single.body, "Remote Q?");
    });

    test("dismissRemoteUpdate keeps the custom set and stops re-flagging", () async {
      await seedBox(source: "custom");
      final repo = QuestionRepository(client: mockRemote(DateTime.utc(2026)));
      await repo.init();
      await repo.checkForRemoteUpdate();
      expect(repo.isUpdateAvailable, isTrue);

      await repo.dismissRemoteUpdate();
      expect(repo.isUpdateAvailable, isFalse);
      expect(repo.isCustom, isTrue);
      expect(repo.questions.single.body, "Local Q");

      // A fresh repository over the same box must not re-flag the same commit.
      final reloaded = QuestionRepository(client: mockRemote(DateTime.utc(2026)));
      await reloaded.init();
      final applied = await reloaded.checkForRemoteUpdate();
      expect(applied, isFalse);
      expect(reloaded.isUpdateAvailable, isFalse);

      // But a still-newer commit flags anew.
      final newer = QuestionRepository(client: mockRemote(DateTime.utc(2027)));
      await newer.init();
      await newer.checkForRemoteUpdate();
      expect(newer.isUpdateAvailable, isTrue);
    });
  });
}
