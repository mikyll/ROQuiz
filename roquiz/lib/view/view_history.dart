import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/quiz_repository.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/grade.dart';
import 'package:roquiz/model/utils/selection_controller.dart';
import 'package:roquiz/model/utils/time.dart';
import 'package:roquiz/view/view_history_quiz.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/select_all_checkbox.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({super.key, required this.quizRepository});

  final QuizRepository quizRepository;

  @override
  State<StatefulWidget> createState() => ViewHistoryState();
}

class ViewHistoryState extends State<ViewHistory> {
  final ScrollController _scrollController = ScrollController();
  late List<QuizCompleted> _quizList;
  late SelectionController _selection;

  @override
  void initState() {
    super.initState();
    _quizList = List.of(widget.quizRepository.quizList);
    _selection = SelectionController(_quizList.length);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      _selection.toggle(index);
    });
  }

  void _clearHistory() {
    widget.quizRepository.clear();
    setState(() {
      _quizList.clear();
      _selection.reset(0);
    });
  }

  void _deleteSelected() {
    final List<QuizCompleted> toRemove = [
      for (final i in _selection.selectedIndices) _quizList[i],
    ];
    widget.quizRepository.removeAll(toRemove);
    setState(() {
      _quizList.removeWhere(toRemove.contains);
      _selection.reset(_quizList.length);
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

  Future<void> _confirmDeleteSelected() async {
    final int count = _selection.count;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Elimina selezionati"),
          content: Text(
            "Vuoi eliminare i $count quiz selezionati? "
            "L'operazione non è reversibile.",
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
      _deleteSelected();
    }
  }

  /// Exports [quizzes] (a user-selected subset) when given, otherwise the whole
  /// history, to a timestamped JSON file.
  Future<void> _exportQuizzes({List<QuizCompleted>? quizzes}) async {
    final String json = widget.quizRepository.exportToJson(quizzes: quizzes);
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
    final String message = quizzes == null
        ? "Storico esportato"
        : "${quizzes.length} quiz esportati";
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _exportSelected() {
    return _exportQuizzes(
      quizzes: [for (final i in _selection.selectedIndices) _quizList[i]],
    );
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

    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
      withData: true,
    );
    // Guard against an empty file list (web cancel/focus race) before .first.
    final Uint8List? bytes = (result != null && result.files.isNotEmpty)
        ? result.files.first.bytes
        : null;
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
      _selection.reset(_quizList.length);
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
          title: Text(
            _selection.hasSelection
                ? "Selezionati: ${_selection.count}/${_selection.length}"
                : "Storico Quiz",
          ),
          leading: CustomBackButton(),
          actions: [
            SelectAllCheckbox(
              value: _selection.allSelected,
              onChanged: _quizList.isEmpty
                  ? null
                  : () => setState(() => _selection.toggleAll()),
            ),
          ],
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
                              isSelected: _selection.isSelected(index),
                              selectionMode: _selection.hasSelection,
                              onSelected: () => _toggleSelection(index),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewHistoryQuiz(quizCompleted: q),
                                  ),
                                );
                              },
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
                        // Import replaces the whole history, so it is only
                        // available when there is no active selection to act on.
                        onPressed: _selection.hasSelection
                            ? null
                            : _importHistory,
                        icon: Icon(Icons.file_upload),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: _selection.hasSelection
                          ? "Esporta selezionati"
                          : "Esporta",
                      child: IconButton(
                        onPressed: _quizList.isEmpty
                            ? null
                            : (_selection.hasSelection
                                  ? _exportSelected
                                  : () => _exportQuizzes()),
                        icon: Icon(Icons.file_download),
                        iconSize: 35,
                      ),
                    ),
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: _selection.hasSelection
                          ? "Elimina selezionati"
                          : "Svuota",
                      child: IconButton(
                        onPressed: _quizList.isEmpty
                            ? null
                            : (_selection.hasSelection
                                  ? _confirmDeleteSelected
                                  : _confirmClearHistory),
                        icon: Icon(
                          _selection.hasSelection
                              ? Icons.delete
                              : Icons.delete_sweep,
                        ),
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
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onSelected,
  });

  final DateTime timestamp;
  final int correctQuestions;
  final int totalQuestions;
  final int timeSpent;
  final double grade;
  final bool isSelected;

  /// Whether the list is currently in multi-selection mode (at least one item
  /// selected). While in selection mode a tap toggles selection instead of
  /// opening the quiz detail; a long press always toggles selection.
  final bool selectionMode;
  final void Function()? onTap;
  final void Function()? onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          width: 2.0,
          color: isSelected
              ? const Color.fromARGB(255, 64, 152, 241)
              : Colors.transparent,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color.fromARGB(255, 64, 152, 241).withAlpha(50),
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
      onTap: selectionMode ? onSelected : onTap,
      onLongPress: onSelected,
      trailing: isSelected ? const Icon(Icons.check_circle, size: 30) : null,
    );
  }
}
