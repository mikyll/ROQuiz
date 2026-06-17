import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// CLI tool that fetches the list of contributors of a GitHub repository and
/// writes the `assets/contributors.yaml` file consumed by ViewContributors.
///
/// For each contributor it stores the GitHub login, numeric id, profile URL,
/// avatar URL (and, optionally, a downloaded local copy) and the number of
/// contributions reported by the GitHub API.
///
/// The GitHub `/contributors` endpoint only credits the commit author, so by
/// default this tool also scans the commit history for `Co-authored-by:`
/// trailers and merges those people in (resolving GitHub `noreply` emails to
/// logins/ids/avatars where possible). Disable with `--no-coauthors`.
///
/// Usage:
///   dart run lib/cli/fetch_contributors.dart [options]
///
/// Options:
///   -r, --repo `<owner/name>`   Repository to fetch (default: mikyll/ROQuiz)
///   -o, --output `<path>`       Output YAML file
///                               (default: assets/contributors.yaml)
///   -a, --avatars               Download avatar images into the avatars dir
///       --avatars-dir `<path>`  Where to save avatars
///                               (default: assets/contributors)
///       --include-bots          Keep bot accounts (e.g. github-actions[bot])
///       --token `<token>`       GitHub token, raises the API rate limit
///   -h, --help                  Show this help

const String _defaultRepo = "mikyll/ROQuiz";
const String _defaultOutput = "assets/contributors.yaml";
const String _defaultAvatarsDir = "assets/contributors";

/// A single contributor as returned by the GitHub `/contributors` endpoint,
/// reduced to the fields we care about.
class FetchedContributor {
  final String login;
  final int id;
  final String htmlUrl;
  final String avatarUrl;
  final int contributions;
  final String type;

  /// Number of commits this person was credited on via a `Co-authored-by:`
  /// trailer. Independent from [contributions] (which only counts commits
  /// where the person is the GitHub-resolved author).
  int coAuthored;

  /// Local asset path of the downloaded avatar, set only when `--avatars` is
  /// used and the download succeeds.
  String? localAvatar;

  FetchedContributor({
    required this.login,
    required this.id,
    required this.htmlUrl,
    required this.avatarUrl,
    required this.contributions,
    required this.type,
    this.coAuthored = 0,
  });

  bool get isBot => type.toLowerCase() == "bot" || login.endsWith("[bot]");

  /// Combined weight used only to order the output; authoring and co-authoring
  /// aren't really the same unit, but this keeps prolific people near the top.
  int get rank => contributions + coAuthored;

  static FetchedContributor? fromJson(dynamic node) {
    if (node is! Map) return null;

    final String login = (node["login"] ?? "").toString().trim();
    if (login.isEmpty) return null;

    return FetchedContributor(
      login: login,
      id: node["id"] is int ? node["id"] as int : 0,
      htmlUrl: (node["html_url"] ?? "").toString(),
      avatarUrl: (node["avatar_url"] ?? "").toString(),
      contributions: node["contributions"] is int
          ? node["contributions"] as int
          : 0,
      type: (node["type"] ?? "User").toString(),
    );
  }
}

/// Fetches every contributor of [repo], following pagination until the API
/// returns an empty page.
Future<List<FetchedContributor>> fetchContributors(
  String repo, {
  String? token,
}) async {
  final List<FetchedContributor> contributors = [];
  final Map<String, String> headers = _githubHeaders(token);

  for (int page = 1; ; page++) {
    final Uri uri = Uri.parse(
      "https://api.github.com/repos/$repo/contributors"
      "?per_page=100&page=$page",
    );

    final http.Response response = await http.get(uri, headers: headers);
    final dynamic decoded = _decodeOrThrow(response, uri);
    if (decoded is! List || decoded.isEmpty) break;

    for (final node in decoded) {
      final FetchedContributor? c = FetchedContributor.fromJson(node);
      if (c != null) contributors.add(c);
    }

    // Last page reached (fewer than the requested page size).
    if (decoded.length < 100) break;
  }

  return contributors;
}

Map<String, String> _githubHeaders(String? token) {
  final Map<String, String> headers = {
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
  };
  if (token != null && token.isNotEmpty) {
    headers["Authorization"] = "Bearer $token";
  }
  return headers;
}

/// Decodes a GitHub JSON response, turning non-200 statuses into a readable
/// [HttpException] (surfacing the API's own `message`, e.g. rate-limit hints).
dynamic _decodeOrThrow(http.Response response, Uri uri) {
  if (response.statusCode != 200) {
    String message = response.body;
    try {
      message = (jsonDecode(response.body)["message"] ?? message).toString();
    } catch (_) {}
    throw HttpException(
      "GitHub API error (${response.statusCode}): $message",
      uri: uri,
    );
  }
  return jsonDecode(response.body);
}

/// A person credited through one or more `Co-authored-by:` commit trailers.
/// [login]/[id] are filled in only when the email is a GitHub `noreply`
/// address, which encodes them; otherwise we only know the name and email.
class CoAuthor {
  final String name;
  final String email;
  final String? login;
  final int? id;
  int count;

  CoAuthor({
    required this.name,
    required this.email,
    this.login,
    this.id,
    this.count = 0,
  });

  /// Stable de-duplication key: prefer the resolved login, fall back to email.
  String get key => (login ?? email).toLowerCase();

  String? get avatarUrl {
    if (id != null) return "https://avatars.githubusercontent.com/u/$id?v=4";
    if (login != null) return "https://github.com/$login.png";
    return null;
  }

  String? get htmlUrl => login != null ? "https://github.com/$login" : null;
}

final RegExp _coAuthorTrailer = RegExp(
  r"^\s*co-authored-by:\s*(.+?)\s*<([^>]+)>\s*$",
  multiLine: true,
  caseSensitive: false,
);

// `1234567+login@users.noreply.github.com` or `login@users.noreply.github.com`.
final RegExp _noreplyWithId = RegExp(
  r"^(\d+)\+([^@]+)@users\.noreply\.github\.com$",
  caseSensitive: false,
);
final RegExp _noreplyNoId = RegExp(
  r"^([^@]+)@users\.noreply\.github\.com$",
  caseSensitive: false,
);

/// Parses the `Co-authored-by:` trailers out of a single commit message.
List<CoAuthor> parseCoAuthorTrailers(String message) {
  final List<CoAuthor> result = [];
  for (final m in _coAuthorTrailer.allMatches(message)) {
    final String name = m.group(1)!.trim();
    final String email = m.group(2)!.trim();

    String? login;
    int? id;
    final withId = _noreplyWithId.firstMatch(email);
    if (withId != null) {
      id = int.tryParse(withId.group(1)!);
      login = withId.group(2);
    } else {
      final noId = _noreplyNoId.firstMatch(email);
      // The `web-flow` login is GitHub's own committer for web edits, not a
      // real person — skip it.
      if (noId != null && noId.group(1)!.toLowerCase() != "web-flow") {
        login = noId.group(1);
      }
    }

    result.add(CoAuthor(name: name, email: email, login: login, id: id));
  }
  return result;
}

/// Walks the commit history of [repo] and tallies every co-author, counting how
/// many commits each one was credited on.
Future<List<CoAuthor>> fetchCoAuthors(String repo, {String? token}) async {
  final Map<String, CoAuthor> byKey = {};
  final Map<String, String> headers = _githubHeaders(token);

  for (int page = 1; ; page++) {
    final Uri uri = Uri.parse(
      "https://api.github.com/repos/$repo/commits?per_page=100&page=$page",
    );

    final http.Response response = await http.get(uri, headers: headers);
    final dynamic decoded = _decodeOrThrow(response, uri);
    if (decoded is! List || decoded.isEmpty) break;

    for (final commit in decoded) {
      final String message = (commit is Map &&
              commit["commit"] is Map &&
              commit["commit"]["message"] != null)
          ? commit["commit"]["message"].toString()
          : "";
      if (message.isEmpty) continue;

      for (final ca in parseCoAuthorTrailers(message)) {
        final CoAuthor existing = byKey.putIfAbsent(ca.key, () => ca);
        existing.count++;
      }
    }

    if (decoded.length < 100) break;
  }

  return byKey.values.toList();
}

/// Folds co-authors into [contributors]: matching people (by id, else by
/// login) get their [FetchedContributor.coAuthored] count bumped; everyone
/// else is appended as a new, co-author-only entry.
void mergeCoAuthors(
  List<FetchedContributor> contributors,
  List<CoAuthor> coAuthors,
) {
  for (final ca in coAuthors) {
    FetchedContributor? match;
    for (final c in contributors) {
      final bool sameId = ca.id != null && ca.id == c.id;
      final bool sameLogin = ca.login != null &&
          ca.login!.toLowerCase() == c.login.toLowerCase();
      if (sameId || sameLogin) {
        match = c;
        break;
      }
    }

    if (match != null) {
      match.coAuthored += ca.count;
    } else {
      contributors.add(
        FetchedContributor(
          login: ca.login ?? ca.name,
          id: ca.id ?? 0,
          htmlUrl: ca.htmlUrl ?? "",
          avatarUrl: ca.avatarUrl ?? "",
          contributions: 0,
          type: "User",
          coAuthored: ca.count,
        ),
      );
    }
  }
}

/// Downloads the avatar of [c] into [dir], naming the file after the login and
/// using the extension inferred from the response content type. Sets
/// [FetchedContributor.localAvatar] on success and returns the saved path.
Future<String?> downloadAvatar(FetchedContributor c, String dir) async {
  if (c.avatarUrl.isEmpty) return null;

  try {
    final http.Response response = await http.get(Uri.parse(c.avatarUrl));
    if (response.statusCode != 200) return null;

    final String ext = _extensionFor(response.headers["content-type"]);
    final String fileName = "${_sanitize(c.login)}$ext";
    final String path = "$dir/$fileName";

    Directory(dir).createSync(recursive: true);
    File(path).writeAsBytesSync(response.bodyBytes);

    c.localAvatar = path;
    return path;
  } catch (_) {
    return null;
  }
}

String _extensionFor(String? contentType) {
  switch ((contentType ?? "").split(";").first.trim().toLowerCase()) {
    case "image/jpeg":
    case "image/jpg":
      return ".jpeg";
    case "image/gif":
      return ".gif";
    case "image/webp":
      return ".webp";
    case "image/png":
    default:
      return ".png";
  }
}

/// Strips characters that would be awkward in a file name, keeping the result
/// recognizable (GitHub logins are already restricted, this is just defensive).
String _sanitize(String login) =>
    login.replaceAll(RegExp(r"[^A-Za-z0-9._-]"), "_");

/// Renders the contributors as YAML matching the shape of
/// `assets/contributors.yaml`, with the GitHub-sourced fields.
String buildYaml(String repo, List<FetchedContributor> contributors) {
  final StringBuffer b = StringBuffer();

  b.writeln("# Contributors fetched from the GitHub API for `$repo`.");
  b.writeln("# Generated by lib/cli/fetch_contributors.dart on");
  b.writeln("# ${DateTime.now().toUtc().toIso8601String()} (UTC).");
  b.writeln("# Each entry:");
  b.writeln("#   name:          GitHub login");
  b.writeln("#   id:            numeric GitHub user id");
  b.writeln("#   url:           profile page");
  b.writeln("#   avatar:        local asset path (when downloaded)");
  b.writeln("#   avatar_url:    remote avatar image");
  b.writeln("#   contributions: number of contributions reported by GitHub");
  b.writeln("#   co_authored:   commits credited via Co-authored-by: trailers");
  b.writeln("contributors:");

  for (final c in contributors) {
    b.writeln("  - name: ${_yamlScalar(c.login)}");
    b.writeln("    id: ${c.id}");
    if (c.htmlUrl.isNotEmpty) {
      b.writeln("    url: ${_yamlScalar(c.htmlUrl)}");
    }
    if (c.localAvatar != null) {
      b.writeln("    avatar: ${_yamlScalar(c.localAvatar!)}");
    }
    if (c.avatarUrl.isNotEmpty) {
      b.writeln("    avatar_url: ${_yamlScalar(c.avatarUrl)}");
    }
    b.writeln("    type: ${_yamlScalar(c.type)}");
    b.writeln("    contributions: ${c.contributions}");
    if (c.coAuthored > 0) {
      b.writeln("    co_authored: ${c.coAuthored}");
    }
    b.writeln();
  }

  return b.toString();
}

/// Quotes a scalar only when needed so the output stays valid YAML while
/// keeping unambiguous values (like URLs) unquoted, matching the style of the
/// hand-curated `contributors.yaml`.
String _yamlScalar(String value) {
  final bool needsQuotes =
      value.isEmpty ||
      RegExp(r'^\s|\s$').hasMatch(value) || // leading/trailing whitespace
      value.contains(": ") || // colon followed by space is a mapping
      value.endsWith(":") ||
      value.contains(" #") || // start of a comment
      RegExp(r'''^[#\[\]{}&*!|>%@`",-?]''').hasMatch(value); // indicator start
  if (!needsQuotes) return value;
  return '"${value.replaceAll(r"\", r"\\").replaceAll('"', r'\"')}"';
}

class _Options {
  String repo = _defaultRepo;
  String output = _defaultOutput;
  String avatarsDir = _defaultAvatarsDir;
  bool downloadAvatars = false;
  bool includeBots = false;
  bool coAuthors = true;
  String? token;
  bool help = false;
}

_Options _parseArgs(List<String> args) {
  final _Options o = _Options();

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case "-r":
      case "--repo":
        o.repo = _requireValue(args, ++i, "--repo");
        break;
      case "-o":
      case "--output":
        o.output = _requireValue(args, ++i, "--output");
        break;
      case "-a":
      case "--avatars":
        o.downloadAvatars = true;
        break;
      case "--avatars-dir":
        o.avatarsDir = _requireValue(args, ++i, "--avatars-dir");
        break;
      case "--include-bots":
        o.includeBots = true;
        break;
      case "--coauthors":
        o.coAuthors = true;
        break;
      case "--no-coauthors":
        o.coAuthors = false;
        break;
      case "--token":
        o.token = _requireValue(args, ++i, "--token");
        break;
      case "-h":
      case "--help":
        o.help = true;
        break;
      default:
        throw FormatException("Unknown argument: ${args[i]}");
    }
  }

  return o;
}

String _requireValue(List<String> args, int i, String flag) {
  if (i >= args.length) throw FormatException("Missing value after $flag");
  return args[i];
}

const String _usage = '''
Fetch GitHub contributors into a YAML file.

Usage:
  dart run lib/cli/fetch_contributors.dart [options]

Options:
  -r, --repo <owner/name>   Repository to fetch (default: $_defaultRepo)
  -o, --output <path>       Output YAML file (default: $_defaultOutput)
  -a, --avatars             Download avatar images locally
      --avatars-dir <path>  Avatars directory (default: $_defaultAvatarsDir)
      --include-bots        Keep bot accounts (e.g. github-actions[bot])
      --no-coauthors        Skip scanning commits for Co-authored-by: trailers
      --token <token>       GitHub token to raise the API rate limit
  -h, --help                Show this help
''';

void main(List<String> args) async {
  late final _Options options;
  try {
    options = _parseArgs(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln();
    stderr.writeln(_usage);
    exitCode = 64; // EX_USAGE
    return;
  }

  if (options.help) {
    stdout.write(_usage);
    return;
  }

  // The token can also come from the environment, so it never has to be typed
  // on the command line.
  options.token ??= Platform.environment["GITHUB_TOKEN"];

  try {
    stdout.writeln("Fetching contributors of ${options.repo}...");
    List<FetchedContributor> contributors = await fetchContributors(
      options.repo,
      token: options.token,
    );

    if (options.coAuthors) {
      stdout.writeln("Scanning commits for co-authors...");
      final List<CoAuthor> coAuthors = await fetchCoAuthors(
        options.repo,
        token: options.token,
      );
      final int before = contributors.length;
      mergeCoAuthors(contributors, coAuthors);
      final int added = contributors.length - before;
      stdout.writeln(
        "Found ${coAuthors.length} co-author(s) "
        "($added not already in the contributors list).",
      );
    }

    if (!options.includeBots) {
      final int before = contributors.length;
      contributors = contributors.where((c) => !c.isBot).toList();
      final int removed = before - contributors.length;
      if (removed > 0) stdout.writeln("Skipped $removed bot account(s).");
    }

    // Order by combined author + co-author weight so prolific people stay on
    // top regardless of API ordering.
    contributors.sort((a, b) => b.rank.compareTo(a.rank));

    stdout.writeln("Found ${contributors.length} contributor(s).");

    if (options.downloadAvatars) {
      stdout.writeln("Downloading avatars into ${options.avatarsDir}...");
      for (final c in contributors) {
        final String? path = await downloadAvatar(c, options.avatarsDir);
        stdout.writeln(
          path != null ? "  ${c.login} -> $path" : "  ${c.login} (skipped)",
        );
      }
    }

    final String yaml = buildYaml(options.repo, contributors);
    final File outFile = File(options.output);
    outFile.parent.createSync(recursive: true);
    outFile.writeAsStringSync(yaml);

    stdout.writeln("Wrote ${options.output}");
  } on HttpException catch (e) {
    stderr.writeln("Error: ${e.message}");
    exitCode = 1;
  } catch (e) {
    stderr.writeln("Error: $e");
    exitCode = 1;
  }
}
