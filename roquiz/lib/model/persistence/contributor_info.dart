/// A statically-defined contributor, loaded from `assets/contributors.yaml`.
///
/// This is intentionally separate from [Contributor] (in `contributor.dart`),
/// which models data fetched from the GitHub API. [ContributorInfo] holds the
/// hand-curated info we ship with the app: a name, an optional link, an
/// optional local image and the list of contributions the person made.
class ContributorInfo {
  final String name;
  final String? url;
  final String? imagePath;
  final List<String> contributions;

  const ContributorInfo({
    required this.name,
    this.url,
    this.imagePath,
    this.contributions = const [],
  });

  /// Builds a [ContributorInfo] from a single YAML map node. Returns `null`
  /// when the node is malformed or has no usable name, so callers can skip it.
  static ContributorInfo? fromYaml(dynamic node) {
    if (node is! Map) return null;

    final String name = (node["name"] ?? "").toString().trim();
    if (name.isEmpty) return null;

    final String? url = _nonEmptyOrNull(node["url"]);
    final String? imagePath = _nonEmptyOrNull(node["image"]);

    final List<String> contributions = node["contributions"] is List
        ? (node["contributions"] as List)
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : <String>[];

    return ContributorInfo(
      name: name,
      url: url,
      imagePath: imagePath,
      contributions: contributions,
    );
  }

  /// The (up to two) uppercase initials used for the placeholder bubble when
  /// no image is available.
  String get initials {
    final parts = name.split(RegExp(r"[\s_-]+")).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return "?";
    if (parts.length == 1) {
      final p = parts.first;
      return (p.length == 1 ? p : p.substring(0, 2)).toUpperCase();
    }
    return (parts.first[0] + parts.elementAt(1)[0]).toUpperCase();
  }

  static String? _nonEmptyOrNull(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }
}
