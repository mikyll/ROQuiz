import 'package:roquiz/model/edit_question/command.dart';

class CustomCommand implements Command {
  @override
  String name;
  final Function() onExecute;
  final Function() onUndo;
  final Function()? onRedo;

  CustomCommand({
    required this.onExecute,
    required this.onUndo,
    this.onRedo,
    this.name = "",
  });

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
