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
  for (String s in answers) {
    if (ignoreCase) {
      s = s.toLowerCase();
      answer = answer.toLowerCase();
    }
    if (s == answer) {
      return true;
    }
  }

  return false;
}

bool isQuestionBodyDuplicate(
  List<Question> questions,
  String questionBody, {
  bool ignoreCase = true,
}) {
  for (Question q in questions) {
    if (ignoreCase) {
      q.body = q.body.toLowerCase();
      questionBody = questionBody.toLowerCase();
    }
    if (q.body == questionBody) {
      return true;
    }
  }

  return false;
}

bool isQuestionDuplicate(
  List<Question> questions,
  Question question, {
  bool ignoreCase = true,
}) {
  for (Question q in questions) {
    if (isQuestionBodyDuplicate(questions, q.body, ignoreCase: ignoreCase)) {
      return true;
    }
    for (String a in q.answers) {
      if (isAnswerDuplicate(q.answers, a, ignoreCase: ignoreCase)) {
        return true;
      }
    }
  }

  return false;
}
