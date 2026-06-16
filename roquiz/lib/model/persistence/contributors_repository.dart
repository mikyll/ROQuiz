import 'package:flutter/services.dart' show rootBundle;
import 'package:roquiz/model/persistence/contributor_info.dart';
import 'package:yaml/yaml.dart';

/// Loads the static contributors list bundled with the app.
class ContributorsRepository {
  static const String defaultAssetPath = "assets/contributors.yaml";

  /// Reads and parses the contributors YAML asset. Malformed entries are
  /// skipped; a malformed/missing file yields an empty list rather than
  /// throwing, so the view can degrade gracefully.
  static Future<List<ContributorInfo>> load([
    String assetPath = defaultAssetPath,
  ]) async {
    final String raw = await rootBundle.loadString(assetPath);
    final dynamic doc = loadYaml(raw);

    final dynamic list = doc is Map ? doc["contributors"] : null;
    if (list is! List) return <ContributorInfo>[];

    return list
        .map(ContributorInfo.fromYaml)
        .whereType<ContributorInfo>()
        .toList();
  }
}
