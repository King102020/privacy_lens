import 'package:flutter/material.dart';

import '../../features/audit/domain/entities/audit_report.dart';
import '../../features/audit/domain/entities/severity.dart';
import '../extensions/context_extensions.dart';
import '../presentation/label_maps.dart';
import 'tonal_badge.dart';

class SeverityBadge extends StatelessWidget {
  const SeverityBadge({required this.severity, super.key});

  final Severity severity;

  @override
  Widget build(BuildContext context) => TonalBadge(
    label: severity.label(context.l10n),
    tone: severity.tone(context),
  );
}

class RiskBadge extends StatelessWidget {
  const RiskBadge({required this.level, super.key});

  final RiskLevel level;

  @override
  Widget build(BuildContext context) =>
      TonalBadge(label: level.label(context.l10n), tone: level.tone(context));
}

class PostureBadge extends StatelessWidget {
  const PostureBadge({required this.level, super.key});

  final PostureLevel level;

  @override
  Widget build(BuildContext context) =>
      TonalBadge(label: level.label(context.l10n), tone: level.tone(context));
}
