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

/// How an imported history file is combined with the existing history.
enum _ImportMode { merge, overwrite }

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
    // With existing history, let the user choose whether to merge the imported
    // quizzes in or replace the current history. With an empty history the two
    // are equivalent, so skip the prompt and merge.
    _ImportMode mode = _ImportMode.merge;
    if (_quizList.isNotEmpty) {
      final _ImportMode? choice = await showDialog<_ImportMode>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Importa storico"),
            content: const Text(
              "Unire i quiz importati allo storico attuale o sostituirlo?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annulla"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _ImportMode.overwrite),
                child: const Text("Sostituisci"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _ImportMode.merge),
                child: const Text("Unisci"),
              ),
            ],
          );
        },
      );
      if (choice == null) {
        return;
      }
      mode = choice;
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

    final ImportResult importResult;
    try {
      importResult = await widget.quizRepository.importFromJson(
        utf8.decode(bytes),
        merge: mode == _ImportMode.merge,
      );
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
    ).showSnackBar(SnackBar(content: Text(_importResultMessage(importResult))));
  }

  /// Builds the post-import feedback, e.g. "Importati 2 quiz · 3 duplicati
  /// ignorati · 1 non valido", surfacing the duplicates and malformed entries
  /// that are otherwise silently skipped.
  String _importResultMessage(ImportResult result) {
    final List<String> parts = [
      result.added == 0
          ? "Nessun quiz importato"
          : "Importati ${result.added} quiz",
    ];
    if (result.skippedDuplicates > 0) {
      final s = result.skippedDuplicates == 1
          ? "duplicato ignorato"
          : "duplicati ignorati";
      parts.add("${result.skippedDuplicates} $s");
    }
    if (result.skippedInvalid > 0) {
      final s = result.skippedInvalid == 1 ? "non valido" : "non validi";
      parts.add("${result.skippedInvalid} $s");
    }
    return parts.join(" · ");
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
                              writtenGrade: q.writtenGrade,
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
    this.writtenGrade,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onSelected,
  });

  final DateTime timestamp;
  final int correctQuestions;
  final int totalQuestions;
  final int timeSpent;

  /// Grade shown on the badge: the total exam grade when [writtenGrade] is set,
  /// otherwise the quiz-only grade. Derived by [QuizCompleted.grade].
  final double grade;

  /// Written grade recorded with this quiz, shown beside the score; `null` when
  /// none was set (the badge then shows the quiz-only grade).
  final int? writtenGrade;
  final bool isSelected;

  /// Whether the list is currently in multi-selection mode (at least one item
  /// selected). While in selection mode a tap toggles selection instead of
  /// opening the quiz detail; a long press always toggles selection.
  final bool selectionMode;
  final void Function()? onTap;
  final void Function()? onSelected;

  /// Badge fill/text colors for [grade], on a 30-point scale: green when
  /// passed (>= 18), a richer green for top marks (>= 27), red when failed.
  ({Color background, Color foreground}) _gradeBadgeColors(double grade) {
    const double gradeBase = 30.0;
    final double ratio = grade / gradeBase;
    if (ratio >= 0.9) {
      return (background: const Color(0xFF2E7D32), foreground: Colors.white);
    }
    if (ratio >= 0.6) {
      return (background: const Color(0xFF66BB6A), foreground: Colors.white);
    }
    return (background: const Color(0xFFE57373), foreground: Colors.white);
  }

  /// The square grade badge. Cum laude (grade > 30, i.e. "30L") gets a gold
  /// gradient, a soft glow and a raised superscript "L"; everything else uses
  /// the flat pass/fail color from [_gradeBadgeColors].
  Widget _buildGradeBadge() {
    final bool isLode = grade > 30.0;
    final badge = _gradeBadgeColors(grade);

    final Widget label = isLode
        ? Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "30"),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Transform.translate(
                    offset: const Offset(1.0, -1.0),
                    child: const Text(
                      "L",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            getGradeString(grade),
            style: TextStyle(
              color: badge.foreground,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          );

    return Container(
      width: 48.0,
      height: 48.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isLode ? null : badge.background,
        gradient: isLode
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFC107), Color(0xFFEF6C00)],
              )
            : null,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: isLode
            ? [
                BoxShadow(
                  color: const Color(0xFFFFC107).withAlpha(140),
                  blurRadius: 8.0,
                  spreadRadius: 0.5,
                ),
              ]
            : null,
      ),
      child: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shared with question_card.dart so selection reads the same light blue
    // across the history list and the question editor.
    const Color selectionColor = Color.fromARGB(255, 64, 152, 241);
    final Color muted = Theme.of(context).hintColor;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          width: 2.0,
          color: isSelected ? selectionColor : Colors.transparent,
        ),
      ),
      selected: isSelected,
      selectedTileColor: selectionColor.withAlpha(50),
      leading: _buildGradeBadge(),
      title: Text(
        writtenGrade != null
            ? "$correctQuestions/$totalQuestions · scritto $writtenGrade"
            : "$correctQuestions/$totalQuestions corrette",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 14.0, color: muted),
            const SizedBox(width: 4.0),
            Flexible(
              child: Text(
                getDateString(timestamp),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: muted),
              ),
            ),
            const SizedBox(width: 12.0),
            Icon(Icons.timer_outlined, size: 14.0, color: muted),
            const SizedBox(width: 4.0),
            Text(getTimeString(timeSpent), style: TextStyle(color: muted)),
          ],
        ),
      ),
      isThreeLine: false,
      onTap: selectionMode ? onSelected : onTap,
      onLongPress: onSelected,
      trailing: isSelected
          ? const Icon(Icons.check_circle, size: 30.0, color: selectionColor)
          : null,
    );
  }
}
