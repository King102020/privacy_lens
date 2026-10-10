import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/entities/tracker_sdk.dart';

/// Loads the versioned tracker SDK signatures bundled with the app.
class TrackerRulePackLoader {
  TrackerRulePackLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String assetPath = 'assets/rules/tracker_sdks.json';

  final AssetBundle _bundle;
  TrackerRulePack? _cached;

  Future<TrackerRulePack> load() async =>
      _cached ??= parse(await _bundle.loadString(assetPath));

  /// Entries with an unknown category or no prefixes are skipped rather than
  /// failing the whole pack.
  static TrackerRulePack parse(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, Object?>) {
      throw const FormatException('Rule pack must be a JSON object');
    }
    final version = json['version'];
    final trackers = json['trackers'];
    if (version is! String || trackers is! List<Object?>) {
      throw const FormatException('Rule pack needs version and trackers');
    }

    final sdks = <TrackerSdk>[];
    for (final entry in trackers) {
      if (entry is! Map<String, Object?>) continue;
      final id = entry['id'];
      final name = entry['name'];
      final category = TrackerCategory.values.asNameMap()[entry['category']];
      final prefixes = entry['classPrefixes'];
      if (id is! String || name is! String || category == null) continue;
      if (prefixes is! List<Object?>) continue;
      final classPrefixes = prefixes.whereType<String>().toList();
      if (classPrefixes.isEmpty) continue;
      sdks.add(
        TrackerSdk(
          id: id,
          name: name,
          category: category,
          classPrefixes: classPrefixes,
        ),
      );
    }
    return TrackerRulePack(version: version, sdks: sdks);
  }
}
