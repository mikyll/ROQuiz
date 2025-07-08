class Question {
  static const maxAnswers = 6;

  int id;
  String body;
  String? topic;
  List<String> answers;
  int correctAnswer;

  Question(this.id, this.body, this.topic, this.answers, this.correctAnswer) {
    if (id <= 0) {
      throw FormatException("Invalid question ID: $id");
    }

    if (body.isEmpty) {
      throw FormatException("Body cannot be empty");
    }

    // Not enough answers
    if (answers.length < 2) {
      throw FormatException(
        "Answers must be at least 2. Got ${answers.length}",
      );
    }

    // Check for duplicates
    for (int i = 0; i < answers.length; i++) {
      for (int j = 0; j < answers.length; j++) {
        if (j == i) {
          continue;
        }
        if (answers[j].toLowerCase() == answers[i].toLowerCase()) {
          throw FormatException("Duplicated answer: ${answers[j]}");
        }
      }
    }

    // Check that correct answer is valid
    if (correctAnswer < 0 || correctAnswer >= answers.length) {
      throw FormatException(
        "Invalid correct answer: $correctAnswer is out of bounds [0,${answers.length}]",
      );
    }
  }

  Question.noTopic(id, body, answers, correctAnswer)
    : this(id, body, null, answers, correctAnswer);

  @override
  String toString() {
    String res = "";

    if (topic != null) {
      res += "Topic: $topic\n";
    }
    res += "Q$id: $body\n";

    for (int i = 0; i < answers.length; i++) {
      res += "${String.fromCharCode(i + 65)}. ${answers[i]}\n";
    }

    res += "${String.fromCharCode(correctAnswer + 65)}\n";

    return res;
  }

  String toYaml({letters = false}) {
    String res = """
- body: |
    $body""";

    if (topic != null) {
      res += """

  topic: $topic""";
    }

    res += """

  answers:""";
    for (String a in answers) {
      res += "\n    - $a";
    }

    if (letters) {
      res += "\n  correct_answer: ${String.fromCharCode(correctAnswer + 65)}\n";
    } else {
      res += "\n  correct_answer: $correctAnswer\n";
    }

    return res;
  }
}
