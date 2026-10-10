import 'package:flutter/material.dart';

import '../../core/theme/severity_colors.dart';
import '../../features/audit/domain/audit_repository.dart';
import '../../features/audit/domain/entities/audit_report.dart';
import '../../features/audit/domain/entities/capability.dart';
import '../../features/audit/domain/entities/finding.dart';
import '../../features/audit/domain/entities/severity.dart';
import '../../features/audit/domain/entities/special_access_kind.dart';
import '../../features/audit/domain/entities/tracker_sdk.dart';
import '../../l10n/gen/app_localizations.dart';
import '../extensions/context_extensions.dart';

extension CapabilityLabels on Capability {
  String label(AppLocalizations l10n) => switch (this) {
    Capability.camera => l10n.capabilityCamera,
    Capability.microphone => l10n.capabilityMicrophone,
    Capability.preciseLocation => l10n.capabilityPreciseLocation,
    Capability.approximateLocation => l10n.capabilityApproximateLocation,
    Capability.backgroundLocation => l10n.capabilityBackgroundLocation,
    Capability.contacts => l10n.capabilityContacts,
    Capability.sms => l10n.capabilitySms,
    Capability.callLog => l10n.capabilityCallLog,
    Capability.phone => l10n.capabilityPhone,
    Capability.calendar => l10n.capabilityCalendar,
    Capability.bodySensors => l10n.capabilityBodySensors,
    Capability.physicalActivity => l10n.capabilityPhysicalActivity,
    Capability.mediaAndFiles => l10n.capabilityMediaAndFiles,
    Capability.nearbyDevices => l10n.capabilityNearbyDevices,
  };

  IconData get icon => switch (this) {
    Capability.camera => Icons.photo_camera_outlined,
    Capability.microphone => Icons.mic_none,
    Capability.preciseLocation => Icons.my_location_outlined,
    Capability.approximateLocation => Icons.location_on_outlined,
    Capability.backgroundLocation => Icons.location_searching,
    Capability.contacts => Icons.contacts_outlined,
    Capability.sms => Icons.sms_outlined,
    Capability.callLog => Icons.call_outlined,
    Capability.phone => Icons.phone_outlined,
    Capability.calendar => Icons.calendar_today_outlined,
    Capability.bodySensors => Icons.monitor_heart_outlined,
    Capability.physicalActivity => Icons.directions_run,
    Capability.mediaAndFiles => Icons.folder_outlined,
    Capability.nearbyDevices => Icons.bluetooth_outlined,
  };
}

extension SpecialAccessLabels on SpecialAccessKind {
  String label(AppLocalizations l10n) => switch (this) {
    SpecialAccessKind.accessibilityService => l10n.specialAccessibility,
    SpecialAccessKind.notificationListener => l10n.specialNotificationListener,
    SpecialAccessKind.deviceAdmin => l10n.specialDeviceAdmin,
    SpecialAccessKind.overlay => l10n.specialOverlay,
  };

  IconData get icon => switch (this) {
    SpecialAccessKind.accessibilityService => Icons.accessibility_new,
    SpecialAccessKind.notificationListener => Icons.notifications_outlined,
    SpecialAccessKind.deviceAdmin => Icons.admin_panel_settings_outlined,
    SpecialAccessKind.overlay => Icons.layers_outlined,
  };
}

extension TrackerCategoryLabels on TrackerCategory {
  String label(AppLocalizations l10n) => switch (this) {
    TrackerCategory.advertising => l10n.categoryAdvertising,
    TrackerCategory.analytics => l10n.categoryAnalytics,
    TrackerCategory.attribution => l10n.categoryAttribution,
    TrackerCategory.profiling => l10n.categoryProfiling,
    TrackerCategory.crashReporting => l10n.categoryCrashReporting,
  };
}

extension SeverityLabels on Severity {
  String label(AppLocalizations l10n) => switch (this) {
    Severity.low => l10n.severityLow,
    Severity.medium => l10n.severityMedium,
    Severity.high => l10n.severityHigh,
  };

  ToneColors tone(BuildContext context) {
    final colors = context.severityColors;
    return switch (this) {
      Severity.low => colors.low,
      Severity.medium => colors.medium,
      Severity.high => colors.high,
    };
  }
}

extension RiskLevelLabels on RiskLevel {
  String label(AppLocalizations l10n) => switch (this) {
    RiskLevel.minimal => l10n.riskMinimal,
    RiskLevel.low => l10n.riskLow,
    RiskLevel.medium => l10n.riskMedium,
    RiskLevel.high => l10n.riskHigh,
  };

  ToneColors tone(BuildContext context) {
    final colors = context.severityColors;
    return switch (this) {
      RiskLevel.minimal || RiskLevel.low => colors.low,
      RiskLevel.medium => colors.medium,
      RiskLevel.high => colors.high,
    };
  }
}

extension PostureLabels on PostureLevel {
  String label(AppLocalizations l10n) => switch (this) {
    PostureLevel.calm => l10n.postureCalm,
    PostureLevel.observant => l10n.postureObservant,
    PostureLevel.needsAttention => l10n.postureNeedsAttention,
  };

  String hint(AppLocalizations l10n) => switch (this) {
    PostureLevel.calm => l10n.postureCalmHint,
    PostureLevel.observant => l10n.postureObservantHint,
    PostureLevel.needsAttention => l10n.postureNeedsAttentionHint,
  };

  ToneColors tone(BuildContext context) {
    final colors = context.severityColors;
    return switch (this) {
      PostureLevel.calm => colors.low,
      PostureLevel.observant => colors.medium,
      PostureLevel.needsAttention => colors.high,
    };
  }
}

extension FindingTypeLabels on FindingType {
  String title(AppLocalizations l10n) => switch (this) {
    FindingType.sensorTrio => l10n.findingSensorTrioTitle,
    FindingType.accessibilityService => l10n.findingAccessibilityTitle,
    FindingType.notificationListener => l10n.findingNotificationListenerTitle,
    FindingType.deviceAdmin => l10n.findingDeviceAdminTitle,
    FindingType.overlayWithAccessibility => l10n.findingOverlayTitle,
    FindingType.backgroundLocation => l10n.findingBackgroundLocationTitle,
    FindingType.messagesAndCallLogs => l10n.findingMessagesTitle,
    FindingType.embeddedTrackers => l10n.findingEmbeddedTrackersTitle,
    FindingType.trackerDomainContacts => l10n.findingTrackerDomainsTitle,
    FindingType.unusedWithSensitiveAccess => l10n.findingUnusedTitle,
  };

  String body(AppLocalizations l10n) => switch (this) {
    FindingType.sensorTrio => l10n.findingSensorTrioBody,
    FindingType.accessibilityService => l10n.findingAccessibilityBody,
    FindingType.notificationListener => l10n.findingNotificationListenerBody,
    FindingType.deviceAdmin => l10n.findingDeviceAdminBody,
    FindingType.overlayWithAccessibility => l10n.findingOverlayBody,
    FindingType.backgroundLocation => l10n.findingBackgroundLocationBody,
    FindingType.messagesAndCallLogs => l10n.findingMessagesBody,
    FindingType.embeddedTrackers => l10n.findingEmbeddedTrackersBody,
    FindingType.trackerDomainContacts => l10n.findingTrackerDomainsBody,
    FindingType.unusedWithSensitiveAccess => l10n.findingUnusedBody,
  };
}

extension FindingActionLabels on FindingAction {
  String label(AppLocalizations l10n) => switch (this) {
    FindingAction.openAppSettings => l10n.actionOpenSettings,
    FindingAction.enableTrackerShield => l10n.actionEnableShield,
  };
}

extension ScanProgressLabels on ScanProgress {
  String label(AppLocalizations l10n) => switch (phase) {
    ScanPhase.collecting => l10n.scanCollecting,
    ScanPhase.scanningPackages => l10n.scanScanningPackages(scanned, total),
    ScanPhase.analyzing => l10n.scanAnalyzing,
  };
}
