import 'package:flutter/material.dart';
import 'package:roquiz/model/edit_question/commands/custom_command.dart';
import 'package:roquiz/model/edit_question/question_command_executor.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:roquiz/widget/question_dialog.dart';
import 'package:roquiz/widget/separator.dart';

class ViewQuestionsEditFile extends StatefulWidget {
  const ViewQuestionsEditFile({super.key, required this.fileContent});

  final String fileContent;

  @override
  State<StatefulWidget> createState() => _ViewQuestionsEditFileState();
}

class _ViewQuestionsEditFileState extends State<ViewQuestionsEditFile> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onPopInvoked: (_) {
      //   // todo
      // },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Modifica File"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
              backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700.0),
              child: Text("todo"),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.0,
            children: [
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Salva le domande",
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.save),
                  iconSize: 35,
                ),
              ),
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Valida le domande",
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.checklist),
                  iconSize: 35,
                ),
              ),
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Ripristina",
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.refresh),
                  iconSize: 35,
                ),
              ),
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Annulla l'ultima azione",
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.undo),
                  iconSize: 35,
                ),
              ),
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Ripeti l'ultima azione",
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.redo),
                  iconSize: 35,
                ),
              ),
              // Import questions from a file
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Importa le domande da un file",
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.file_open_outlined),
                  iconSize: 35,
                ),
              ),
              // Export questions file
              Tooltip(
                waitDuration: Duration(milliseconds: 500),
                message: "Esporta il file delle domande",
                child: IconButton(
                  onPressed: null,
                  // TODO: cercare altra icona?
                  icon: Icon(Icons.file_download_outlined),
                  iconSize: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
