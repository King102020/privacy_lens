import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/features/audit/domain/entities/audit_report.dart';
import 'package:privacy_lens/features/audit/domain/entities/capability.dart';
import 'package:privacy_lens/features/audit/domain/entities/finding.dart';
import 'package:privacy_lens/features/audit/domain/entities/severity.dart';
import 'package:privacy_lens/features/audit/domain/entities/special_access_kind.dart';
import 'package:privacy_lens/features/audit/domain/risk_engine.dart';

import '../../../helpers/fixtures.dart';

void main() {
  const engine = RiskEngine();

  test('empty scan is calm at 100', () {
    final report = engine.evaluate(
      apps: [snapshot(label: 'Notes')],
      completedAt: testNow,
      hadUsageAccess: true,
      now: testNow,
    );
    expect(report.posture.score, 100);
    expect(report.posture.level, PostureLevel.calm);
    expect(report.apps.single.riskLevel, RiskLevel.minimal);
  });

  test('one high finding is observant', () {
    final posture = engine.posture([
      Finding(
        type: FindingType.overlayWithAccessibility,
        severity: Severity.high,
        packageName: 'com.a',
        evidence: const [SpecialAccessEvidence(SpecialAccessKind.overlay)],
        action: FindingAction.openAppSettings,
      ),
    ]);
    expect(posture.score, 85);
    expect(posture.level, PostureLevel.observant);
  });

  test('three high findings need attention', () {
    Finding high(String package) => Finding(
      type: FindingType.accessibilityService,
      severity: Severity.high,
      packageName: package,
      evidence: const [
        SpecialAccessEvidence(SpecialAccessKind.accessibilityService),
        CapabilityEvidence(Capability.camera),
      ],
      action: FindingAction.openAppSettings,
    );
    final posture = engine.posture([high('a'), high('b'), high('c')]);
    expect(posture.level, PostureLevel.needsAttention);
  });

  test('sorts apps by risk then label', () {
    final report = engine.evaluate(
      apps: [
        snapshot(
          packageName: 'com.z',
          label: 'Zed',
          granted: {
            Capability.camera,
            Capability.microphone,
            Capability.preciseLocation,
            Capability.backgroundLocation,
          },
        ),
        snapshot(packageName: 'com.a', label: 'Able'),
        snapshot(packageName: 'com.m', label: 'Maybe', trackers: [crashSdk]),
      ],
      completedAt: testNow,
      hadUsageAccess: false,
      now: testNow,
    );
    expect(report.apps.map((audit) => audit.app.label).toList(), [
      'Zed',
      'Maybe',
      'Able',
    ]);
  });
}
