import 'dart:io';

import 'package:roquiz/model/quiz/question.dart';
import 'package:roquiz/model/quiz/question_parser.dart';

const String _usage = '''
Usage: dart run roquiz:questions_parser [options] <file>

Parses a questions file and prints a per-topic breakdown and the total count.
Exits non-zero if the file is missing or fails to parse, so it can be used as a
validation gate in CI.

Options:
  -t, --type <txt|yaml>   Force the file format instead of inferring it.
  -q, --quiet             Validate only: suppress stdout, still report errors.
  -h, --help              Show this help and exit.
''';

void _printTopics(List<Question> questions) {
  String res = "Topics:\n";
  int curr = 0;
  Map<String, int> topicSizes = getTopicSizes(questions);

  for (String topic in topicSizes.keys) {
    int num = topicSizes[topic] ?? 0;

    res += "- $topic: $num (+$curr)\n";
    curr += num;
  }
  stdout.writeln(res);
}

/// Thrown for user-facing CLI errors (bad arguments, missing file, ...). The
/// message is printed to stderr and the process exits with code 1.
class _CliException implements Exception {
  final String message;
  _CliException(this.message);
  @override
  String toString() => message;
}

QuestionFormat _parseType(String value) {
  try {
    return QuestionFormat.values.byName(value.toLowerCase());
  } on ArgumentError {
    throw _CliException(
      "Invalid type '$value'. Expected one of: "
      "${QuestionFormat.values.map((f) => f.name).join(', ')}",
    );
  }
}

void _run(List<String> args) {
  QuestionFormat? fileType;
  bool quiet = false;
  String? filePath;

  for (int i = 0; i < args.length; i++) {
    final arg = args[i];

    if (arg == "-h" || arg == "--help") {
      stdout.writeln(_usage);
      return;
    }

    if (arg == "-q" || arg == "--quiet") {
      quiet = true;
      continue;
    }

    if (arg == "-t" || arg == "--type") {
      i++;
      if (i >= args.length) {
        throw _CliException("Missing file type after ${args[i - 1]}");
      }
      fileType = _parseType(args[i]);
      continue;
    }

    if (arg.startsWith("-")) {
      throw _CliException("Unknown option '$arg'");
    }

    if (filePath != null) {
      throw _CliException("Unexpected extra argument '$arg'");
    }
    filePath = arg;
  }

  if (filePath == null || filePath.isEmpty) {
    throw _CliException("Missing file path.\n\n$_usage");
  }

  final File file = File(filePath);
  if (!file.existsSync()) {
    throw _CliException("File '$filePath' doesn't exist");
  }

  final content = file.readAsStringSync();

  // If fileType not provided, try inferring it
  fileType ??= inferQuestionFormat(content);

  final List<Question> questions;
  switch (fileType) {
    case QuestionFormat.txt:
      questions = parseQuestionsFromTxt(content);
      break;
    case QuestionFormat.yaml:
      questions = parseQuestionsFromYaml(content);
      break;
    case null:
      throw _CliException("Couldn't infer file type for '$filePath'");
  }

  if (!quiet) {
    _printTopics(questions);
    stdout.writeln("Tot: ${questions.length}");
  }
}

void main(List<String> args) {
  try {
    _run(args);
  } catch (e) {
    stderr.writeln("Error: $e");
    exit(1);
  }
}
