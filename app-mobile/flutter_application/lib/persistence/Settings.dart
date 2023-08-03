import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static const String APP_TITLE = "ROQuiz";
  static String VERSION_NUMBER = "";
  static const int DEFAULT_ANSWER_NUMBER = 5;

  static const bool DEFAULT_CHECK_QUESTIONS_UPDATE = true;
  static const bool DEFAULT_CHECK_APP_UPDATE = false;
  static int DEFAULT_QUESTION_NUMBER = 16;
  static int DEFAULT_TIMER = 18;
  static const bool DEFAULT_SHUFFLE_ANSWERS = true;
  static const bool DEFAULT_CONFIRM_ALERTS = true;
  static const bool DEFAULT_DARK_THEME = false;

  late bool checkQuestionsUpdate = DEFAULT_CHECK_QUESTIONS_UPDATE;
  late bool checkAppUpdate = DEFAULT_CHECK_APP_UPDATE;
  late int questionNumber = DEFAULT_QUESTION_NUMBER;
  late int timer = DEFAULT_TIMER;
  late bool shuffleAnswers = DEFAULT_SHUFFLE_ANSWERS;
  late bool confirmAlerts = DEFAULT_CONFIRM_ALERTS;
  late bool darkTheme = DEFAULT_DARK_THEME;

  void loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    checkQuestionsUpdate =
        prefs.getBool("checkQuestionsUpdate") ?? DEFAULT_CHECK_QUESTIONS_UPDATE;
    checkAppUpdate =
        prefs.getBool("checkAppUpdate") ?? DEFAULT_CHECK_APP_UPDATE;
    questionNumber = prefs.getInt("questionNumber") ?? DEFAULT_QUESTION_NUMBER;
    timer = prefs.getInt("timer") ?? DEFAULT_TIMER;
    shuffleAnswers = prefs.getBool("shuffleAnswers") ?? DEFAULT_SHUFFLE_ANSWERS;
    confirmAlerts = prefs.getBool("confirmAlerts") ?? DEFAULT_CONFIRM_ALERTS;
    darkTheme = prefs.getBool("darkTheme") ?? DEFAULT_DARK_THEME;
  }

  void saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("checkQuestionsUpdate", checkQuestionsUpdate);
    prefs.setBool("checkAppUpdate", checkAppUpdate);
    prefs.setInt("questionNumber", questionNumber);
    prefs.setInt("timer", timer);
    prefs.setBool("shuffleAnswers", shuffleAnswers);
    prefs.setBool("confirmAlerts", confirmAlerts);
    prefs.setBool("darkTheme", darkTheme);
  }

  void resetDefault() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("checkQuestionsUpdate", DEFAULT_CHECK_QUESTIONS_UPDATE);
    prefs.setBool("checkAppUpdate", DEFAULT_CHECK_APP_UPDATE);
    prefs.setInt("questionNumber", DEFAULT_QUESTION_NUMBER);
    prefs.setInt("timer", DEFAULT_TIMER);
    prefs.setBool("shuffleAnswers", DEFAULT_SHUFFLE_ANSWERS);
    prefs.setBool("confirmAlerts", DEFAULT_CONFIRM_ALERTS);
    prefs.setBool("darkTheme", DEFAULT_DARK_THEME);
  }
}
