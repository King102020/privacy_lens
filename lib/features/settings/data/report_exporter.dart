import 'dart:convert';

import '../../audit/data/evidence_codec.dart';
import '../../audit/domain/entities/audit_report.dart';

/// Serializes a report for the user's own records. Field values are stable
/// identifiers so the files stay machine-readable in any language.
abstract final class ReportExporter {
  static const int formatVersion = 1;

  static String toJson(AuditReport report) {
    final document = {
      'formatVersion': formatVersion,
      'generatedBy': 'Privacy Lens',
      'completedAt': report.completedAt.toUtc().toIso8601String(),
      'usageAccessGranted': report.hadUsageAccess,
      'posture': {
        'score': report.posture.score,
        'level': report.posture.level.name,
      },
      'apps': [
        for (final audit in report.apps)
          {
            'packageName': audit.app.packageName,
            'label': audit.app.label,
            'version': audit.app.versionName,
            'systemApp': audit.app.isSystemApp,
            'riskLevel': audit.riskLevel.name,
            'grantedCapabilities': [
              for (final capability in audit.app.granted) capability.name,
            ],
            'specialAccess': [
              for (final kind in audit.app.specialAccess) kind.name,
            ],
            'trackerSdks': [for (final sdk in audit.app.trackers) sdk.id],
            if (audit.app.usage case final usage?)
              'foregroundMinutesOnScanDay': usage.foreground.inMinutes,
            'findings': [
              for (final finding in audit.findings)
                {
                  'type': finding.type.name,
                  'severity': finding.severity.name,
                  'evidence': [
                    for (final evidence in finding.evidence)
                      () {
                        final (kind, value) = EvidenceCodec.encode(evidence);
                        return {'kind': kind, 'value': value};
                      }(),
                  ],
                },
            ],
          },
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(document);
  }

  static String toCsv(AuditReport report) {
    final buffer = StringBuffer()
      ..writeln('package_name,app_label,risk_level,finding,severity,evidence');
    for (final audit in report.apps) {
      for (final finding in audit.findings) {
        final evidence = finding.evidence
            .map(EvidenceCodec.encode)
            .map((pair) => '${pair.$1}:${pair.$2}')
            .join('; ');
        buffer.writeln(
          [
            audit.app.packageName,
            audit.app.label,
            audit.riskLevel.name,
            finding.type.name,
            finding.severity.name,
            evidence,
          ].map(_csvField).join(','),
        );
      }
    }
    return buffer.toString();
  }

  static String _csvField(String value) {
    final needsQuotes =
        value.contains(',') || value.contains('"') || value.contains('\n');
    if (!needsQuotes) return value;
    return '"${value.replaceAll('"', '""')}"';
  }
}
