import 'package:equatable/equatable.dart';

enum TrackerCategory {
  advertising,
  analytics,
  attribution,
  profiling,
  crashReporting;

  /// Categories whose main purpose is following people for marketing.
  bool get isMarketing =>
      this == advertising || this == attribution || this == profiling;
}

class TrackerSdk extends Equatable {
  const TrackerSdk({
    required this.id,
    required this.name,
    required this.category,
    required this.classPrefixes,
  });

  final String id;
  final String name;
  final TrackerCategory category;

  /// Java package prefixes that identify the SDK inside an app package.
  final List<String> classPrefixes;

  @override
  List<Object?> get props => [id, name, category, classPrefixes];
}

/// Versioned tracker signatures shipped inside the app.
class TrackerRulePack extends Equatable {
  const TrackerRulePack({required this.version, required this.sdks});

  final String version;
  final List<TrackerSdk> sdks;

  TrackerSdk? byId(String id) {
    for (final sdk in sdks) {
      if (sdk.id == id) return sdk;
    }
    return null;
  }

  @override
  List<Object?> get props => [version, sdks];
}
