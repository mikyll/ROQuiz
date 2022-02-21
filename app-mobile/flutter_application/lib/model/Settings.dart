class Settings {
  final double VERSION_NUMBER = 1.4;
  final String VERSION_SUFFIX = ""; //"-mobile_beta";
  final int DEFAULT_QUESTION_NUMBER = 16;
  final int DEFAULT_ANSWER_NUMBER = 5;
  final int DEFAULT_TIMER = 18;
  final bool DEFAULT_DARK_MODE = false;

  int questionNumber = -1;
  int timer = -1;
  bool checkQuestionUpdate = false;
  bool darkMode = false;

  Settings(int qNum, int sTime, bool qUpdate, bool dMode) {
    questionNumber = qNum;
    timer = sTime;
    checkQuestionUpdate = qUpdate;
    darkMode = dMode;
  }
}
