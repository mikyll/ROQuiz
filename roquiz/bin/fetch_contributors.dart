import 'dart:io';

import 'package:roquiz/model/contributors/fetch_contributors.dart';

/// CLI tool that fetches the list of contributors of a GitHub repository and
/// writes the `assets/contributors/contributors.yaml` file consumed by
/// ViewContributors.
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
/// The fetching/rendering logic lives in
/// `lib/model/contributors/fetch_contributors.dart`; this file only wraps it in
/// a command-line interface.
///
/// Usage:
///   dart run bin/fetch_contributors.dart [options]
///   dart run roquiz:fetch_contributors [options]
///
/// Options:
///   -r, --repo `<owner/name>`   Repository to fetch (default: mikyll/ROQuiz)
///   -o, --output `<path>`       Output YAML file
///                               (default: assets/contributors/contributors.yaml)
///   -a, --avatars               Download avatar images into the avatars dir
///       --avatars-dir `<path>`  Where to save avatars
///                               (default: assets/contributors/avatars)
///       --include-bots          Keep bot accounts (e.g. github-actions[bot])
///       --token `<token>`       GitHub token, raises the API rate limit
///   -h, --help                  Show this help

const String _defaultRepo = "mikyll/ROQuiz";
const String _defaultOutput = "assets/contributors/contributors.yaml";
const String _defaultAvatarsDir = "assets/contributors/avatars";

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

const String _usage =
    '''
Fetch GitHub contributors into a YAML file.

Usage:
  dart run bin/fetch_contributors.dart [options]

Options:
  -r, --repo <owner/name>   Repository to fetch (default: $_defaultRepo)
  -o, --output <path>       Output YAML file (default: $_defaultOutput)
  -a, --avatars             Download avatar images locally
      --avatars-dir <path>  Avatars directory (default: $_defaultAvatarsDir)
                            (avatar: paths in the YAML point here)
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
