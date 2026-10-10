import 'entities/app_snapshot.dart';
import 'entities/audit_report.dart';
import 'entities/finding.dart';
import 'entities/severity.dart';
import 'rules/audit_rule.dart';
import 'rules/permission_rules.dart';
import 'rules/special_access_rules.dart';
import 'rules/tracker_rules.dart';
import 'rules/usage_rules.dart';

/// Pure evaluation of observed facts into findings and an overall posture.
class RiskEngine {
  const RiskEngine({this.rules = defaultRules});

  static const List<AuditRule> defaultRules = [
    OverlayWithAccessibilityRule(),
    AccessibilityServiceRule(),
    SensorTrioRule(),
    NotificationListenerRule(),
    DeviceAdminRule(),
    BackgroundLocationRule(),
    MessagesAndCallLogsRule(),
    EmbeddedTrackersRule(),
    TrackerDomainContactsRule(),
    UnusedWithSensitiveAccessRule(),
  ];

  static const int highPenalty = 15;
  static const int mediumPenalty = 5;
  static const int lowPenalty = 1;
  static const int calmScoreThreshold = 80;
  static const int attentionScoreThreshold = 50;
  static const int attentionHighFindingCount = 3;

  final List<AuditRule> rules;

  AuditReport evaluate({
    required List<AppSnapshot> apps,
    required DateTime completedAt,
    required bool hadUsageAccess,
    required DateTime now,
  }) {
    final context = AuditContext(now: now);
    final audits = [for (final app in apps) _auditApp(app, context)]
      ..sort(_byRiskThenLabel);

    return AuditReport(
      completedAt: completedAt,
      hadUsageAccess: hadUsageAccess,
      apps: audits,
      posture: posture([for (final audit in audits) ...audit.findings]),
    );
  }

  DevicePosture posture(List<Finding> findings) {
    var penalty = 0;
    var highCount = 0;
    for (final finding in findings) {
      switch (finding.severity) {
        case Severity.high:
          penalty += highPenalty;
          highCount++;
        case Severity.medium:
          penalty += mediumPenalty;
        case Severity.low:
          penalty += lowPenalty;
      }
    }
    final score = (100 - penalty).clamp(0, 100);

    final PostureLevel level;
    if (highCount >= attentionHighFindingCount ||
        score < attentionScoreThreshold) {
      level = PostureLevel.needsAttention;
    } else if (highCount > 0 || score < calmScoreThreshold) {
      level = PostureLevel.observant;
    } else {
      level = PostureLevel.calm;
    }
    return DevicePosture(score: score, level: level);
  }

  AppAudit _auditApp(AppSnapshot app, AuditContext context) {
    final findings = [
      for (final rule in rules)
        if (rule.evaluate(app, context) case final finding?) finding,
    ]..sort((a, b) => b.severity.index.compareTo(a.severity.index));

    return AppAudit(
      app: app,
      findings: findings,
      riskLevel: RiskLevel.fromSeverity(
        Severity.highest(findings.map((finding) => finding.severity)),
      ),
    );
  }

  static int _byRiskThenLabel(AppAudit a, AppAudit b) {
    final byRisk = b.riskLevel.index.compareTo(a.riskLevel.index);
    if (byRisk != 0) return byRisk;
    return a.app.label.toLowerCase().compareTo(b.app.label.toLowerCase());
  }
}
