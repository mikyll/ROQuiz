import 'dart:math';

bool isGradeValid(int? grade) {
  return grade != null && grade >= 0 && grade <= 32;
}

int calculateQuizGrade(int numQuestions, int numCorrectAnswers) {
  return (numQuestions > 0
      ? (numCorrectAnswers / numQuestions * 16 * 2).round()
      : 0);
}

double calculateTotalGrade(int writtenGrade, int quizGrade) {
  double total = writtenGrade * 2 / 3 + quizGrade / 3;

  return total;
}

(double, double) calculateTotalGradeRange(int quizGrade) {
  double totalMin = 0 * 2 / 3 + quizGrade / 3;
  double totalMax = 32 * 2 / 3 + quizGrade / 3;

  return (totalMin, totalMax);
}

String getGradeString(double grade, {gradeBase = 30.0}) {
  String gradeString = min(grade.round(), gradeBase.round()).toString();
  if (grade > gradeBase) {
    gradeString += "L";
  }

  return gradeString;
}
