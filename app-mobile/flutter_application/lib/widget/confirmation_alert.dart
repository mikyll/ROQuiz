import 'package:flutter/material.dart';

class ConfirmationAlert extends StatelessWidget {
  const ConfirmationAlert(
      {Key? key,
      this.onConfirm,
      this.onCancel,
      required this.title,
      required this.content})
      : super(key: key);

  final String title;
  final String content;
  final Function? onConfirm;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text("Conferma"),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }
          },
        ),
        TextButton(
          child: const Text("Annulla"),
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
          },
        ),
      ],
    );
  }
}
