class Question {
  int id;
  String body;
  String? topic;
  List<String> answers;
  int correctAnswer;
  String? explaination;

  Question({
    required this.id,
    required this.body,
    required this.answers,
    required this.correctAnswer,
    this.topic,
  }) {
    if (id < 0) {
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
    : this(
        id: id,
        body: body,
        topic: null,
        answers: answers,
        correctAnswer: correctAnswer,
      );

  /// Unchecked constructor used to rehydrate stored history snapshots. The data
  /// was already validated when the quiz was taken, so re-running the (possibly
  /// stricter, future) validation could wrongly reject otherwise valid history.
  Question._unchecked({
    required this.id,
    required this.body,
    required this.answers,
    required this.correctAnswer,
    this.topic,
    this.explaination,
  });

  /// Creates a deep copy of [other] (the answers list is duplicated, so the
  /// copy can be mutated without affecting the original).
  factory Question.copy(Question other) {
    final Question copy = Question(
      id: other.id,
      body: other.body,
      topic: other.topic,
      answers: List<String>.from(other.answers),
      correctAnswer: other.correctAnswer,
    );
    copy.explaination = other.explaination;
    return copy;
  }

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
    // Emit every string as a double-quoted YAML scalar so the file round-trips
    // losslessly through parseQuestionsFromYaml. Plain/unquoted scalars would
    // misparse real question text: a "key: value"-looking answer becomes a map,
    // a numeric answer becomes an int, and a block-scalar body gains a trailing
    // newline.
    String res = "- body: ${_yamlQuote(body)}";

    if (topic != null) {
      res += "\n  topic: ${_yamlQuote(topic!)}";
    }

    res += "\n  answers:";
    for (String a in answers) {
      res += "\n    - ${_yamlQuote(a)}";
    }

    if (letters) {
      res += "\n  correct_answer: ${String.fromCharCode(correctAnswer + 65)}\n";
    } else {
      res += "\n  correct_answer: $correctAnswer\n";
    }

    return res;
  }

  /// Wraps [value] as a double-quoted YAML scalar, escaping the characters that
  /// would otherwise break parsing or alter the string.
  static String _yamlQuote(String value) {
    final escaped = value
        .replaceAll("\\", "\\\\")
        .replaceAll("\"", "\\\"")
        .replaceAll("\n", "\\n")
        .replaceAll("\r", "\\r")
        .replaceAll("\t", "\\t");
    return "\"$escaped\"";
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "body": body,
    "topic": topic,
    "answers": answers,
    "correctAnswer": correctAnswer,
    "explaination": explaination,
  };

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question._unchecked(
      id: json["id"] as int,
      body: json["body"] as String,
      topic: json["topic"] as String?,
      answers: (json["answers"] as List).cast<String>(),
      correctAnswer: json["correctAnswer"] as int,
      explaination: json["explaination"] as String?,
    );
  }
}
