import 'package:flutter/material.dart';

class ConfirmationAlert extends StatelessWidget {
  const ConfirmationAlert(
      {Key? key,
      this.onConfirm,
      this.onCancel,
      this.buttonConfirmText = "Conferma",
      this.buttonCancelText = "Annulla",
      required this.title,
      required this.content})
      : super(key: key);

  final String title;
  final String content;
  final String buttonConfirmText;
  final String buttonCancelText;
  final Function? onConfirm;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onConfirm != null
              ? () {
                  onConfirm!();
                }
              : null,
          child: Text(buttonConfirmText),
        ),
        TextButton(
          onPressed: onCancel != null
              ? () {
                  onCancel!();
                }
              : null,
          child: Text(buttonCancelText),
        ),
      ],
    );
  }
}
