import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/quiz_repository.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/grade.dart';
import 'package:roquiz/model/utils/time.dart';
import 'package:roquiz/view/view_history_quiz.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({super.key, required this.quizRepository});

  final QuizRepository quizRepository;

  @override
  State<StatefulWidget> createState() => ViewHistoryState();
}

class ViewHistoryState extends State<ViewHistory> {
  final ScrollController _scrollController = ScrollController();
  late List<QuizCompleted> _quizList;

  @override
  void initState() {
    super.initState();
    _quizList = List.of(widget.quizRepository.quizList);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _removeQuiz(int index) {
    widget.quizRepository.remove(_quizList[index]);
    setState(() {
      _quizList.removeAt(index);
    });
  }

  void _clearHistory() {
    widget.quizRepository.clear();
    setState(() {
      _quizList.clear();
    });
  }

  Future<void> _confirmClearHistory() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Svuota storico"),
          content: const Text(
            "Vuoi eliminare tutti i quiz salvati? L'operazione non è reversibile.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Elimina"),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      _clearHistory();
    }
  }

  Future<void> _exportHistory() async {
    final String json = widget.quizRepository.exportToJson();
    final DateTime now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, "0");
    // Compact timestamp: roquiz_history_20260619143005
    final String timestamp =
        "${now.year}${two(now.month)}${two(now.day)}"
        "${two(now.hour)}${two(now.minute)}${two(now.second)}";

    await FileSaver.instance.saveFile(
      name: "roquiz_history_$timestamp",
      bytes: Uint8List.fromList(utf8.encode(json)),
      ext: "json",
      mimeType: MimeType.json,
    );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Storico esportato")));
  }

  Future<void> _importHistory() async {
    // Import replaces the whole history, so confirm before discarding anything.
    if (_quizList.isNotEmpty) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Importa storico"),
            content: const Text(
              "L'importazione sostituirà lo storico attuale. Continuare?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annulla"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Continua"),
              ),
            ],
          );
        },
      );
      if (!(confirmed ?? false)) {
        return;
      }
    }

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
      withData: true,
    );
    final Uint8List? bytes = result?.files.first.bytes;
    if (bytes == null) {
      return;
    }

    final int count;
    try {
      count = await widget.quizRepository.importFromJson(utf8.decode(bytes));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("File non valido")));
      return;
    }

    setState(() {
      _quizList = List.of(widget.quizRepository.quizList);
    });

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Importati $count quiz")));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: ConstrainedAppBar(
          maxWidth: 500.0,
          title: Text("Storico Quiz"),
          leading: CustomBackButton(),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _quizList.isEmpty
                    ? Center(child: Text("Nessun quiz completato"))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _quizList.length,
                        itemBuilder: (context, index) {
                          final QuizCompleted q = _quizList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: _QuizCompletedWidget(
                              timestamp: q.timestamp,
                              correctQuestions: q.correctAnswers,
                              totalQuestions: q.questions.length,
                              timeSpent: q.timeSpent,
                              grade: q.grade,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewHistoryQuiz(quizCompleted: q),
                                  ),
                                );
                              },
                              onRemove: () => _removeQuiz(index),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor.withAlpha(70),
          ),
          child: Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.0,
                  children: [
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Importa",
                      child: IconButton(
                        onPressed: _importHistory,
                        icon: Icon(Icons.file_upload),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Esporta",
                      child: IconButton(
                        onPressed: _quizList.isEmpty ? null : _exportHistory,
                        icon: Icon(Icons.file_download),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Svuota",
                      child: IconButton(
                        onPressed: _quizList.isEmpty
                            ? null
                            : _confirmClearHistory,
                        icon: Icon(Icons.delete_sweep),
                        iconSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizCompletedWidget extends StatelessWidget {
  const _QuizCompletedWidget({
    required this.timestamp,
    required this.correctQuestions,
    required this.totalQuestions,
    required this.timeSpent,
    required this.grade,
    this.onTap,
    this.onRemove,
  });

  final DateTime timestamp;
  final int correctQuestions;
  final int totalQuestions;
  final int timeSpent;
  final double grade;
  final void Function()? onTap;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        getGradeString(grade),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      title: Row(
        spacing: 10.0,
        children: [
          Text(timestamp.toString().replaceAll("T", " ").split(".")[0]),
          Text("$correctQuestions/$totalQuestions"),
          Text(getTimeString(timeSpent)),
        ],
      ),
      isThreeLine: false,
      onTap: onTap,
      trailing: InkWell(
        onTap: onRemove,
        child: Icon(Icons.delete, size: 30),
      ),
    );
  }
}
