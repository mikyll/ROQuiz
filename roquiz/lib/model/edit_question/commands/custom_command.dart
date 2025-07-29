import 'package:roquiz/model/edit_question/question_command.dart';

class CustomQuestionCommand implements QuestionCommand {
  final Function() onExecute;
  final Function() onUndo;

  CustomQuestionCommand(this.onExecute, this.onUndo);

  @override
  void execute() {
    onExecute();
  }

  @override
  void undo() {
    onUndo();
  }
}
