import 'package:equatable/equatable.dart';

import 'app_snapshot.dart';
import 'capability.dart';
import 'finding.dart';
import 'severity.dart';

class AppAudit extends Equatable {
  const AppAudit({
    required this.app,
    required this.findings,
    required this.riskLevel,
  });

  final AppSnapshot app;

  /// Sorted from most to least severe.
  final List<Finding> findings;
  final RiskLevel riskLevel;

  @override
  List<Object?> get props => [app, findings, riskLevel];
}

enum PostureLevel { calm, observant, needsAttention }

class DevicePosture extends Equatable {
  const DevicePosture({required this.score, required this.level});

  /// 0 to 100, higher is calmer.
  final int score;
  final PostureLevel level;

  @override
  List<Object?> get props => [score, level];
}

class AuditReport extends Equatable {
  const AuditReport({
    required this.completedAt,
    required this.hadUsageAccess,
    required this.apps,
    required this.posture,
  });

  final DateTime completedAt;
  final bool hadUsageAccess;

  /// Sorted from highest to lowest risk, then by label.
  final List<AppAudit> apps;
  final DevicePosture posture;

  List<Finding> get findings => [for (final audit in apps) ...audit.findings];

  int countFindings(Severity severity) =>
      findings.where((finding) => finding.severity == severity).length;

  int countApps(bool Function(AppSnapshot app) test) =>
      apps.where((audit) => test(audit.app)).length;

  int get appsWithLocation => countApps((app) => app.hasAnyLocation);

  int get appsWithMicrophone =>
      countApps((app) => app.has(Capability.microphone));

  int get appsWithCamera => countApps((app) => app.has(Capability.camera));

  int get appsWithTrackers => countApps((app) => app.trackers.isNotEmpty);

  AppAudit? auditFor(String packageName) {
    for (final audit in apps) {
      if (audit.app.packageName == packageName) return audit;
    }
    return null;
  }

  @override
  List<Object?> get props => [completedAt, hadUsageAccess, apps, posture];
}
