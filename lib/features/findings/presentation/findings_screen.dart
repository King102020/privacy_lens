import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/presentation/failure_text.dart';
import '../../../shared/presentation/label_maps.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/lens_app_bar.dart';
import '../../../shared/widgets/local_only_banner.dart';
import '../../../shared/widgets/page_padding.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/severity_badge.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../access/presentation/access_cubit.dart';
import '../../audit/domain/entities/audit_report.dart';
import '../../audit/domain/entities/finding.dart';
import '../../audit/domain/entities/severity.dart';
import '../../audit/presentation/audit_cubit.dart';
import 'findings_filter_cubit.dart';

class FindingsScreen extends StatelessWidget {
  const FindingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FindingsFilterCubit(),
      child: const _FindingsView(),
    );
  }
}

class _FindingsView extends StatelessWidget {
  const _FindingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LensAppBar(),
      body: ConstrainedContent(
        child: Column(
          children: [
            LocalOnlyBanner(sectionLabel: context.l10n.findingsSectionLabel),
            Expanded(
              child: BlocBuilder<AuditCubit, AuditState>(
                builder: (context, audit) {
                  final report = audit.report;
                  if (report == null) {
                    if (audit is AuditFailure) {
                      return ErrorView(
                        message: audit.failure.message(context.l10n),
                        onRetry: () => context.read<AuditCubit>().loadLatest(),
                      );
                    }
                    if (audit is AuditLoading || audit is AuditScanning) {
                      return const LoadingView();
                    }
                    return MessageView(
                      icon: Icons.verified_outlined,
                      title: context.l10n.findingsEmptyTitle,
                      message: context.l10n.findingsEmptyBody,
                      actionLabel: context.l10n.homeRunAudit,
                      onAction: () => context.read<AuditCubit>().scan(),
                    );
                  }
                  return _FindingsList(report: report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FindingsList extends StatelessWidget {
  const _FindingsList({required this.report});

  final AuditReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<FindingsFilterCubit, FindingsFilterState>(
      builder: (context, filterState) {
        final visible = filterState.apply(report.findings);
        return Column(
          children: [
            Padding(
              padding: pageInsets(context).copyWith(bottom: 0),
              child: Text(
                l10n.findingsIdentified(report.findings.length),
                style: context.textStyles.bodyMedium,
              ),
            ),
            SizedBox(
              height: AppDimensions.filterChipHeight + AppSpacing.md,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: pageInsets(context).left,
                ),
                children: [
                  for (final option in FindingsFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        selected: filterState.filter == option,
                        label: Text(switch (option) {
                          FindingsFilter.all => l10n.findingsFilterAll(
                            filterState.count(report.findings, option),
                          ),
                          FindingsFilter.high => l10n.findingsFilterHigh(
                            filterState.count(report.findings, option),
                          ),
                          FindingsFilter.trackers =>
                            l10n.findingsFilterTrackers(
                              filterState.count(report.findings, option),
                            ),
                          FindingsFilter.permissions =>
                            l10n.findingsFilterPermissions(
                              filterState.count(report.findings, option),
                            ),
                        }),
                        onSelected: (_) => context
                            .read<FindingsFilterCubit>()
                            .setFilter(option),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? MessageView(
                      icon: Icons.verified_outlined,
                      title: l10n.findingsEmptyTitle,
                      message: l10n.findingsEmptyBody,
                    )
                  : ListView(
                      padding: pageInsets(context),
                      children: [
                        for (final group in _groups(visible))
                          _FindingGroup(report: report, findings: group),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  List<List<Finding>> _groups(List<Finding> findings) {
    final byType = <FindingType, List<Finding>>{};
    for (final finding in findings) {
      byType.putIfAbsent(finding.type, () => []).add(finding);
    }
    final ordered = FindingType.values
        .map((type) => byType[type])
        .whereType<List<Finding>>()
        .toList();
    ordered.sort(
      (a, b) => b.first.severity.index.compareTo(a.first.severity.index),
    );
    return ordered;
  }
}

class _FindingGroup extends StatelessWidget {
  const _FindingGroup({required this.report, required this.findings});

  final AuditReport report;
  final List<Finding> findings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sample = findings.first;
    final title = switch (sample.severity) {
      Severity.high => l10n.findingsHighPriority,
      Severity.medium => l10n.findingsMediumPriority,
      Severity.low => l10n.findingsHygiene,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            trailing: Text(l10n.findingsAppCount(findings.length)),
          ),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sample.type.title(l10n),
                        style: context.textStyles.titleMedium,
                      ),
                    ),
                    SeverityBadge(severity: sample.severity),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(sample.type.body(l10n)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final finding in findings)
                      if (report.auditFor(finding.packageName)
                          case final audit?)
                        ActionChip(
                          avatar: AppIcon(
                            label: audit.app.label,
                            iconPath: audit.app.iconPath,
                            size: 24,
                          ),
                          label: Text(audit.app.label),
                          onPressed: () =>
                              context.go('/apps/${finding.packageName}'),
                        ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => _act(context, sample),
                    child: Text(sample.action.label(l10n)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _act(BuildContext context, Finding finding) {
    switch (finding.action) {
      case FindingAction.openAppSettings:
        unawaited(
          context.read<AccessCubit>().openAppDetails(finding.packageName),
        );
      case FindingAction.enableTrackerShield:
        context.go('/trackers');
    }
  }
}
