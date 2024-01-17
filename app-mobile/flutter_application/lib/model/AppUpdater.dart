import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:roquiz/model/PlatformType.dart';

class AppUpdater {
  static Future<(bool, String, String)> checkNewVersion(
      String currentVersion) async {
    bool newVersionPresent = false;
    String newVersion = "";
    String newVersionDownloadURL = "";

    http.Response response = await http.get(Uri.parse(
        'https://api.github.com/repos/mikyll/ROQuiz/releases/latest'));

    try {
      Map<String, dynamic> json = jsonDecode(response.body);
      String tagName = json['tag_name'];
      List<String> segmentsRepoV = tagName.replaceAll("v", "").split(".");

      List<String> segmentsCurrV = currentVersion.split(".");

      for (int i = 0;
          i < segmentsRepoV.length && i < segmentsCurrV.length;
          i++) {
        if (int.parse(segmentsRepoV[i]) > int.parse(segmentsCurrV[i])) {
          newVersionPresent = true;
          break;
        }
      }

      if (newVersionPresent) {
        newVersion = tagName;

        // Retrieve asset link from APIs
        List<dynamic> assets = json['assets'];
        for (dynamic asset in assets) {
          String name = asset['name'];
          String downloadUrl = asset['browser_download_url'];
          if (getPlatformType() != PlatformType.WEB) {
            if (Platform.isAndroid && name.toLowerCase().contains('android')) {
              newVersionDownloadURL = downloadUrl;
            } else if (Platform.isWindows &&
                name.toLowerCase().contains('windows')) {
              newVersionDownloadURL = downloadUrl;
            } else if (Platform.isLinux &&
                name.toLowerCase().contains('linux')) {
              newVersionDownloadURL = downloadUrl;
            }
          }
        }
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }

    // Test
    //print("New version: $newVersionPresent\nVersion tag name: $newVersion\nVersion download URL: $newVersionDownloadURL");

    return (newVersionPresent, newVersion, newVersionDownloadURL);
  }
}
