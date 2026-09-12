import 'package:roquiz/model/edit_question/command.dart';

class CustomCommand implements Command {
  @override
  String name;
  final Function() onExecute;
  final Function() onUndo;
  final Function()? onRedo;

  CustomCommand({
    this.name = "",
    required this.onExecute,
    required this.onUndo,
    Function()? onRedo,
  }) : onRedo = onRedo ?? onExecute;

  @override
  void execute() {
    onExecute();
  }

  @override
  void undo() {
    onUndo();
  }

  @override
  void redo() {
    onRedo!();
  }
}
