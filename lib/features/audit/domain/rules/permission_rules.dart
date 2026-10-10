import '../entities/app_snapshot.dart';
import '../entities/capability.dart';
import '../entities/finding.dart';
import '../entities/severity.dart';
import 'audit_rule.dart';

/// Camera, microphone, and location together cover sight, sound, and place.
class SensorTrioRule implements AuditRule {
  const SensorTrioRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (!app.has(Capability.camera) ||
        !app.has(Capability.microphone) ||
        !app.hasAnyLocation) {
      return null;
    }
    final hasBackgroundLocation = app.has(Capability.backgroundLocation);
    return Finding(
      type: FindingType.sensorTrio,
      severity: hasBackgroundLocation ? Severity.high : Severity.medium,
      packageName: app.packageName,
      evidence: [
        const CapabilityEvidence(Capability.camera),
        const CapabilityEvidence(Capability.microphone),
        CapabilityEvidence(
          app.has(Capability.preciseLocation)
              ? Capability.preciseLocation
              : Capability.approximateLocation,
        ),
        if (hasBackgroundLocation)
          const CapabilityEvidence(Capability.backgroundLocation),
      ],
      action: FindingAction.openAppSettings,
    );
  }
}

class BackgroundLocationRule implements AuditRule {
  const BackgroundLocationRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (!app.has(Capability.backgroundLocation)) return null;
    return Finding(
      type: FindingType.backgroundLocation,
      severity: app.isSystemApp ? Severity.low : Severity.medium,
      packageName: app.packageName,
      evidence: const [CapabilityEvidence(Capability.backgroundLocation)],
      action: FindingAction.openAppSettings,
    );
  }
}

/// Messages and call history often contain sign-in codes and contacts.
class MessagesAndCallLogsRule implements AuditRule {
  const MessagesAndCallLogsRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    final evidence = [
      if (app.has(Capability.sms)) const CapabilityEvidence(Capability.sms),
      if (app.has(Capability.callLog))
        const CapabilityEvidence(Capability.callLog),
    ];
    if (evidence.isEmpty) return null;
    return Finding(
      type: FindingType.messagesAndCallLogs,
      severity: app.isSystemApp ? Severity.low : Severity.medium,
      packageName: app.packageName,
      evidence: evidence,
      action: FindingAction.openAppSettings,
    );
  }
}
