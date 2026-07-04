import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/question_repository.dart';
import 'package:roquiz/model/utils/time.dart';

/// Drives the remote questions-update UX shared by the startup check
/// ([ViewMenu]) and the manual "check for updates" button ([ViewQuestions]), so
/// both behave identically: it detects a newer official file, shows a dialog
/// comparing the current and available versions, and downloads on confirm.
///
/// [onApplied] runs after a successful download so the caller can refresh its own
/// view. [manual] tells apart the two entry points:
///   - manual (button): also confirms "already up to date", surfaces errors, and
///     — for a custom set with no newer official commit — still offers to restore
///     the official set (the only in-app way back off a custom set);
///   - non-manual (silent startup check): stays quiet unless there is genuinely a
///     newer official file to offer, and swallows network errors.
Future<void> runQuestionsUpdateFlow(
  BuildContext context,
  QuestionRepository repository, {
  required VoidCallback onApplied,
  bool manual = false,
}) async {
  final RemoteQuestionsInfo info;
  try {
    info = await repository.peekRemoteUpdate();
  } catch (_) {
    // Offline / API error: keep the questions we already have.
    if (manual && context.mounted) {
      _snack(context, "Impossibile controllare gli aggiornamenti.");
    }
    return;
  }

  if (!context.mounted) {
    return;
  }

  if (repository.isCustom) {
    if (info.isNewer) {
      // A newer official set exists: offer it (declining records it as seen so
      // the background check stops nagging about this commit).
      await _confirmReplaceCustom(
        context,
        repository,
        info.remoteDate,
        onApplied: onApplied,
        newer: true,
      );
    } else if (manual) {
      // Nothing newer, but the user explicitly asked: let them restore the
      // official set anyway.
      await _confirmReplaceCustom(
        context,
        repository,
        info.remoteDate,
        onApplied: onApplied,
        newer: false,
      );
    }
    return;
  }

  // Non-custom (asset/remote): only act when the remote is strictly newer, and
  // confirm before replacing.
  if (info.isNewer) {
    await _confirmUpdateNonCustom(
      context,
      repository,
      info.remoteDate,
      onApplied: onApplied,
    );
  } else if (manual) {
    _snack(context, "Le domande sono già aggiornate.");
  }
}

/// The current-version line for a non-custom set: the bundled asset has no
/// meaningful datetime, so it is shown as "integrata" rather than the epoch.
String _currentVersionLabel(QuestionRepository repository) {
  switch (repository.source) {
    case QuestionSource.asset:
      return "integrata";
    case QuestionSource.remote:
      return getDateString(repository.lastQuestionUpdate);
    case QuestionSource.custom:
      return "personalizzata";
  }
}

Future<void> _confirmUpdateNonCustom(
  BuildContext context,
  QuestionRepository repository,
  DateTime remoteDate, {
  required VoidCallback onApplied,
}) async {
  final apply = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Aggiornamento disponibile"),
      content: Text(
        "È disponibile una versione più recente delle domande.\n\n"
        "Versione attuale: ${_currentVersionLabel(repository)}\n"
        "Nuova versione: ${getDateString(remoteDate)}",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Annulla"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Aggiorna"),
        ),
      ],
    ),
  );

  if (apply == true && context.mounted) {
    await _download(context, repository, remoteDate, onApplied: onApplied);
  }
}

Future<void> _confirmReplaceCustom(
  BuildContext context,
  QuestionRepository repository,
  DateTime remoteDate, {
  required VoidCallback onApplied,
  required bool newer,
}) async {
  final apply = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(newer ? "Aggiornamento disponibile" : "Domande ufficiali"),
      content: Text(
        newer
            ? "È disponibile una versione più recente del set di domande "
                  "ufficiale. Scaricarla sostituirà le tue domande "
                  "personalizzate.\n\n"
                  "Versione ufficiale: ${getDateString(remoteDate)}"
            : "Stai usando domande personalizzate. Vuoi sostituirle con le "
                  "domande ufficiali?\n\n"
                  "Versione ufficiale: ${getDateString(remoteDate)}",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(newer ? "Ignora" : "Annulla"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(newer ? "Aggiorna" : "Sostituisci"),
        ),
      ],
    ),
  );

  if (apply == true && context.mounted) {
    await _download(context, repository, remoteDate, onApplied: onApplied);
  } else if (apply == false && newer) {
    // Only a strictly-newer commit needs recording as seen (so it isn't offered
    // again); an explicit "no thanks" to a restore leaves everything as-is.
    await repository.markRemoteSeen(remoteDate);
  }
}

Future<void> _download(
  BuildContext context,
  QuestionRepository repository,
  DateTime commitDate, {
  required VoidCallback onApplied,
}) async {
  try {
    await repository.downloadFromRemote(commitDate: commitDate);
  } catch (_) {
    if (context.mounted) {
      _snack(context, "Impossibile scaricare l'aggiornamento.");
    }
    return;
  }
  if (context.mounted) {
    onApplied();
    _snack(context, "Domande aggiornate.");
  }
}

void _snack(BuildContext context, String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}
