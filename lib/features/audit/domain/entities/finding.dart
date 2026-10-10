import 'package:equatable/equatable.dart';

import 'capability.dart';
import 'severity.dart';
import 'special_access_kind.dart';
import 'tracker_sdk.dart';

enum FindingCategory { permissions, specialAccess, trackers, hygiene }

enum FindingType {
  sensorTrio(FindingCategory.permissions),
  accessibilityService(FindingCategory.specialAccess),
  notificationListener(FindingCategory.specialAccess),
  deviceAdmin(FindingCategory.specialAccess),
  overlayWithAccessibility(FindingCategory.specialAccess),
  backgroundLocation(FindingCategory.permissions),
  messagesAndCallLogs(FindingCategory.permissions),
  embeddedTrackers(FindingCategory.trackers),
  trackerDomainContacts(FindingCategory.trackers),
  unusedWithSensitiveAccess(FindingCategory.hygiene);

  const FindingType(this.category);

  final FindingCategory category;
}

/// The one thing the user can do about a finding.
enum FindingAction { openAppSettings, enableTrackerShield }

/// A fact that supports a finding. Every finding carries at least one.
sealed class Evidence extends Equatable {
  const Evidence();
}

final class CapabilityEvidence extends Evidence {
  const CapabilityEvidence(this.capability);

  final Capability capability;

  @override
  List<Object?> get props => [capability];
}

final class SpecialAccessEvidence extends Evidence {
  const SpecialAccessEvidence(this.kind);

  final SpecialAccessKind kind;

  @override
  List<Object?> get props => [kind];
}

final class TrackerSdkEvidence extends Evidence {
  const TrackerSdkEvidence(this.sdk);

  final TrackerSdk sdk;

  @override
  List<Object?> get props => [sdk];
}

final class LastUsedEvidence extends Evidence {
  const LastUsedEvidence(this.lastUsedAt);

  /// Null when the app was not opened within the usage history window.
  final DateTime? lastUsedAt;

  @override
  List<Object?> get props => [lastUsedAt];
}

final class BlockedDomainEvidence extends Evidence {
  const BlockedDomainEvidence({required this.domain, required this.count});

  final String domain;
  final int count;

  @override
  List<Object?> get props => [domain, count];
}

class Finding extends Equatable {
  const Finding({
    required this.type,
    required this.severity,
    required this.packageName,
    required this.evidence,
    required this.action,
  }) : assert(evidence.length > 0, 'A finding needs evidence');

  final FindingType type;
  final Severity severity;
  final String packageName;
  final List<Evidence> evidence;
  final FindingAction action;

  FindingCategory get category => type.category;

  @override
  List<Object?> get props => [type, severity, packageName, evidence, action];
}
