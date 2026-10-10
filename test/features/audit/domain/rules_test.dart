import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/features/audit/domain/entities/app_snapshot.dart';
import 'package:privacy_lens/features/audit/domain/entities/capability.dart';
import 'package:privacy_lens/features/audit/domain/entities/finding.dart';
import 'package:privacy_lens/features/audit/domain/entities/severity.dart';
import 'package:privacy_lens/features/audit/domain/entities/special_access_kind.dart';
import 'package:privacy_lens/features/audit/domain/rules/permission_rules.dart';
import 'package:privacy_lens/features/audit/domain/rules/special_access_rules.dart';
import 'package:privacy_lens/features/audit/domain/rules/tracker_rules.dart';
import 'package:privacy_lens/features/audit/domain/rules/usage_rules.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('SensorTrioRule', () {
    test('is silent without the three sensors', () {
      expect(
        const SensorTrioRule().evaluate(
          snapshot(granted: {Capability.camera, Capability.microphone}),
          testContext,
        ),
        isNull,
      );
    });

    test('is high when background location is also granted', () {
      final finding = const SensorTrioRule().evaluate(
        snapshot(
          granted: {
            Capability.camera,
            Capability.microphone,
            Capability.preciseLocation,
            Capability.backgroundLocation,
          },
        ),
        testContext,
      );
      expect(finding?.severity, Severity.high);
      expect(finding?.type, FindingType.sensorTrio);
    });

    test('is medium without background location', () {
      final finding = const SensorTrioRule().evaluate(
        snapshot(
          granted: {
            Capability.camera,
            Capability.microphone,
            Capability.approximateLocation,
          },
        ),
        testContext,
      );
      expect(finding?.severity, Severity.medium);
    });
  });

  group('BackgroundLocationRule', () {
    test('is medium for a user app', () {
      expect(
        const BackgroundLocationRule()
            .evaluate(
              snapshot(granted: {Capability.backgroundLocation}),
              testContext,
            )
            ?.severity,
        Severity.medium,
      );
    });

    test('is low for a system app', () {
      expect(
        const BackgroundLocationRule()
            .evaluate(
              snapshot(
                isSystemApp: true,
                granted: {Capability.backgroundLocation},
              ),
              testContext,
            )
            ?.severity,
        Severity.low,
      );
    });
  });

  group('MessagesAndCallLogsRule', () {
    test('fires when SMS or call logs are granted', () {
      expect(
        const MessagesAndCallLogsRule().evaluate(
          snapshot(granted: {Capability.sms}),
          testContext,
        ),
        isNotNull,
      );
    });
  });

  group('AccessibilityServiceRule', () {
    test('is high with sensitive capabilities', () {
      expect(
        const AccessibilityServiceRule()
            .evaluate(
              snapshot(
                granted: {Capability.camera},
                specialAccess: {SpecialAccessKind.accessibilityService},
              ),
              testContext,
            )
            ?.severity,
        Severity.high,
      );
    });

    test('is medium without sensitive capabilities', () {
      expect(
        const AccessibilityServiceRule()
            .evaluate(
              snapshot(specialAccess: {SpecialAccessKind.accessibilityService}),
              testContext,
            )
            ?.severity,
        Severity.medium,
      );
    });
  });

  group('NotificationListenerRule and DeviceAdminRule', () {
    test('fire on the matching special access', () {
      expect(
        const NotificationListenerRule().evaluate(
          snapshot(specialAccess: {SpecialAccessKind.notificationListener}),
          testContext,
        ),
        isNotNull,
      );
      expect(
        const DeviceAdminRule().evaluate(
          snapshot(specialAccess: {SpecialAccessKind.deviceAdmin}),
          testContext,
        ),
        isNotNull,
      );
    });
  });

  group('OverlayWithAccessibilityRule', () {
    test('needs both overlay and accessibility', () {
      expect(
        const OverlayWithAccessibilityRule().evaluate(
          snapshot(specialAccess: {SpecialAccessKind.overlay}),
          testContext,
        ),
        isNull,
      );
      expect(
        const OverlayWithAccessibilityRule()
            .evaluate(
              snapshot(
                specialAccess: {
                  SpecialAccessKind.overlay,
                  SpecialAccessKind.accessibilityService,
                },
              ),
              testContext,
            )
            ?.severity,
        Severity.high,
      );
    });
  });

  group('EmbeddedTrackersRule', () {
    test('is medium for marketing SDKs and low otherwise', () {
      expect(
        const EmbeddedTrackersRule()
            .evaluate(snapshot(trackers: [adsSdk]), testContext)
            ?.severity,
        Severity.medium,
      );
      expect(
        const EmbeddedTrackersRule()
            .evaluate(snapshot(trackers: [crashSdk]), testContext)
            ?.severity,
        Severity.low,
      );
    });
  });

  group('TrackerDomainContactsRule', () {
    test('records blocked domains', () {
      final finding = const TrackerDomainContactsRule().evaluate(
        snapshot(
          blockedDomains: [
            const BlockedDomainCount(domain: 'ads.example.com', count: 3),
          ],
        ),
        testContext,
      );
      expect(finding?.type, FindingType.trackerDomainContacts);
      expect(finding?.evidence, isNotEmpty);
    });
  });

  group('UnusedWithSensitiveAccessRule', () {
    test('skips system apps, recent installs, and recently used apps', () {
      const rule = UnusedWithSensitiveAccessRule();
      expect(
        rule.evaluate(
          snapshot(
            isSystemApp: true,
            granted: {Capability.camera},
            usage: AppUsage(
              day: testNow,
              foreground: Duration.zero,
              lastUsedAt: null,
            ),
          ),
          testContext,
        ),
        isNull,
      );
      expect(
        rule.evaluate(
          snapshot(
            installedAt: testNow.subtract(const Duration(days: 10)),
            granted: {Capability.camera},
            usage: AppUsage(
              day: testNow,
              foreground: Duration.zero,
              lastUsedAt: null,
            ),
          ),
          testContext,
        ),
        isNull,
      );
      expect(
        rule.evaluate(
          snapshot(
            granted: {Capability.camera},
            usage: AppUsage(
              day: testNow,
              foreground: const Duration(minutes: 2),
              lastUsedAt: testNow.subtract(const Duration(days: 2)),
            ),
          ),
          testContext,
        ),
        isNull,
      );
    });

    test('flags an unused app that still holds sensitive access', () {
      final finding = const UnusedWithSensitiveAccessRule().evaluate(
        snapshot(
          granted: {Capability.contacts},
          usage: AppUsage(
            day: testNow,
            foreground: Duration.zero,
            lastUsedAt: testNow.subtract(const Duration(days: 120)),
          ),
        ),
        testContext,
      );
      expect(finding?.type, FindingType.unusedWithSensitiveAccess);
    });
  });
}
