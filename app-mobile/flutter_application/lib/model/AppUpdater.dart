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

    if (getPlatformType() == PlatformType.WEB) {
      return (newVersionPresent, newVersion, newVersionDownloadURL);
    }

    http.Response response = await http.get(Uri.parse(
        'https://api.github.com/repos/mikyll/ROQuiz/releases/latest'));

    try {
      Map<String, dynamic> json = jsonDecode(response.body);
      String tagName = json['tag_name'];

      if (compareVersions(currentVersion, tagName) == 1) {
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

  static int compareVersions(String localVersion, String remoteVersion) {
    List<String> segmentsLocalV = localVersion.replaceAll("v", "").split(".");
    List<String> segmentsRemoteV = remoteVersion.replaceAll("v", "").split(".");

    // Get max length
    int maxLength = segmentsLocalV.length > segmentsRemoteV.length
        ? segmentsLocalV.length
        : segmentsRemoteV.length;

    // Add padding '0' to ensure equal length
    segmentsLocalV.addAll(List.filled(maxLength - segmentsLocalV.length, '0'));
    segmentsRemoteV
        .addAll(List.filled(maxLength - segmentsRemoteV.length, '0'));

    // Compare versions
    for (int i = 0; i < maxLength; i++) {
      int localSegment = int.tryParse(segmentsLocalV[i]) ?? 0;
      int remoteSegment = int.tryParse(segmentsRemoteV[i]) ?? 0;
      if (remoteSegment > localSegment) {
        return 1;
      } else if (remoteSegment < localSegment) {
        return -1;
      }
    }
    return 0;
  }
}

// Test main
void main(List<String> args) {
  print("test");
  // local, remote
  print(AppUpdater.compareVersions("v1.10.1", "v1.11.0"));
  print(AppUpdater.compareVersions("v1.11.1", "v1.10.0"));
  print(AppUpdater.compareVersions("v1.11.0", "v1.10.1"));
  print(AppUpdater.compareVersions("v1.11.0", "v1.11.0"));
}
