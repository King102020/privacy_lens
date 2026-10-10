import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_lens/features/audit/domain/entities/capability.dart';
import 'package:privacy_lens/features/audit/domain/entities/finding.dart';
import 'package:privacy_lens/features/audit/domain/entities/severity.dart';
import 'package:privacy_lens/features/audit/domain/risk_engine.dart';
import 'package:privacy_lens/features/settings/data/report_exporter.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('json and csv stay machine-readable', () {
    const engine = RiskEngine();
    final report = engine.evaluate(
      apps: [
        snapshot(
          packageName: 'com.cam',
          label: 'Cam, App',
          granted: {
            Capability.camera,
            Capability.microphone,
            Capability.preciseLocation,
          },
        ),
      ],
      completedAt: testNow,
      hadUsageAccess: true,
      now: testNow,
    );
    final json = ReportExporter.toJson(report);
    expect(json, contains('"packageName": "com.cam"'));
    expect(json, contains('sensorTrio'));

    final csv = ReportExporter.toCsv(report);
    expect(csv, contains('"Cam, App"'));
    expect(csv.split('\n').first, contains('package_name'));
    expect(report.findings.first.type, FindingType.sensorTrio);
    expect(report.findings.first.severity, Severity.medium);
  });
}
