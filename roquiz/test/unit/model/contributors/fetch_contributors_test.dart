import 'package:roquiz/model/contributors/fetch_contributors.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('parseCoAuthorTrailers', () {
    test('resolves login and id from a noreply email with id', () {
      final coAuthors = parseCoAuthorTrailers(
        'feat: something\n\n'
        'Co-authored-by: Jane Doe <12345+janedoe@users.noreply.github.com>',
      );

      expect(coAuthors.length, 1);
      expect(coAuthors.first.name, 'Jane Doe');
      expect(coAuthors.first.login, 'janedoe');
      expect(coAuthors.first.id, 12345);
    });

    test('resolves login only from a noreply email without id', () {
      final coAuthors = parseCoAuthorTrailers(
        'fix\n\nCo-authored-by: John <john@users.noreply.github.com>',
      );

      expect(coAuthors.length, 1);
      expect(coAuthors.first.login, 'john');
      expect(coAuthors.first.id, isNull);
    });

    test('leaves login null for a non-noreply email', () {
      final coAuthors = parseCoAuthorTrailers(
        'chore\n\nCo-authored-by: Real Person <person@example.com>',
      );

      expect(coAuthors.length, 1);
      expect(coAuthors.first.login, isNull);
      expect(coAuthors.first.email, 'person@example.com');
    });

    test('skips the GitHub web-flow committer', () {
      final coAuthors = parseCoAuthorTrailers(
        'Co-authored-by: GitHub <noreply@users.noreply.github.com>',
      );
      // `noreply` is not `web-flow`, so it resolves; verify web-flow is dropped.
      final webFlow = parseCoAuthorTrailers(
        'Co-authored-by: GitHub <web-flow@users.noreply.github.com>',
      );

      expect(coAuthors.first.login, 'noreply');
      expect(webFlow.first.login, isNull);
    });

    test('is case-insensitive and parses multiple trailers', () {
      final coAuthors = parseCoAuthorTrailers(
        'title\n\n'
        'Co-Authored-By: A <1+a@users.noreply.github.com>\n'
        'co-authored-by: B <2+b@users.noreply.github.com>',
      );

      expect(coAuthors.map((c) => c.login), ['a', 'b']);
    });

    test('returns empty when there are no trailers', () {
      expect(parseCoAuthorTrailers('just a normal message'), isEmpty);
    });
  });

  group('CoAuthor', () {
    test('derives avatar and profile URLs from id/login', () {
      final withId = CoAuthor(name: 'A', email: 'x', login: 'a', id: 7);
      expect(withId.avatarUrl, 'https://avatars.githubusercontent.com/u/7?v=4');
      expect(withId.htmlUrl, 'https://github.com/a');

      final loginOnly = CoAuthor(name: 'B', email: 'y', login: 'b');
      expect(loginOnly.avatarUrl, 'https://github.com/b.png');

      final emailOnly = CoAuthor(name: 'C', email: 'c@example.com');
      expect(emailOnly.avatarUrl, isNull);
      expect(emailOnly.htmlUrl, isNull);
    });
  });

  group('FetchedContributor.fromJson', () {
    test('parses a well-formed node', () {
      final c = FetchedContributor.fromJson({
        'login': 'octocat',
        'id': 583231,
        'html_url': 'https://github.com/octocat',
        'avatar_url': 'https://avatars.githubusercontent.com/u/583231?v=4',
        'contributions': 42,
        'type': 'User',
      });

      expect(c, isNotNull);
      expect(c!.login, 'octocat');
      expect(c.id, 583231);
      expect(c.contributions, 42);
      expect(c.isBot, isFalse);
    });

    test('returns null for non-maps and empty logins', () {
      expect(FetchedContributor.fromJson('nope'), isNull);
      expect(FetchedContributor.fromJson({'login': '   '}), isNull);
    });

    test('flags bot accounts by type or [bot] suffix', () {
      final byType = FetchedContributor.fromJson({
        'login': 'something',
        'type': 'Bot',
      });
      final bySuffix = FetchedContributor.fromJson({
        'login': 'github-actions[bot]',
        'type': 'User',
      });

      expect(byType!.isBot, isTrue);
      expect(bySuffix!.isBot, isTrue);
    });
  });

  group('mergeCoAuthors', () {
    FetchedContributor contributor({
      required String login,
      int id = 0,
      int contributions = 0,
    }) => FetchedContributor(
      login: login,
      id: id,
      htmlUrl: '',
      avatarUrl: '',
      contributions: contributions,
      type: 'User',
    );

    test('bumps coAuthored on a match by id', () {
      final contributors = [contributor(login: 'a', id: 1, contributions: 5)];
      mergeCoAuthors(contributors, [
        CoAuthor(name: 'A', email: 'x', login: 'different', id: 1, count: 3),
      ]);

      expect(contributors.length, 1);
      expect(contributors.first.coAuthored, 3);
    });

    test('bumps coAuthored on a match by login (case-insensitive)', () {
      final contributors = [contributor(login: 'Alice', id: 2)];
      mergeCoAuthors(contributors, [
        CoAuthor(name: 'Alice', email: 'x', login: 'alice', count: 2),
      ]);

      expect(contributors.first.coAuthored, 2);
    });

    test('appends co-authors that are not already present', () {
      final contributors = [contributor(login: 'a', id: 1)];
      mergeCoAuthors(contributors, [
        CoAuthor(name: 'New Person', email: 'np', login: 'np', id: 9, count: 4),
      ]);

      expect(contributors.length, 2);
      final added = contributors.last;
      expect(added.login, 'np');
      expect(added.coAuthored, 4);
      expect(added.contributions, 0);
    });
  });

  group('buildYaml', () {
    test('emits avatar and co_authored only when present, and round-trips', () {
      final contributors = [
        FetchedContributor(
          login: 'mikyll',
          id: 56556806,
          htmlUrl: 'https://github.com/mikyll',
          avatarUrl: 'https://avatars.githubusercontent.com/u/56556806?v=4',
          contributions: 549,
          type: 'User',
          coAuthored: 2,
        )..localAvatar = 'assets/contributors/avatars/mikyll.png',
        FetchedContributor(
          login: 'noavatar',
          id: 0,
          htmlUrl: '',
          avatarUrl: '',
          contributions: 1,
          type: 'User',
        ),
      ];

      final yaml = buildYaml('mikyll/ROQuiz', contributors);

      expect(yaml, contains('avatar: assets/contributors/avatars/mikyll.png'));
      expect(yaml, contains('co_authored: 2'));

      // The second entry has no avatar/co_authored, so those keys are omitted.
      final parsed = loadYaml(yaml);
      final list = parsed['contributors'] as List;
      expect(list.length, 2);
      expect(list[0]['name'], 'mikyll');
      expect(list[0]['avatar'], 'assets/contributors/avatars/mikyll.png');
      expect(list[0]['contributions'], 549);
      expect(list[1]['avatar'], isNull);
      expect(list[1].containsKey('co_authored'), isFalse);
    });
  });
}
