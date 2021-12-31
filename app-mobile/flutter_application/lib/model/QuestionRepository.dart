import 'package:roquiz/model/Question.dart';

class QuestionRepository {
  late List<Question> questions;
  late List<String> topics;
  late List<int> questionsPerTopic; // how many questions are in a topic

  QuestionRepository(String filename) {
    /*final file = File(filename);
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(LineSplitter());
      try {
        await for (String l in lines) {
          
        }
      }
      catch (e) {
        print("Error: $e");
      }*/
  }

  _loadQuestions() {}
}
