import 'package:roquiz/model/edit_question/question_command.dart';

class QuestionCommandExecutor {
  final List<QuestionCommand> _commands = [];
  int _iCommand = -1;

  void executeCommand(QuestionCommand c) {
    // Remove all commands that are overridden by the current one
    while (_iCommand < _commands.length - 1) {
      _commands.removeLast();
    }

    c.execute();
    _iCommand = _commands.length;
    _commands.add(c);
  }

  bool canUndo() {
    return _iCommand >= 0;
  }

  void undoCommand() {
    if (!canUndo()) {
      return;
    }

    _commands[_iCommand].undo();
    _iCommand--;
  }

  bool canRedo() {
    return _iCommand < _commands.length - 1;
  }

  void redoCommand() {
    if (!canRedo()) {
      return;
    }

    _iCommand++;
    _commands[_iCommand].execute();
  }
}
