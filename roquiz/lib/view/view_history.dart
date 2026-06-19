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
                  children: [
                    Tooltip(
                      waitDuration: Duration(milliseconds: 500),
                      message: "Esporta",
                      child: IconButton(
                        onPressed: () {
                          // TODO
                        },
                        icon: Icon(Icons.file_download),
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
