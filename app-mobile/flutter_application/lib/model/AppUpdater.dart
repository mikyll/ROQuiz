import 'dart:convert';
import 'package:http/http.dart' as http;

class AppUpdater {
  static Future<(bool, String, String)> checkNewVersion(
      String currentVersion) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.github.com/repos/mikyll/ROQuiz/releases/latest'));

    try {
      Map<String, dynamic> json = jsonDecode(response.body);
      String tag_name = json['tag_name'];
      List<String> repoVersion = tag_name.replaceAll("v", "").split(".");

      int repoMajor = int.parse(repoVersion[0]);
      int repoMinor = int.parse(repoVersion[1]);

      List<String> splittedCurrentVersion = currentVersion.split(".");
      int currentMajor = int.parse(splittedCurrentVersion[0]);
      int currentMinor = int.parse(splittedCurrentVersion[1]);

      if (currentMajor < repoMajor ||
          (currentMajor == repoMajor && currentMinor < repoMinor)) {
        // retrieve asset link from APIs

        return (true, tag_name, "asset link");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
    return (false, "", "");
  }
}
