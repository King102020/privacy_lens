import 'package:equatable/equatable.dart';

import '../../audit/domain/entities/tracker_sdk.dart';

class ShieldPolicy extends Equatable {
  const ShieldPolicy({
    required this.enabledCategories,
    required this.extraBlocked,
    required this.allowed,
    required this.countsByCategory,
  });

  final Set<TrackerCategory> enabledCategories;
  final List<String> extraBlocked;
  final List<String> allowed;
  final Map<TrackerCategory, int> countsByCategory;

  @override
  List<Object?> get props => [
    enabledCategories,
    extraBlocked,
    allowed,
    countsByCategory,
  ];
}

class TrackerShieldStatus extends Equatable {
  const TrackerShieldStatus({
    required this.isRunning,
    required this.blocklistVersion,
    required this.blocklistSize,
  });

  final bool isRunning;
  final String blocklistVersion;
  final int blocklistSize;

  @override
  List<Object?> get props => [isRunning, blocklistVersion, blocklistSize];
}

class BlockedDomainSummary extends Equatable {
  const BlockedDomainSummary({
    required this.domain,
    required this.category,
    required this.packageName,
    required this.count,
    required this.lastBlockedAt,
  });

  final String domain;

  /// Null when the domain is not in the bundled catalog.
  final TrackerCategory? category;

  /// Null when Android could not attribute the lookup to an app.
  final String? packageName;
  final int count;
  final DateTime lastBlockedAt;

  @override
  List<Object?> get props => [
    domain,
    category,
    packageName,
    count,
    lastBlockedAt,
  ];
}

/// Blocked lookups kept within the DNS log retention window.
class ShieldActivity extends Equatable {
  const ShieldActivity({
    required this.summaries,
    required this.blockedTodayByHour,
    required this.totalBlocked,
    required this.distinctDomains,
    required this.distinctApps,
  });

  static const ShieldActivity empty = ShieldActivity(
    summaries: [],
    blockedTodayByHour: [],
    totalBlocked: 0,
    distinctDomains: 0,
    distinctApps: 0,
  );

  /// Most-blocked first.
  final List<BlockedDomainSummary> summaries;

  /// 24 entries, local hours 0 to 23. Empty when nothing was blocked today.
  final List<int> blockedTodayByHour;
  final int totalBlocked;
  final int distinctDomains;
  final int distinctApps;

  bool get isEmpty => totalBlocked == 0;

  @override
  List<Object?> get props => [
    summaries,
    blockedTodayByHour,
    totalBlocked,
    distinctDomains,
    distinctApps,
  ];
}
