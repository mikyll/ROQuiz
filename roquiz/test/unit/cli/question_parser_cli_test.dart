import 'dart:io';

import 'package:test/test.dart';

/// Integration tests for the CLI entry point in `bin/questions_parser.dart`.
/// These run the script in a subprocess so the real argument parsing, file I/O
/// and exit codes are exercised.
///
/// Run from the `roquiz/` directory (that is where `dart test` sets the CWD),
/// so the relative script path below resolves correctly.
void main() {
  const script = 'bin/questions_parser.dart';

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('roquiz_cli_test');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('parses a valid txt file and prints the total', () async {
    final file = File('${tempDir.path}/questions.txt');
    file.writeAsStringSync('''
@ Addition ==========
What is 2+2?
A. 3
B. 4
B''');

    final result = await Process.run('dart', ['run', script, file.path]);

    expect(result.exitCode, 0, reason: result.stderr.toString());
    expect(result.stdout, contains('Tot: 1'));
    expect(result.stdout, contains('Addition'));
  });

  test('--quiet validates without printing the breakdown', () async {
    final file = File('${tempDir.path}/questions.txt');
    file.writeAsStringSync('''
@ Addition ==========
What is 2+2?
A. 3
B. 4
B''');

    final result = await Process.run('dart', ['run', script, '-q', file.path]);

    expect(result.exitCode, 0, reason: result.stderr.toString());
    expect(result.stdout.toString().trim(), isEmpty);
  });

  test('--quiet still fails (non-zero) on a malformed file', () async {
    final file = File('${tempDir.path}/bad.txt');
    // Missing the correct-answer line.
    file.writeAsStringSync('''
What is 2+2?
A. 3
B. 4''');

    final result = await Process.run('dart', ['run', script, '-q', file.path]);

    expect(result.exitCode, isNonZero);
    expect(result.stderr.toString(), contains('Error:'));
  });

  test('exits non-zero for a missing file', () async {
    final result = await Process.run('dart', [
      'run',
      script,
      '${tempDir.path}/does_not_exist.txt',
    ]);

    expect(result.exitCode, isNonZero);
    expect(result.stderr.toString(), contains("doesn't exist"));
  });

  test('--help exits 0 and prints usage', () async {
    final result = await Process.run('dart', ['run', script, '--help']);

    expect(result.exitCode, 0);
    expect(result.stdout, contains('Usage:'));
  });
}
