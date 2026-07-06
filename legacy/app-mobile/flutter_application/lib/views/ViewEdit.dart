import 'package:flutter/material.dart';
import 'package:roquiz/persistence/QuestionRepository.dart';
import 'package:roquiz/model/Themes.dart';
import 'package:roquiz/persistence/Settings.dart';
import 'package:roquiz/widget/confirmation_alert.dart';
import 'package:roquiz/widget/icon_button_widget.dart';

class ViewEdit extends StatefulWidget {
  const ViewEdit({
    super.key,
    required this.qRepo,
    required this.settings,
    required this.reloadTopics,
    required this.updateQuizDefaults,
  });

  final QuestionRepository qRepo;
  final Settings settings;
  final Function() reloadTopics;
  final Function() updateQuizDefaults;

  @override
  State<StatefulWidget> createState() => ViewEditState();
}

const double BUTTON_SIZE = 48.0;
const double ICON_SIZE = 40.0;

class ViewEditState extends State<ViewEdit> {
  String _initialContent = "";
  bool _isChanged = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  void _loadFromFile() {
    widget.qRepo.loadString().then(
      (content) {
        setState(() {
          _initialContent = content;
          _textController.text = content;
          _isChanged = false;
        });
      },
    ).onError((error, stackTrace) {
      print("ERROR: ${error.toString()}");
    });
  }

  void _save() async {
    String content = _textController.text;

    int res;
    String err;
    (res, err) = QuestionRepository.isValidErrors(content);
    if (res > 0) {
      widget.qRepo.updateQuestionsDate(QuestionRepository.CUSTOM_DATE);
      await widget.qRepo.updateQuestionsFile(content);

      widget.reloadTopics();
      widget.updateQuizDefaults();
      setState(() {
        _initialContent = _textController.text;
        _isChanged = false;
      });
    } else {
      // TO-DO: Jump to error line
      /*if (_scrollController.hasClients) {
        _scrollController.animateTo(errorLine,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }*/
    }

    ConfirmationAlert.showConfirmationDialog(
      context,
      res > 0 ? "File Aggiornato" : "Errore di formattazione",
      res > 0
          ? "Il file domande personalizzato è stato aggiornato correttamente.\n"
              "Numero domande: $res"
          : err,
      confirmButton: "",
      cancelButton: "Ok",
      onConfirm: null,
      onCancel: () {},
    );
  }

  void _reload() {
    if (_isChanged) {
      ConfirmationAlert.showConfirmationDialog(
        context,
        "Modifiche in Corso",
        "Ricaricare il file sovrascriverà tutte le modifiche effettuate finora.\n"
            "continuare?",
        onConfirm: () {
          _loadFromFile();
        },
        onCancel: () {},
      );
    }
  }

  void _validate() async {
    String content = _textController.text;

    int res;
    String err;
    (res, err) = QuestionRepository.isValidErrors(content);

    ConfirmationAlert.showConfirmationDialog(
      context,
      res >= 1
          ? "Formattazione Valida"
          : (res == 0 ? "File Vuoto" : "Errore di Formattazione"),
      res >= 1
          ? "Il file è formattato correttamente.\nNumero domande: $res"
          : err,
      confirmButton: "",
      cancelButton: "Ok",
      onConfirm: null,
      onCancel: () {},
    );
  }

  void _showBackConfirmDialog() {
    ConfirmationAlert.showConfirmationDialog(
      context,
      "Modifiche Non Salvate",
      "Uscire senza salvare?",
      onConfirm: () {
        Navigator.pop(context);
      },
      onCancel: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFromFile();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !(_isChanged && widget.settings.confirmAlerts),
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        _showBackConfirmDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Modifica"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (_isChanged && widget.settings.confirmAlerts) {
                _showBackConfirmDialog();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 8.0, right: 8.0, bottom: 100.0),
            child: Scrollbar(
              interactive: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration.collapsed(hintText: ""),
                  onChanged: (_) {
                    setState(() {
                      _isChanged = _initialContent != _textController.text;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              // Save
              IconButtonWidget(
                onTap: !_isChanged
                    ? null
                    : () {
                        _save();
                      },
                lightPalette: MyThemes.lightIconButtonPalette,
                darkPalette: MyThemes.darkIconButtonPalette,
                width: BUTTON_SIZE,
                height: BUTTON_SIZE,
                icon: Icons.save,
                iconSize: ICON_SIZE,
                borderRadius: 5,
              ),
              const SizedBox(width: 10.0),
              // Reload
              IconButtonWidget(
                onTap: !_isChanged
                    ? null
                    : () {
                        _reload();
                      },
                lightPalette: MyThemes.lightIconButtonPalette,
                darkPalette: MyThemes.darkIconButtonPalette,
                width: BUTTON_SIZE,
                height: BUTTON_SIZE,
                icon: Icons.replay_outlined,
                iconSize: ICON_SIZE,
                borderRadius: 5,
              ),
              const SizedBox(width: 10.0),
              // Validate
              IconButtonWidget(
                onTap: () {
                  _validate();
                },
                lightPalette: MyThemes.lightIconButtonPalette,
                darkPalette: MyThemes.darkIconButtonPalette,
                width: BUTTON_SIZE,
                height: BUTTON_SIZE,
                icon: Icons.checklist,
                iconSize: ICON_SIZE,
                borderRadius: 5,
              ),
              const Spacer(),
              // Delete last action
              IconButtonWidget(
                onTap: null, //() {print("TO-DO");},
                lightPalette: MyThemes.lightIconButtonPalette,
                darkPalette: MyThemes.darkIconButtonPalette,
                width: BUTTON_SIZE,
                height: BUTTON_SIZE,
                icon: Icons.undo,
                iconSize: ICON_SIZE,
                borderRadius: 5,
              ),
              const SizedBox(width: 10.0),
              // Restore last action
              IconButtonWidget(
                onTap: null, //() {print("TO-DO");},
                lightPalette: MyThemes.lightIconButtonPalette,
                darkPalette: MyThemes.darkIconButtonPalette,
                width: BUTTON_SIZE,
                height: BUTTON_SIZE,
                icon: Icons.redo,
                iconSize: ICON_SIZE,
                borderRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
