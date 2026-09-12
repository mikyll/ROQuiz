import 'package:roquiz/model/edit_question/command.dart';

class CommandExecutor {
  final String initState;
  final List<Command> _commands = [];
  int _currentIndex = -1;

  CommandExecutor({this.initState = ""});

  void executeCommand(Command command) {
    // Clear redo history
    if (_currentIndex < _commands.length - 1) {
      _commands.removeRange(_currentIndex + 1, _commands.length);
    }

    command.execute();
    _commands.add(command);
    _currentIndex = _commands.length - 1;

    printState();
  }

  bool canUndo() {
    return _currentIndex >= 0;
  }

  void undoCommand() {
    if (!canUndo()) return;

    _commands[_currentIndex].undo();
    _currentIndex--;

    printState();
  }

  bool canRedo() {
    return _currentIndex < _commands.length - 1;
  }

  void redoCommand() {
    if (!canRedo()) return;

    _currentIndex++;
    _commands[_currentIndex].redo();

    printState();
  }

  void printState() {
    String result = "=== Commands History ===\n";

    if (initState.isNotEmpty) {
      result += _currentIndex == -1 ? ">" : " ";
      result += "${(-1).toString().padLeft(3)}) $initState";
    }
    for (int i = 0; i < _commands.length; i++) {
      String line = _currentIndex == i ? ">" : " ";
      line += "${i.toString().padLeft(3)}) ${_commands[i].name}";

      result += "\n$line";
    }
    print(result);
  }
}
