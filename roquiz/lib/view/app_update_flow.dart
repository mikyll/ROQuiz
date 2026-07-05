import 'package:flutter/material.dart';
import 'package:roquiz/model/notification/app_version.dart';
import 'package:roquiz/model/utils/navigation.dart';

/// Drives the app release-update UX (sibling of [runQuestionsUpdateFlow]): it
/// checks GitHub for a newer release and, on confirm, opens the release page so
/// the user can download it.
///
/// [manual] tells apart the entry points:
///   - manual: also confirms "already up to date" and surfaces errors;
///   - non-manual (silent startup check): only speaks up when a newer release
///     exists, and swallows network errors so startup can't be disturbed.
Future<void> runAppUpdateFlow(
  BuildContext context,
  AppReleaseChecker checker,
  String currentVersion, {
  bool manual = false,
}) async {
  final AppRelease release;
  try {
    release = await checker.checkForUpdate(currentVersion);
  } catch (_) {
    // Offline / API error: nothing to do but keep quiet (unless asked).
    if (manual && context.mounted) {
      _snack(context, "Impossibile controllare gli aggiornamenti dell'app.");
    }
    return;
  }

  if (!context.mounted) {
    return;
  }

  if (release.isNewer) {
    final open = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Aggiornamento disponibile"),
        content: Text(
          "È disponibile una versione più recente dell'app.\n\n"
          "Versione attuale: $currentVersion\n"
          "Nuova versione: ${release.version}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Scarica"),
          ),
        ],
      ),
    );
    if (open == true) {
      openUrl(release.url);
    }
  } else if (manual) {
    _snack(context, "L'app è già aggiornata.");
  }
}

void _snack(BuildContext context, String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}
