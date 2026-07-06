import 'package:roquiz/persistence/QuestionRepository.dart';

class Utils {
  static String getParsedDateTime(DateTime date) {
    if (date == QuestionRepository.CUSTOM_DATE) {
      return "personalizzato";
    } else {
      return "${date.day < 10 ? "0" : ""}${date.day}/${date.month < 10 ? "0" : ""}${date.month}/${date.year}, ${date.hour < 10 ? "0" : ""}${date.hour}:${date.minute < 10 ? "0" : ""}${date.minute}";
    }
  }
}
