import 'package:roquiz/model/edit/command.dart';

class AddCommand<T> implements Command {
  final List<T> _list;
  final T _element;

  AddCommand(this._list, this._element);

  @override
  void execute() {
    _list.add(_element);
  }

  @override
  void undo() {
    _list.remove(_element);
  }
}
