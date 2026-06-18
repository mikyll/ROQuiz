/// A statically-defined contributor, loaded from
/// `assets/contributors/contributors.yaml`.
///
/// This is intentionally separate from [Contributor] (in `contributor.dart`),
/// which models data fetched from the GitHub API. [ContributorInfo] holds the
/// hand-curated info we ship with the app: a name, an optional link, an
/// optional local image and the list of contributions the person made.
class ContributorInfo {
  final String name;

  /// Numeric GitHub user id, present in `fetched_contributors.yaml`.
  final int? id;
  final String? url;

  /// Local asset path (`avatar:`), used when the image is bundled with the app.
  final String? imagePath;

  /// Remote avatar URL (`avatar_url:`), used when no local asset is available.
  final String? imageUrl;

  /// Hand-written contribution descriptions (curated `contributors.yaml`).
  final List<String> contributions;

  /// Number of commits authored, as reported by the GitHub API
  /// (`fetched_contributors.yaml`). Zero for the curated list.
  final int contributionCount;

  /// Number of commits credited via `Co-authored-by:` trailers.
  final int coAuthored;

  const ContributorInfo({
    required this.name,
    this.id,
    this.url,
    this.imagePath,
    this.imageUrl,
    this.contributions = const [],
    this.contributionCount = 0,
    this.coAuthored = 0,
  });

  /// Relative weight used to size the bubble: prefer the real GitHub counts and
  /// fall back to the number of hand-written contribution lines.
  int get weight {
    final int total = contributionCount + coAuthored;
    return total > 0 ? total : contributions.length;
  }

  /// Builds a [ContributorInfo] from a single YAML map node. Handles both the
  /// hand-curated `contributors.yaml` (where `contributions` is a list of
  /// descriptions) and `fetched_contributors.yaml` (where `contributions` is a
  /// numeric count, alongside `id`, `avatar_url` and `co_authored`). Returns
  /// `null` when the node is malformed or has no usable name.
  static ContributorInfo? fromYaml(dynamic node) {
    if (node is! Map) return null;

    final String name = (node["name"] ?? "").toString().trim();
    if (name.isEmpty) return null;

    final int? id = _asInt(node["id"]);
    final String? url = _nonEmptyOrNull(node["url"]);
    final String? imagePath = _nonEmptyOrNull(node["avatar"]);
    final String? imageUrl = _nonEmptyOrNull(node["avatar_url"]);

    // `contributions` is either a list of textual descriptions or a count.
    final dynamic contribNode = node["contributions"];
    List<String> contributions = const [];
    int contributionCount = 0;
    if (contribNode is List) {
      contributions = contribNode
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (contribNode != null) {
      contributionCount = _asInt(contribNode) ?? 0;
    }

    return ContributorInfo(
      name: name,
      id: id,
      url: url,
      imagePath: imagePath,
      imageUrl: imageUrl,
      contributions: contributions,
      contributionCount: contributionCount,
      coAuthored: _asInt(node["co_authored"]) ?? 0,
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

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString().trim());
  }
}
