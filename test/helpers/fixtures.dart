import 'package:privacy_lens/core/logging/app_logger.dart';
import 'package:privacy_lens/features/audit/domain/entities/app_snapshot.dart';
import 'package:privacy_lens/features/audit/domain/entities/capability.dart';
import 'package:privacy_lens/features/audit/domain/entities/special_access_kind.dart';
import 'package:privacy_lens/features/audit/domain/entities/tracker_sdk.dart';
import 'package:privacy_lens/features/audit/domain/rules/audit_rule.dart';

class SilentLogger implements AppLogger {
  const SilentLogger();

  @override
  void debug(String message) {}

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}

final DateTime testNow = DateTime.utc(2026, 10, 10, 12);
final AuditContext testContext = AuditContext(now: testNow);

const TrackerSdk adsSdk = TrackerSdk(
  id: 'ads',
  name: 'Ads SDK',
  category: TrackerCategory.advertising,
  classPrefixes: ['com.ads.sdk'],
);

const TrackerSdk crashSdk = TrackerSdk(
  id: 'crash',
  name: 'Crash SDK',
  category: TrackerCategory.crashReporting,
  classPrefixes: ['com.crash'],
);

AppSnapshot snapshot({
  String packageName = 'com.example.app',
  String label = 'Example',
  String? versionName = '1.0',
  bool isSystemApp = false,
  String? iconPath,
  DateTime? installedAt,
  DateTime? updatedAt,
  bool requestsInternet = true,
  Set<Capability> granted = const {},
  Set<SpecialAccessKind> specialAccess = const {},
  List<TrackerSdk> trackers = const [],
  AppUsage? usage,
  List<BlockedDomainCount> blockedDomains = const [],
}) => AppSnapshot(
  packageName: packageName,
  label: label,
  versionName: versionName,
  isSystemApp: isSystemApp,
  iconPath: iconPath,
  installedAt: installedAt ?? DateTime.utc(2025, 1, 1),
  updatedAt: updatedAt ?? DateTime.utc(2026, 1, 1),
  requestsInternet: requestsInternet,
  granted: granted,
  specialAccess: specialAccess,
  trackers: trackers,
  usage: usage,
  blockedDomains: blockedDomains,
);
