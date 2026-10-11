import 'package:flutter/services.dart';

import '../../audit/domain/entities/tracker_sdk.dart';

/// Category lookup for the tracker domains the VPN service blocks. Reads the
/// same asset the Kotlin blocklist uses, so both sides always agree.
class TrackerDomainCatalog {
  TrackerDomainCatalog._(this.version, this._categories);

  static const String assetPath = 'assets/rules/tracker_domains.txt';
  static const String _versionPrefix = '# version:';

  static const List<TrackerCategory> shieldCategories = [
    TrackerCategory.advertising,
    TrackerCategory.analytics,
    TrackerCategory.attribution,
    TrackerCategory.profiling,
  ];

  final String version;
  final Map<String, TrackerCategory> _categories;

  int get size => _categories.length;

  Map<TrackerCategory, int> get countsByCategory {
    final counts = {for (final category in shieldCategories) category: 0};
    for (final category in _categories.values) {
      counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  static Future<TrackerDomainCatalog> load({AssetBundle? bundle}) async =>
      parse(await (bundle ?? rootBundle).loadString(assetPath));

  static TrackerDomainCatalog parse(String source) {
    var version = 'unknown';
    final categories = <String, TrackerCategory>{};
    for (final raw in source.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith(_versionPrefix)) {
        version = line.substring(_versionPrefix.length).trim();
        continue;
      }
      if (line.startsWith('#')) continue;
      final parts = line.split(RegExp(r'\s+'));
      final category = parts.length > 1
          ? TrackerCategory.values.asNameMap()[parts[1]]
          : null;
      if (category != null) categories[parts.first.toLowerCase()] = category;
    }
    return TrackerDomainCatalog._(version, categories);
  }

  /// Matches the domain or its closest listed parent domain.
  TrackerCategory? categoryFor(String domain) {
    var candidate = domain.toLowerCase();
    while (candidate.isNotEmpty) {
      final category = _categories[candidate];
      if (category != null) return category;
      final dot = candidate.indexOf('.');
      if (dot < 0) return null;
      candidate = candidate.substring(dot + 1);
    }
    return null;
  }
}
