import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

/// Outcome of an app release check: the latest release's version and web page,
/// plus whether it is newer than the running app.
class AppRelease {
  /// The latest release's version, normalized (a leading "v" stripped).
  final String version;

  /// The release's web page — opened for the user to download the update.
  final String url;

  /// Whether [version] is newer than the running app.
  final bool isNewer;

  const AppRelease({
    required this.version,
    required this.url,
    required this.isNewer,
  });
}

/// Checks GitHub Releases for a newer version of the app. Stateless: it only
/// reads the remote and never persists anything, mirroring the caller-driven
/// design of [QuestionRepository.peekRemoteUpdate] — the caller decides what to
/// do with the result. The HTTP client is injectable so tests can drive the
/// logic without real network access.
class AppReleaseChecker {
  /// Canonical remote repository (GitHub) whose releases we track.
  static const String remoteRepository = "mikyll/ROQuiz";

  final http.Client _client;

  AppReleaseChecker({http.Client? client}) : _client = client ?? http.Client();

  /// GitHub API endpoint for the latest published release.
  String get latestReleaseApiUrl =>
      "https://api.github.com/repos/$remoteRepository/releases/latest";

  /// Web page shown when the release payload lacks its own `html_url`.
  String get releasesPageUrl =>
      "https://github.com/$remoteRepository/releases/latest";

  /// Fetches the latest release and compares it against [currentVersion] (the
  /// running app's version, e.g. from `PackageInfo.version`). Network/parse
  /// errors propagate so the caller can decide whether to surface them.
  Future<AppRelease> checkForUpdate(String currentVersion) async {
    final response = await _client.get(
      Uri.parse(latestReleaseApiUrl),
      headers: const {"Accept": "application/vnd.github+json"},
    );

    final dynamic json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = json is Map && json["message"] is String
          ? json["message"] as String
          : "GitHub API error (${response.statusCode})";
      throw HttpException(message);
    }

    if (json is! Map || json["tag_name"] is! String) {
      throw const FormatException("Unexpected release response");
    }

    final String tag = json["tag_name"] as String;
    final String url = json["html_url"] is String
        ? json["html_url"] as String
        : releasesPageUrl;

    return AppRelease(
      version: _stripV(tag),
      url: url,
      isNewer: _isNewer(latest: tag, current: currentVersion),
    );
  }

  /// Whether [latest] is a newer release than [current]. Both are parsed as
  /// semver (a leading "v" is tolerated, and any build metadata after "+" is
  /// ignored). An unparseable version is treated as not-newer, so a malformed
  /// tag never nags the user with a bogus update.
  static bool _isNewer({required String latest, required String current}) {
    final Version? l = _tryParse(latest);
    final Version? c = _tryParse(current);
    if (l == null || c == null) {
      return false;
    }
    return l > c;
  }

  static Version? _tryParse(String raw) {
    try {
      return Version.parse(_stripV(raw));
    } catch (_) {
      return null;
    }
  }

  static String _stripV(String s) {
    final String t = s.trim();
    return t.startsWith("v") || t.startsWith("V") ? t.substring(1) : t;
  }
}
