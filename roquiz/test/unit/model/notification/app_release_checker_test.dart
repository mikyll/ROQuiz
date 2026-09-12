import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:roquiz/model/notification/app_version.dart';

/// Drives [AppReleaseChecker.checkForUpdate] without real network access:
/// version comparison (incl. a leading "v" and pre-release precedence), the
/// html_url fallback, and error propagation on non-200 / malformed responses.
void main() {
  /// A [MockClient] that answers the GitHub "latest release" API with [tag]
  /// (optionally an [htmlUrl]).
  http.Client mockRelease(String tag, {String? htmlUrl}) {
    return MockClient((request) async {
      expect(request.url.host, "api.github.com");
      return http.Response(
        jsonEncode({
          "tag_name": tag,
          if (htmlUrl != null) "html_url": htmlUrl,
        }),
        200,
      );
    });
  }

  test("a strictly newer release is flagged, with its normalized version",
      () async {
    final checker = AppReleaseChecker(client: mockRelease("v2.1.0"));
    final release = await checker.checkForUpdate("2.0.0");

    expect(release.isNewer, isTrue);
    expect(release.version, "2.1.0"); // leading "v" stripped
  });

  test("the same version is not newer", () async {
    final checker = AppReleaseChecker(client: mockRelease("2.0.0"));
    final release = await checker.checkForUpdate("2.0.0");
    expect(release.isNewer, isFalse);
  });

  test("an older release is not newer", () async {
    final checker = AppReleaseChecker(client: mockRelease("1.9.0"));
    final release = await checker.checkForUpdate("2.0.0");
    expect(release.isNewer, isFalse);
  });

  test("a full release is newer than the matching pre-release", () async {
    final checker = AppReleaseChecker(client: mockRelease("2.0.0"));
    final release = await checker.checkForUpdate("2.0.0-beta");
    expect(release.isNewer, isTrue);
  });

  test("current build metadata is ignored in the comparison", () async {
    // PackageInfo may report "2.0.0+3"; the build metadata must not count.
    final checker = AppReleaseChecker(client: mockRelease("2.0.0"));
    final release = await checker.checkForUpdate("2.0.0+3");
    expect(release.isNewer, isFalse);
  });

  test("falls back to the releases page when html_url is absent", () async {
    final checker = AppReleaseChecker(client: mockRelease("2.1.0"));
    final release = await checker.checkForUpdate("2.0.0");
    expect(release.url, checker.releasesPageUrl);
  });

  test("uses the release's html_url when present", () async {
    const url = "https://github.com/mikyll/ROQuiz/releases/tag/v2.1.0";
    final checker = AppReleaseChecker(
      client: mockRelease("2.1.0", htmlUrl: url),
    );
    final release = await checker.checkForUpdate("2.0.0");
    expect(release.url, url);
  });

  test("a malformed tag is treated as not-newer (never a bogus update)",
      () async {
    final checker = AppReleaseChecker(client: mockRelease("not-a-version"));
    final release = await checker.checkForUpdate("2.0.0");
    expect(release.isNewer, isFalse);
  });

  test("a non-200 response throws", () async {
    final checker = AppReleaseChecker(
      client: MockClient((request) async {
        return http.Response(jsonEncode({"message": "Not Found"}), 404);
      }),
    );
    await expectLater(
      checker.checkForUpdate("2.0.0"),
      throwsA(isA<HttpException>()),
    );
  });

  test("a response without a tag_name throws", () async {
    final checker = AppReleaseChecker(
      client: MockClient((request) async {
        return http.Response(jsonEncode({"foo": "bar"}), 200);
      }),
    );
    await expectLater(
      checker.checkForUpdate("2.0.0"),
      throwsA(isA<FormatException>()),
    );
  });
}
