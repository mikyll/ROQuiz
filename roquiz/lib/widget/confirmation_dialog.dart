import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/settings.dart';

/// Shows a yes/no confirmation dialog only when the user's [userLevel] is at or
/// above [minLevel]; below that threshold it returns `true` immediately so the
/// action proceeds without interrupting the user.
///
/// Assign each call site the lowest tier at which it should still prompt:
///  - [ConfirmationLevel.soft] for irreversible data loss (delete/clear/reset);
///  - [ConfirmationLevel.full] for losing in-progress work (leaving a quiz,
///    terminating with unanswered questions).
///
/// Decision prompts that ask *what* to do rather than *whether* to proceed
/// (e.g. import merge-vs-overwrite) are not confirmations and should not go
/// through this helper — they must always be shown.
Future<bool> maybeConfirm(
  BuildContext context, {
  required ConfirmationLevel userLevel,
  required ConfirmationLevel minLevel,
  required String title,
  required String message,
  String confirmLabel = "Conferma",
  String cancelLabel = "Annulla",
}) async {
  if (userLevel.index < minLevel.index) {
    return true;
  }

  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  return confirmed ?? false;
}
