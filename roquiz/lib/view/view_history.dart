import 'package:flutter/material.dart';
import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/quiz_completed.dart';
import 'package:roquiz/model/utils/utils.dart';
import 'package:roquiz/view/view_questions_edit.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';
import 'package:roquiz/widget/question_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({super.key, required this.quizList});

  final List<QuizCompleted> quizList;

  @override
  State<StatefulWidget> createState() => ViewHistoryState();
}

class ViewHistoryState extends State<ViewHistory> {
  final ScrollController _scrollController = ScrollController();

  late List<QuizCompleted> _orderedQuizList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onPopInvoked: (_) {
      //   // todo
      // },
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
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.quizList.length,
                  itemBuilder: (context, index) {
                    QuizCompleted quizCompleted = widget.quizList[index];

                    // TODO
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: _QuizCompletedWidget(
                        timestamp: quizCompleted.timestamp,
                        correctQuestions: quizCompleted.correctAnswers,
                        totalQuestions: quizCompleted.questions.length,
                        timeSpent: quizCompleted.timeSpent,
                        grade: quizCompleted.grade,
                        onTap: () {
                          // TODO
                        },
                        onRemove: () {
                          // TODO
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ListView.builder(
          //   controller: _scrollController,
          //   itemCount: _questions.length,
          //   itemBuilder: (_, index) {
          //     Widget questionWidget = QuestionCard.base(
          //       question: _questions[index],
          //       hideCorrectAnswer: !_showAnswers,
          //     );
          //     // Check if we have to display the topic divider
          //     if (index == 0 ||
          //         _questions[index - 1].topic != _questions[index].topic) {
          //       return Column(
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.only(
          //               left: 10.0,
          //               right: 10.0,
          //               top: index == 0 ? 10.0 : 0,
          //             ),
          //             child: Row(
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 10.0),
          //                   child: Text(
          //                     _questions[index].topic!,
          //                     style: const TextStyle(
          //                       fontSize: 18.0,
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                 ),
          //                 const Expanded(child: Divider(thickness: 2)),
          //               ],
          //             ),
          //           ),
          //           questionWidget,
          //         ],
          //       );
          //     }
          //     // Otherwise simply return the card
          //     else {
          //       return questionWidget;
          //     }
          //   },
          // ),
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor.withAlpha(70),
            // border: Border(
            //   top: BorderSide(color: Theme.of(context).disabledColor),
            // ),
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
  final double? grade;
  final void Function()? onTap;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    // TODO

    // InkWell(
    //   onTap: onTap,
    //   child: Row(
    //     children: [
    //       Text(timestamp.toString()),
    //       Text("$correctQuestions/$totalQuestions"),
    //       Text(getTimeString(timeSpent)),
    //       if (grade != null) Text(getGradeString(grade!)),
    //     ],
    //   ),
    // ),
    // Positioned(
    //   right: 10,
    //   child: InkWell(onTap: onRemove, child: Icon(Icons.delete)),
    // ),

    return Stack(
      children: [
        ListTile(
          leading: grade != null
              ? Text(
                  getGradeString(grade!),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              : null,
          title: Row(
            spacing: 10.0,
            children: [
              Text(
                timestamp
                    .toString()
                    .replaceAll("T", " ")
                    .split(".")[0]
                    .padRight(22),
              ),
              Text(
                "${correctQuestions.toString().padLeft(3)}/${totalQuestions.toString().padRight(3)}",
              ),
              Text(getTimeString(timeSpent)),
            ],
          ),
          isThreeLine: false,
          onTap: onTap,
          trailing: InkWell(
            onTap: onRemove,
            child: Icon(Icons.delete, size: 30),
          ),
        ),
      ],
    );
  }
}
