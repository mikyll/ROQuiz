import 'package:roquiz/model/edit_question/question_command.dart';

class RemoveQuestionCommand<Question> implements QuestionCommand {
  final List<Question> _list;
  final Question _element;

  RemoveQuestionCommand(this._list, this._element);

  @override
  void execute() {
    _list.remove(_element);
  }

  @override
  void undo() {
    _list.add(_element);
  }
}
