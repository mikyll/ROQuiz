class Question {
  final int _id;
  final String _body;

  late String _topic;
  late List<String> _answers;
  late int _correctAnswer;

  Question(
      this._id, this._body, this._topic, this._answers, this._correctAnswer);

  Question.onlyBody(this._id, this._body) {
    _answers = [];
  }

  Question.onlyBodyWithTopic(this._id, this._body, this._topic) {
    _answers = [];
  }

  int getId() {
    return _id;
  }

  String getBody() {
    return _body;
  }

  List<String> getAnswers() {
    return _answers;
  }

  String getTopic() {
    return _topic;
  }

  void setTopic(String topic) {
    _topic = topic;
  }

  void setAnswers(List<String> answers) {
    for (String s in answers) {
      s = s.replaceAll('"', "'");
    }
    _answers = answers;
  }

  void addAnswer(String answer) {
    if (_answers.contains(answer)) {
      throw FormatException(
          "Duplicated answer: answer '$answer' is already present");
    }

    answer = answer.replaceAll('"', "'");

    _answers.add(answer);
  }

  int getCorrectAnswer() {
    return _correctAnswer;
  }

  void setCorrectAnswer(int correctAnswer) {
    if (correctAnswer >= 0 && correctAnswer <= 9) {
      _correctAnswer = correctAnswer;
    }
  }

  void setCorrectAnswerFromText(String correctAnswer) {
    if (!_answers.contains(correctAnswer)) {
      throw FormatException("Answer not present");
    }
    _correctAnswer = _answers.indexOf(correctAnswer);
  }

  @override
  String toString() {
    String res = "Topic: $_topic\nQ$_id: $_body\n";

    for (int i = 0; i < _answers.length; i++) {
      res += "${String.fromCharCode(i + 65)}. ${_answers[i]}\n";
    }

    res += "${String.fromCharCode(_correctAnswer + 65)}\n";

    return res;
  }

  String toYAML({letters = false}) {
    String res = """
- body: >-
    $_body
  topic: "$_topic"
  answers:""";
    for (String s in _answers) {
      res += "\n    - \"$s\"";
    }

    if (letters) {
      res +=
          "\n  correct_answer: ${String.fromCharCode(_correctAnswer + 65)}\n";
    } else {
      res += "\n  correct_answer: $_correctAnswer\n";
    }

    return res;
  }
}
