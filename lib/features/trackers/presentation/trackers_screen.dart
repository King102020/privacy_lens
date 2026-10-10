import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_radii.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/presentation/failure_text.dart';
import '../../../shared/presentation/formatters.dart';
import '../../../shared/presentation/label_maps.dart';
import '../../../shared/widgets/lens_app_bar.dart';
import '../../../shared/widgets/local_only_banner.dart';
import '../../../shared/widgets/page_padding.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../../shared/widgets/tonal_badge.dart';
import '../../audit/domain/entities/tracker_sdk.dart';
import '../domain/tracker_shield_entities.dart';
import 'tracker_shield_cubit.dart';

class TrackersScreen extends StatelessWidget {
  const TrackersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LensAppBar(),
      body: ConstrainedContent(
        child: Column(
          children: [
            LocalOnlyBanner(sectionLabel: context.l10n.trackersSectionLabel),
            Expanded(
              child: BlocConsumer<TrackerShieldCubit, TrackerShieldState>(
                listenWhen: (previous, current) =>
                    current is TrackerShieldReady && current.notice != null,
                listener: (context, state) {
                  if (state is TrackerShieldReady &&
                      state.notice == ShieldNotice.consentDenied) {
                    context.showSnack(context.l10n.shieldConsentDenied);
                  }
                },
                builder: (context, state) => switch (state) {
                  TrackerShieldLoading() => const LoadingView(),
                  TrackerShieldFailure(:final failure) => ErrorView(
                    message: failure.message(context.l10n),
                    onRetry: () => context.read<TrackerShieldCubit>().refresh(),
                  ),
                  TrackerShieldReady() => _Ready(state: state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final TrackerShieldReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final activity = state.activity;
    return ListView(
      padding: pageInsets(context),
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: context.colors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.shieldTitle,
                      style: context.textStyles.titleMedium,
                    ),
                  ),
                  TonalBadge(
                    label: state.status.isRunning
                        ? l10n.shieldActive
                        : l10n.shieldOff,
                    tone: state.status.isRunning
                        ? context.severityColors.low
                        : neutralTone(context),
                  ),
                  Switch(
                    value: state.status.isRunning,
                    onChanged: state.busy
                        ? null
                        : (value) => value
                              ? context.read<TrackerShieldCubit>().start()
                              : context.read<TrackerShieldCubit>().stop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.shieldDescription),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      value: '${activity.distinctDomains}',
                      label: l10n.shieldDomainsBlocked,
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      value: '${activity.distinctApps}',
                      label: l10n.shieldAppsMonitored,
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      value: l10n.shieldNoDataSentValue,
                      label: l10n.shieldNoDataSent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SectionHeader(title: l10n.shieldHourlyTitle),
        SurfaceCard(
          child: activity.blockedTodayByHour.isEmpty
              ? Text(l10n.shieldEmptyBody)
              : _HourlyChart(values: activity.blockedTodayByHour),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          onChanged: context.read<TrackerShieldCubit>().setQuery,
          decoration: InputDecoration(
            hintText: l10n.shieldSearchHint,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: AppDimensions.filterChipHeight + AppSpacing.sm,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: FilterChip(
                  selected: state.category == null,
                  label: Text(l10n.shieldFilterAll(activity.summaries.length)),
                  onSelected: (_) =>
                      context.read<TrackerShieldCubit>().setCategory(null),
                ),
              ),
              for (final category in TrackerCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    selected: state.category == category,
                    label: Text(category.label(l10n)),
                    onSelected: (_) => context
                        .read<TrackerShieldCubit>()
                        .setCategory(category),
                  ),
                ),
            ],
          ),
        ),
        if (state.visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text(l10n.shieldEmptyTitle, textAlign: TextAlign.center),
          )
        else
          for (final item in state.visible)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _BlockedRow(item: item),
            ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.shieldBlocklistVersion(state.status.blocklistVersion),
          style: context.textStyles.titleSmall,
        ),
        Text(l10n.shieldRulesCount(state.status.blocklistSize)),
        SectionHeader(title: l10n.shieldLimitsTitle),
        Text(l10n.shieldLimitPrivateDns),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.shieldLimitDoh),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.shieldLimitOtherVpn),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}

class _HourlyChart extends StatelessWidget {
  const _HourlyChart({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final max = values.fold<int>(0, (peak, item) => item > peak ? item : peak);
    return SizedBox(
      height: AppDimensions.hourlyChartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final count in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: AppRadii.pillAll,
                  ),
                  child: SizedBox(
                    height: max == 0
                        ? 4
                        : (count / max) * AppDimensions.hourlyChartHeight,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlockedRow extends StatelessWidget {
  const _BlockedRow({required this.item});

  final BlockedDomainSummary item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SurfaceCard(
      child: Row(
        children: [
          Icon(Icons.block, color: context.severityColors.high.accent),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.domain, style: context.textStyles.titleSmall),
                Text(
                  item.packageName ?? l10n.shieldUnknownApp,
                  style: context.textStyles.bodySmall,
                ),
                if (item.category case final category?)
                  Text(
                    category.label(l10n),
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TonalBadge(
                label: l10n.shieldBlockedTimes(item.count),
                tone: context.severityColors.high,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formatRelativeTime(
                  value: item.lastBlockedAt,
                  now: DateTime.now(),
                  l10n: l10n,
                ),
                style: context.textStyles.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
