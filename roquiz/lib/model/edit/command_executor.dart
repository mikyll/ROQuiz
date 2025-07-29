import 'package:roquiz/model/edit/command.dart';
import 'package:roquiz/model/edit/commands/add.dart';
import 'package:roquiz/model/edit/commands/edit.dart';
import 'package:roquiz/model/edit/commands/remove.dart';

class CommandExecutor {
  final List<Command> _commands = [];
  int _iCommand = -1;

  void executeCommand(Command c) {
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

  List<String> getCommandsList() {
    List<String> commands = [];

    for (int i = 0; i < _commands.length; i++) {
      Command command = _commands[i];
      String commandDescription = "";

      commandDescription += i == _iCommand ? "> " : "  ";

      if (command is AddCommand) {
        commandDescription += "add";
      }
      if (command is RemoveCommand) {
        commandDescription += "remove";
      }

      commands.add(commandDescription);
    }

    return commands;
  }
}

void main() {
  List<int> myIntegers = [];
  CommandExecutor executor = CommandExecutor();

  print(myIntegers);
  executor.executeCommand(AddCommand(myIntegers, 1));
  print(myIntegers);
  executor.executeCommand(AddCommand(myIntegers, 15));
  print(myIntegers);
  executor.executeCommand(AddCommand(myIntegers, 6));
  print(myIntegers);

  executor.undoCommand();
  print(myIntegers);

  executor.redoCommand();
  print(myIntegers);

  executor.undoCommand();
  print(myIntegers);
  executor.undoCommand();
  print(myIntegers);

  executor.executeCommand(AddCommand(myIntegers, 200));
  print(myIntegers);

  executor.undoCommand();
  print(myIntegers);
  executor.undoCommand();
  print(myIntegers);
  executor.undoCommand();
  print(myIntegers);
  executor.undoCommand();
  print(myIntegers);

  executor.redoCommand();
  print(myIntegers);
  executor.redoCommand();
  print(myIntegers);
  executor.redoCommand();
  print(myIntegers);

  executor.executeCommand(EditCommand(myIntegers, 0, 100));
  print(myIntegers);
  executor.undoCommand();
  print(myIntegers);
}
