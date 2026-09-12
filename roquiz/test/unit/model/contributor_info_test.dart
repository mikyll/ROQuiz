import 'package:roquiz/model/persistence/contributor_info.dart';
import 'package:test/test.dart';

void main() {
  group('ContributorInfo.fromYaml', () {
    test('parses a fetched-style entry (numeric contributions)', () {
      final info = ContributorInfo.fromYaml({
        'name': 'mikyll',
        'id': 56556806,
        'url': 'https://github.com/mikyll',
        'avatar': 'assets/contributors/avatars/mikyll.png',
        'avatar_url': 'https://avatars.githubusercontent.com/u/56556806?v=4',
        'contributions': 549,
        'co_authored': 3,
      });

      expect(info, isNotNull);
      expect(info!.name, 'mikyll');
      expect(info.id, 56556806);
      expect(info.imagePath, 'assets/contributors/avatars/mikyll.png');
      expect(info.imageUrl, isNotNull);
      expect(info.contributionCount, 549);
      expect(info.coAuthored, 3);
      expect(info.contributions, isEmpty);
    });

    test('parses a curated-style entry (list of contributions)', () {
      final info = ContributorInfo.fromYaml({
        'name': 'Curated Person',
        'contributions': ['Idea', 'Testing'],
      });

      expect(info!.contributions, ['Idea', 'Testing']);
      expect(info.contributionCount, 0);
    });

    test('coerces string ids and trims empty optionals to null', () {
      final info = ContributorInfo.fromYaml({
        'name': 'x',
        'id': '42',
        'url': '   ',
        'avatar': '',
      });

      expect(info!.id, 42);
      expect(info.url, isNull);
      expect(info.imagePath, isNull);
    });

    test('returns null for non-maps and missing names', () {
      expect(ContributorInfo.fromYaml('nope'), isNull);
      expect(ContributorInfo.fromYaml({'name': '   '}), isNull);
      expect(ContributorInfo.fromYaml({'id': 1}), isNull);
    });
  });

  group('weight', () {
    test('prefers GitHub counts (contributions + co-authored)', () {
      const info = ContributorInfo(
        name: 'x',
        contributionCount: 10,
        coAuthored: 2,
      );
      expect(info.weight, 12);
    });

    test('falls back to the number of curated contribution lines', () {
      const info = ContributorInfo(
        name: 'x',
        contributions: ['a', 'b', 'c'],
      );
      expect(info.weight, 3);
    });
  });

  group('initials', () {
    test('uses two leading letters of a single-word name', () {
      expect(const ContributorInfo(name: 'mikyll').initials, 'MI');
    });

    test('uses the first letter of the first two words', () {
      expect(const ContributorInfo(name: 'Federico Andrucci').initials, 'FA');
    });

    test('splits on underscores and hyphens', () {
      expect(const ContributorInfo(name: 'fabioc-alt').initials, 'FA');
    });

    test('handles a single-character name and falls back to ?', () {
      expect(const ContributorInfo(name: 'a').initials, 'A');
      expect(const ContributorInfo(name: '_').initials, '?');
    });
  });
}
