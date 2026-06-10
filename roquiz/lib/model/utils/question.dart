import 'package:roquiz/model/quiz/question.dart';

int getFirstAvailableId(List<Question> questions, String? topic) {
  bool topicFound = false;
  int id = 0;

  if (topic == null) {
    return questions.length;
  }

  for (; id < questions.length; id++) {
    Question question = questions[id];

    if (topicFound) {
      if (topic != question.topic) {
        break;
      }
    }

    if (topic == question.topic) {
      topicFound = true;
    }
  }

  return id;
}

bool isAnswerDuplicate(
  List<String> answers,
  String answer, {
  bool ignoreCase = true,
}) {
  for (int i = 0, counter = 0; i < answers.length; i++) {
    String a = answers[i];
    if (ignoreCase) {
      a = a.toLowerCase();
      answer = answer.toLowerCase();
    }
    if (a == answer) {
      counter++;
    }
    if (counter > 1) {
      return true;
    }
  }

  return false;
}

int containsDuplicateAnswers(List<String> answers) {
  for (int i = 0; i < answers.length; i++) {
    if (isAnswerDuplicate(answers, answers[i])) {
      return i;
    }
  }
  return -1;
}

int isQuestionBodyDuplicate(
  List<Question> questions,
  String questionBody, {
  bool ignoreCase = true,
}) {
  final String target = ignoreCase ? questionBody.toLowerCase() : questionBody;

  for (Question q in questions) {
    final String body = ignoreCase ? q.body.toLowerCase() : q.body;
    if (body == target) {
      return q.id;
    }
  }

  return -1;
}

bool isQuestionDuplicate(
  List<Question> questions,
  Question question, {
  bool ignoreCase = true,
}) {
  // The candidate's body matches an existing question.
  if (isQuestionBodyDuplicate(
        questions,
        question.body,
        ignoreCase: ignoreCase,
      ) !=
      -1) {
    return true;
  }

  // The candidate itself contains duplicate answers.
  if (containsDuplicateAnswers(question.answers) != -1) {
    return true;
  }

  return false;
}

List<String> getTopicsList(List<Question> questions) {
  final Set<String> topics = {};

  if (questions.isEmpty || questions.first.topic == null) {
    return [];
  }

  for (Question q in questions) {
    topics.add(q.topic!);
  }

  return topics.toList();
}
