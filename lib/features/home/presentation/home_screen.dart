import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/guide/spotlight_tour.dart';
import '../../../shared/guide/tab_guide.dart';
import '../../../shared/presentation/failure_text.dart';
import '../../../shared/presentation/formatters.dart';
import '../../../shared/presentation/label_maps.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/lens_app_bar.dart';
import '../../../shared/widgets/page_padding.dart';
import '../../../shared/widgets/permission_chip.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/severity_badge.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../access/presentation/access_cubit.dart';
import '../../audit/domain/entities/audit_report.dart';
import '../../audit/domain/entities/capability.dart';
import '../../audit/domain/entities/finding.dart';
import '../../audit/domain/entities/severity.dart';
import '../../audit/presentation/audit_cubit.dart';
import '../../trackers/presentation/tracker_shield_cubit.dart';

final _startKey = GlobalKey(debugLabel: 'tour.home.start');
final _scoreKey = GlobalKey(debugLabel: 'tour.home.score');
final _scanKey = GlobalKey(debugLabel: 'tour.home.scan');
final _glanceKey = GlobalKey(debugLabel: 'tour.home.glance');
final _discoveriesKey = GlobalKey(debugLabel: 'tour.home.discoveries');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LensAppBar(),
      body: ConstrainedContent(
        child: BlocBuilder<AuditCubit, AuditState>(
          builder: (context, state) => switch (state) {
            AuditLoading() => const LoadingView(),
            AuditEmpty() => _EmptyHome(
              onScan: () => context.read<AuditCubit>().scan(),
            ),
            AuditFailure(:final failure, :final previous) =>
              previous == null
                  ? ErrorView(
                      message: failure.message(context.l10n),
                      onRetry: () => context.read<AuditCubit>().loadLatest(),
                    )
                  : _ReadyHome(report: previous, scanning: false),
            AuditScanning(:final previous) =>
              previous == null
                  ? LoadingView(
                      message: state.progress.label(context.l10n),
                      progress: state.progress.fraction,
                    )
                  : _ReadyHome(report: previous, scanning: true),
            AuditReady(:final current) => _ReadyHome(
              report: current,
              scanning: false,
            ),
          },
        ),
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return TabTour(
      id: TabGuideIds.homeStart,
      ready: true,
      steps: (context) => [
        TourStep(
          target: _startKey,
          title: context.l10n.guideHomeStartTitle,
          body: context.l10n.guideHomeStartBody,
        ),
      ],
      child: MessageView(
        icon: Icons.shield_outlined,
        title: context.l10n.homeEmptyTitle,
        message: context.l10n.homeEmptyBody,
        actionLabel: context.l10n.homeRunAudit,
        onAction: onScan,
        actionKey: _startKey,
      ),
    );
  }
}

class _ReadyHome extends StatelessWidget {
  const _ReadyHome({required this.report, required this.scanning});

  final AuditReport report;
  final bool scanning;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final micCamera = report.countApps(
      (app) => app.has(Capability.microphone) || app.has(Capability.camera),
    );
    final discoveries = _discoveries(context, report, now);
    return TabTour(
      id: TabGuideIds.home,
      ready: !scanning,
      steps: (context) => [
        TourStep(
          target: _scoreKey,
          title: l10n.guideHomeScoreTitle,
          body: l10n.guideHomeScoreBody,
        ),
        TourStep(
          target: _scanKey,
          title: l10n.guideHomeScanTitle,
          body: l10n.guideHomeScanBody,
        ),
        TourStep(
          target: _glanceKey,
          title: l10n.guideHomeGlanceTitle,
          body: l10n.guideHomeGlanceBody,
        ),
        TourStep(
          target: _discoveriesKey,
          title: l10n.guideHomeDiscoveriesTitle,
          body: l10n.guideHomeDiscoveriesBody,
        ),
      ],
      child: ListView(
        padding: pageInsets(context),
        children: [
          const _UsageAccessBanner(),
          SurfaceCard(
            key: _scoreKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.homeDevicePosture,
                      style: context.textStyles.titleSmall,
                    ),
                    const Spacer(),
                    PostureBadge(level: report.posture.level),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  report.posture.level.label(l10n),
                  style: context.textStyles.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _PostureRing(score: report.posture.score),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.homePostureSummary(
                          report.apps.length,
                          micCamera,
                          report.appsWithTrackers,
                        ),
                        style: context.textStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  key: _scanKey,
                  width: double.infinity,
                  height: AppDimensions.primaryButtonHeight,
                  child: FilledButton.icon(
                    onPressed: scanning
                        ? null
                        : () => context.read<AuditCubit>().scan(),
                    icon: scanning
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      scanning ? l10n.homeScanning : l10n.homeRunAudit,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.homeLastScanned(
                    formatTodayTime(report.completedAt, l10n),
                  ),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SectionHeader(title: l10n.homeTelemetryGlimpse),
          BlocBuilder<TrackerShieldCubit, TrackerShieldState>(
            builder: (context, shield) {
              final blocked = shield is TrackerShieldReady
                  ? shield.activity.totalBlocked
                  : 0;
              return Row(
                key: _glanceKey,
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.location_on_outlined,
                      value: '${report.appsWithLocation}',
                      label: l10n.homeAppsWithLocation,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.mic_none,
                      value: '${report.appsWithMicrophone}',
                      label: l10n.homeAppsWithMicrophone,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.block,
                      value: '$blocked',
                      label: l10n.homeTrackersBlocked,
                    ),
                  ),
                ],
              );
            },
          ),
          SectionHeader(
            title: l10n.homeKeyDiscoveries,
            trailing: TextButton(
              onPressed: () => context.go('/findings'),
              child: Text(l10n.homeViewAll),
            ),
          ),
          // Only the first discovery is pointed at; the tour skips it when
          // the scan found nothing.
          for (final (i, card) in discoveries.indexed)
            i == 0 ? KeyedSubtree(key: _discoveriesKey, child: card) : card,
        ],
      ),
    );
  }

  List<Widget> _discoveries(
    BuildContext context,
    AuditReport report,
    DateTime now,
  ) {
    final l10n = context.l10n;
    final widgets = <Widget>[];
    final attention = report.apps
        .where((audit) => audit.riskLevel == RiskLevel.high)
        .take(2);
    for (final audit in attention) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _DiscoveryCard(
            audit: audit,
            badge: l10n.homeDiscoveryNeedsAttention,
            installedLabel: l10n.homeInstalledDaysAgo(
              now.difference(audit.app.installedAt).inDays.clamp(0, 9999),
            ),
            actionLabel: l10n.homeReviewPermissions,
            onAction: () => context.go('/apps/${audit.app.packageName}'),
          ),
        ),
      );
    }

    final unused = [
      for (final audit in report.apps)
        if (audit.findings.any(
          (f) => f.type == FindingType.unusedWithSensitiveAccess,
        ))
          audit,
    ];
    if (unused.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: SurfaceCard(
            onTap: () => context.go('/findings'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.homeUnusedAppsTitle(unused.length),
                        style: context.textStyles.titleMedium,
                      ),
                    ),
                    const PostureBadge(level: PostureLevel.calm),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.homeNoUsageDays,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () => context.go('/findings'),
                    child: Text(l10n.homeCleanup),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final blocked = [
      for (final audit in report.apps)
        if (audit.findings.any(
          (f) => f.type == FindingType.trackerDomainContacts,
        ))
          audit,
    ].take(1);
    for (final audit in blocked) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: SurfaceCard(
            onTap: () => context.go('/trackers'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppIcon(
                      label: audit.app.label,
                      iconPath: audit.app.iconPath,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        audit.app.label,
                        style: context.textStyles.titleMedium,
                      ),
                    ),
                    const PostureBadge(level: PostureLevel.observant),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  FindingType.trackerDomainContacts.body(l10n),
                  style: context.textStyles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.homeRequestsNeutralized,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({
    required this.audit,
    required this.badge,
    required this.installedLabel,
    required this.actionLabel,
    required this.onAction,
  });

  final AppAudit audit;
  final String badge;
  final String installedLabel;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SurfaceCard(
      onTap: onAction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(label: audit.app.label, iconPath: audit.app.iconPath),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audit.app.label,
                      style: context.textStyles.titleMedium,
                    ),
                    Text(
                      installedLabel,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              RiskBadge(level: audit.riskLevel),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            audit.findings.isEmpty
                ? badge
                : audit.findings.first.type.body(l10n),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final capability in audit.app.sensitiveGranted.take(4))
                PermissionChip(
                  label: capability.label(l10n),
                  icon: capability.icon,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ),
        ],
      ),
    );
  }
}

class _UsageAccessBanner extends StatelessWidget {
  const _UsageAccessBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccessCubit, AccessState>(
      builder: (context, state) {
        if (state is! AccessReady || state.status.hasUsageAccess) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: SurfaceCard(
            color: context.colors.secondaryContainer,
            onTap: () => context.read<AccessCubit>().openUsageAccessSettings(),
            child: Row(
              children: [
                Icon(Icons.schedule_outlined, color: context.colors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.homeUsageAccessRequiredBody,
                    style: context.textStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PostureRing extends StatelessWidget {
  const _PostureRing({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppDimensions.postureRingSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (score / 100).clamp(0, 1),
            strokeWidth: AppDimensions.postureRingStroke,
            color: context.colors.primary,
            backgroundColor: context.colors.surfaceContainerHighest,
          ),
          Text(
            '$score',
            style: AppTypography.tabular(context.textStyles.titleLarge),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          Icon(icon, color: context.colors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.tabular(context.textStyles.headlineSmall),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
