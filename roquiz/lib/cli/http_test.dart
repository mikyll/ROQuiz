import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<DateTime> getLatestQuestionsFileDatetime({
  String repository = "mikyll/ROQuiz",
  String path = "Domande.txt",
}) async {
  DateTime date;

  try {
    http.Response response = await http.get(
      Uri.parse(
        "https://api.github.com/reps/$repository/commits?path=$path&page=1&per_page=1",
      ),
    );

    dynamic json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Future.error(HttpException(json["message"]));
    }

    String dateString = json[0]['commit']['author']['date'];
    date = DateTime.parse(dateString);

    return Future<DateTime>.value(date);
  } catch (e) {
    return Future.error(e);
  }
}

void main() async {
  // http.Response response = await http.get(
  //   Uri.parse("https://httpbin.org/anything"),
  // );
  // print("Status Code: ${response.statusCode}");
  // print("Body: ${response.body}");

  // http.get(Uri.parse("http://httpbin.org/anything")).then((response) {
  //   print("Status Code: ${response.statusCode}");
  //   print("Body: ${response.body}");
  // });

  getLatestQuestionsFileDatetime()
      .then((dateTime) {
        print(dateTime.toString());
      })
      .onError((error, stackTrace) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      });
}
