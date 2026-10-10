import '../entities/app_snapshot.dart';
import '../entities/capability.dart';
import '../entities/finding.dart';
import '../entities/severity.dart';
import 'audit_rule.dart';

/// Sensitive permissions kept by an app nobody has opened in months.
class UnusedWithSensitiveAccessRule implements AuditRule {
  const UnusedWithSensitiveAccessRule({this.unusedAfter = defaultUnusedAfter});

  static const Duration defaultUnusedAfter = Duration(days: 90);

  final Duration unusedAfter;

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    final usage = app.usage;
    if (usage == null || app.isSystemApp) return null;

    final cutoff = context.now.subtract(unusedAfter);
    if (app.installedAt.isAfter(cutoff)) return null;

    final lastUsedAt = usage.lastUsedAt;
    if (lastUsedAt != null && lastUsedAt.isAfter(cutoff)) return null;

    final sensitive = app.sensitiveGranted;
    if (sensitive.isEmpty) return null;

    return Finding(
      type: FindingType.unusedWithSensitiveAccess,
      severity: Severity.low,
      packageName: app.packageName,
      evidence: [
        LastUsedEvidence(lastUsedAt),
        for (final capability in Capability.values)
          if (sensitive.contains(capability)) CapabilityEvidence(capability),
      ],
      action: FindingAction.openAppSettings,
    );
  }
}
