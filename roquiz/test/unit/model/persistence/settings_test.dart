import 'package:flutter_test/flutter_test.dart';
import 'package:roquiz/model/persistence/settings.dart';

void main() {
  group('confirmationLevel', () {
    test('defaults to soft', () {
      expect(Settings().confirmationLevel, ConfirmationLevel.soft);
    });

    test('round-trips through JSON for every level', () {
      for (final level in ConfirmationLevel.values) {
        final Settings restored = Settings.fromJson(
          (Settings()..confirmationLevel = level).toJson(),
        );
        expect(restored.confirmationLevel, level);
      }
    });

    test('legacy installs (old confirmationAlert key) fall back to soft', () {
      // Pre-migration settings stored a bool under `confirmationAlert` and had
      // no `confirmationLevel` key. The new key is absent, so it defaults.
      final Settings migrated = Settings.fromJson({'confirmationAlert': true});
      expect(migrated.confirmationLevel, ConfirmationLevel.soft);
    });

    test('restoreDefaults resets the level to soft', () {
      final Settings settings = Settings()
        ..confirmationLevel = ConfirmationLevel.none;
      settings.restoreDefaults();
      expect(settings.confirmationLevel, ConfirmationLevel.soft);
    });
  });
}
