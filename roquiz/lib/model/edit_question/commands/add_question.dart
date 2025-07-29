// import 'package:roquiz/model/edit_question/question_command.dart';

// class AddQuestionCommand<Question> implements QuestionCommand {
//   final Map<Question, bool> _list;
//   final Question _question;
//   final int _prefiouslySelected;
//   final int _selected;
//   final Question _element;

//   AddQuestionCommand(this._list, this._element, this._selectedlist);

//   @override
//   void execute() {
//     _list.add(_element);
//     _selectedlist.add(false);
//   }

//   @override
//   void undo() {
//     int index = _list.indexOf(_element);
//     _list.removeAt(index);
//     _selectedlist.removeAt(index);
//   }
// }
