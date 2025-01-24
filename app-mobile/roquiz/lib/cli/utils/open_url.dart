import 'package:url_launcher/url_launcher_string.dart';

// Launch system url in the system browser
void openUrl(String url, {bool external = true}) async {
  launchUrlString(
    url,
    mode: external ? LaunchMode.externalApplication : LaunchMode.inAppWebView,
  ).then((onValue) {}).onError((error, stackTrace) {
    throw Exception("Could not launch $url: $error");
  });
}
