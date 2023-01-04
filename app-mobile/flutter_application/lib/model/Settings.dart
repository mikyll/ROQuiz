import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static const String APP_TITLE = "ROQuiz";
  static const String VERSION_NUMBER = "1.5";
  static const int DEFAULT_QUESTION_NUMBER = 16;
  static const int DEFAULT_TIMER = 18;
  static const bool DEFAULT_SHUFFLE_ANSWERS = true;
  static const bool DEFAULT_DARK_THEME = false;
  static const bool DEFAULT_CHECK_QUESTIONS_UPDATE = false;
  static const bool DEFAULT_CHECK_APP_UPDATE = false;

  static const int DEFAULT_ANSWER_NUMBER = 5;

  late int questionNumber = DEFAULT_QUESTION_NUMBER;
  late int timer = DEFAULT_TIMER;
  late bool shuffleAnswers = DEFAULT_SHUFFLE_ANSWERS;
  late bool darkTheme = DEFAULT_DARK_THEME;
  late bool checkQuestionsUpdate = DEFAULT_CHECK_QUESTIONS_UPDATE;
  late bool checkAppUpdate = DEFAULT_CHECK_APP_UPDATE;

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    questionNumber = prefs.getInt("questionNumber") ?? DEFAULT_QUESTION_NUMBER;
    timer = prefs.getInt("timer") ?? DEFAULT_TIMER;
    shuffleAnswers = prefs.getBool("shuffleAnswers") ?? DEFAULT_SHUFFLE_ANSWERS;
    darkTheme = prefs.getBool("darkTheme") ?? DEFAULT_DARK_THEME;
    checkQuestionsUpdate =
        prefs.getBool("checkQuestionsUpdate") ?? DEFAULT_CHECK_QUESTIONS_UPDATE;
    checkAppUpdate =
        prefs.getBool("checkAppUpdate") ?? DEFAULT_CHECK_APP_UPDATE;
  }

  void saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt("questionNumber", questionNumber);
    prefs.setInt("timer", timer);
    prefs.setBool("shuffleAnswers", shuffleAnswers);
    prefs.setBool("darkTheme", darkTheme);
    prefs.setBool("checkQuestionsUpdate", checkQuestionsUpdate);
    prefs.setBool("checkAppUpdate", checkAppUpdate);
  }

  void resetSettings() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt("questionNumber", DEFAULT_QUESTION_NUMBER);
    prefs.setInt("timer", DEFAULT_TIMER);
    prefs.setBool("shuffleAnswers", DEFAULT_SHUFFLE_ANSWERS);
    prefs.setBool("darkTheme", DEFAULT_DARK_THEME);
    prefs.setBool("checkQuestionsUpdate", DEFAULT_CHECK_QUESTIONS_UPDATE);
    prefs.setBool("checkAppUpdate", DEFAULT_CHECK_APP_UPDATE);
  }
}
