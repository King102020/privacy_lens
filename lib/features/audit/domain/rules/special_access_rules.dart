import '../entities/app_snapshot.dart';
import '../entities/capability.dart';
import '../entities/finding.dart';
import '../entities/severity.dart';
import '../entities/special_access_kind.dart';
import 'audit_rule.dart';

/// An accessibility service can read the screen and act on the user's behalf.
class AccessibilityServiceRule implements AuditRule {
  const AccessibilityServiceRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (!app.hasSpecial(SpecialAccessKind.accessibilityService)) return null;
    final sensitive = app.sensitiveGranted;
    return Finding(
      type: FindingType.accessibilityService,
      severity: sensitive.isEmpty ? Severity.medium : Severity.high,
      packageName: app.packageName,
      evidence: [
        const SpecialAccessEvidence(SpecialAccessKind.accessibilityService),
        for (final capability in Capability.values)
          if (sensitive.contains(capability)) CapabilityEvidence(capability),
      ],
      action: FindingAction.openAppSettings,
    );
  }
}

/// Notification access exposes message previews and one-time codes.
class NotificationListenerRule implements AuditRule {
  const NotificationListenerRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (!app.hasSpecial(SpecialAccessKind.notificationListener)) return null;
    return Finding(
      type: FindingType.notificationListener,
      severity: app.isSystemApp ? Severity.low : Severity.medium,
      packageName: app.packageName,
      evidence: const [
        SpecialAccessEvidence(SpecialAccessKind.notificationListener),
      ],
      action: FindingAction.openAppSettings,
    );
  }
}

class DeviceAdminRule implements AuditRule {
  const DeviceAdminRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (!app.hasSpecial(SpecialAccessKind.deviceAdmin)) return null;
    return Finding(
      type: FindingType.deviceAdmin,
      severity: app.isSystemApp ? Severity.low : Severity.medium,
      packageName: app.packageName,
      evidence: const [SpecialAccessEvidence(SpecialAccessKind.deviceAdmin)],
      action: FindingAction.openAppSettings,
    );
  }
}

/// Drawing over other apps plus accessibility is the classic pattern used to
/// fake sign-in screens and capture what the user types.
class OverlayWithAccessibilityRule implements AuditRule {
  const OverlayWithAccessibilityRule();

  @override
  Finding? evaluate(AppSnapshot app, AuditContext context) {
    if (!app.hasSpecial(SpecialAccessKind.overlay) ||
        !app.hasSpecial(SpecialAccessKind.accessibilityService)) {
      return null;
    }
    return Finding(
      type: FindingType.overlayWithAccessibility,
      severity: Severity.high,
      packageName: app.packageName,
      evidence: const [
        SpecialAccessEvidence(SpecialAccessKind.overlay),
        SpecialAccessEvidence(SpecialAccessKind.accessibilityService),
      ],
      action: FindingAction.openAppSettings,
    );
  }
}
