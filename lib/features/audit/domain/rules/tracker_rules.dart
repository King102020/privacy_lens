import '../entities/app_snapshot.dart';
import '../entities/finding.dart';
import '../entities/severity.dart';
import 'audit_rule.dart';

/// Known tracking SDKs found inside the app package itself.
class EmbeddedTrackersRule implements AuditRule {
  const EmbeddedTrackersRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (app.trackers.isEmpty) return null;
    final hasMarketing = app.trackers.any((sdk) => sdk.category.isMarketing);
    return Finding(
      type: FindingType.embeddedTrackers,
      severity: hasMarketing ? Severity.medium : Severity.low,
      packageName: app.packageName,
      evidence: [for (final sdk in app.trackers) TrackerSdkEvidence(sdk)],
      action: FindingAction.enableTrackerShield,
    );
  }
}

/// Tracker Shield blocked this app's attempts to reach known tracker domains.
class TrackerDomainContactsRule implements AuditRule {
  const TrackerDomainContactsRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (app.blockedDomains.isEmpty) return null;
    return Finding(
      type: FindingType.trackerDomainContacts,
      severity: Severity.low,
      packageName: app.packageName,
      evidence: [
        for (final blocked in app.blockedDomains)
          BlockedDomainEvidence(domain: blocked.domain, count: blocked.count),
      ],
      action: FindingAction.openAppSettings,
    );
  }
}
