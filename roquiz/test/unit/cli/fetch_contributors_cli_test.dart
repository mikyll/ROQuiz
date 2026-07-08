import 'dart:io';

import 'package:test/test.dart';

/// Integration tests for the CLI wrapper in `bin/fetch_contributors.dart`. Only
/// the argument-handling paths that exit *before* any network call are covered
/// (`--help`, bad arguments), so these stay hermetic — the fetching logic is
/// tested directly in `test/unit/model/contributors/fetch_contributors_test.dart`.
///
/// Run from the `roquiz/` directory (that is where `dart test` sets the CWD),
/// so the relative script path below resolves correctly.
void main() {
  const script = 'bin/fetch_contributors.dart';

  test('--help exits 0 and prints usage', () async {
    final result = await Process.run('dart', ['run', script, '--help']);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('Usage:'));
  });

  test('unknown argument exits 64 (EX_USAGE)', () async {
    final result = await Process.run('dart', ['run', script, '--bogus']);

    expect(result.exitCode, 64);
    expect(result.stderr.toString(), contains('Unknown argument'));
  });
}
