import 'package:roquiz/model/edit/command.dart';

class EditCommand<T> implements Command {
  final List<T> _list;
  final int _iElement;
  final T _elementPrevious;
  final T _element;

  EditCommand(this._list, this._iElement, this._element)
    : _elementPrevious = _list[_iElement];

  @override
  void execute() {
    _list[_iElement] = _element;
  }

  @override
  void undo() {
    _list[_iElement] = _elementPrevious;
  }
}
