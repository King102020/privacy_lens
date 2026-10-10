import 'package:equatable/equatable.dart';

import 'capability.dart';
import 'special_access_kind.dart';
import 'tracker_sdk.dart';

/// Usage facts. Present only when the user granted Usage Access.
class AppUsage extends Equatable {
  const AppUsage({
    required this.day,
    required this.foreground,
    required this.lastUsedAt,
  });

  /// Local day the foreground time was measured on (the day of the scan).
  final DateTime day;
  final Duration foreground;

  /// Null when the app was not opened within the usage history window.
  final DateTime? lastUsedAt;

  @override
  List<Object?> get props => [day, foreground, lastUsedAt];
}

class BlockedDomainCount extends Equatable {
  const BlockedDomainCount({required this.domain, required this.count});

  final String domain;
  final int count;

  @override
  List<Object?> get props => [domain, count];
}

/// Everything the auditor observed about one installed app.
class AppSnapshot extends Equatable {
  const AppSnapshot({
    required this.packageName,
    required this.label,
    required this.versionName,
    required this.isSystemApp,
    required this.iconPath,
    required this.installedAt,
    required this.updatedAt,
    required this.requestsInternet,
    required this.granted,
    required this.specialAccess,
    required this.trackers,
    required this.usage,
    required this.blockedDomains,
  });

  final String packageName;
  final String label;
  final String? versionName;
  final bool isSystemApp;
  final String? iconPath;
  final DateTime installedAt;
  final DateTime updatedAt;
  final bool requestsInternet;
  final Set<Capability> granted;
  final Set<SpecialAccessKind> specialAccess;
  final List<TrackerSdk> trackers;
  final AppUsage? usage;
  final List<BlockedDomainCount> blockedDomains;

  bool has(Capability capability) => granted.contains(capability);

  bool get hasAnyLocation =>
      has(Capability.preciseLocation) || has(Capability.approximateLocation);

  bool hasSpecial(SpecialAccessKind kind) => specialAccess.contains(kind);

  Set<Capability> get sensitiveGranted =>
      granted.intersection(sensitiveDataCapabilities);

  @override
  List<Object?> get props => [
    packageName,
    label,
    versionName,
    isSystemApp,
    iconPath,
    installedAt,
    updatedAt,
    requestsInternet,
    granted,
    specialAccess,
    trackers,
    usage,
    blockedDomains,
  ];
}
