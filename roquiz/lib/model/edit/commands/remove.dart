import 'package:roquiz/model/edit/command.dart';

class RemoveCommand<T> implements Command {
  final List<T> _list;
  final T _element;

  RemoveCommand(this._list, this._element);

  @override
  void execute() {
    _list.remove(_element);
  }

  @override
  void undo() {
    _list.add(_element);
  }
}
