import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_radii.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/guide/spotlight_tour.dart';
import '../../../shared/guide/tab_guide.dart';
import '../../../shared/presentation/failure_text.dart';
import '../../../shared/presentation/formatters.dart';
import '../../../shared/presentation/label_maps.dart';
import '../../../shared/widgets/about_sheet.dart';
import '../../../shared/widgets/lens_app_bar.dart';
import '../../../shared/widgets/page_padding.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../../shared/widgets/tonal_badge.dart';
import '../data/tracker_domain_catalog.dart';
import '../domain/tracker_shield_entities.dart';
import 'tracker_shield_cubit.dart';

final _shieldKey = GlobalKey(debugLabel: 'tour.trackers.shield');
final _categoriesKey = GlobalKey(debugLabel: 'tour.trackers.categories');
final _chartKey = GlobalKey(debugLabel: 'tour.trackers.chart');
final _limitsKey = GlobalKey(debugLabel: 'tour.trackers.limits');

class TrackersScreen extends StatelessWidget {
  const TrackersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LensAppBar(),
      body: ConstrainedContent(
        child: BlocConsumer<TrackerShieldCubit, TrackerShieldState>(
          listenWhen: (previous, current) =>
              current is TrackerShieldReady && current.notice != null,
          listener: (context, state) {
            if (state is! TrackerShieldReady || state.notice == null) {
              return;
            }
            final message = switch (state.notice!) {
              ShieldNotice.consentDenied => context.l10n.shieldConsentDenied,
              ShieldNotice.invalidDomain => context.l10n.shieldInvalidDomain,
            };
            context.showSnack(message);
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
    );
  }
}

class _Ready extends StatefulWidget {
  const _Ready({required this.state});

  final TrackerShieldReady state;

  @override
  State<_Ready> createState() => _ReadyState();
}

class _ReadyState extends State<_Ready> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Limits sits under the blocked-domain list, which may not be built yet.
  Future<void> _revealLimits() async {
    if (!_scroll.hasClients) return;
    await _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = widget.state;
    final activity = state.activity;
    return TabTour(
      id: TabGuideIds.trackers,
      ready: true,
      steps: (context) => [
        TourStep(
          target: _shieldKey,
          title: l10n.guideShieldTitle,
          body: l10n.guideShieldBody,
        ),
        TourStep(
          target: _categoriesKey,
          title: l10n.guideShieldCategoriesTitle,
          body: l10n.guideShieldCategoriesBody,
        ),
        TourStep(
          target: _chartKey,
          title: l10n.guideShieldChartTitle,
          body: l10n.guideShieldChartBody,
        ),
        TourStep(
          target: _limitsKey,
          title: l10n.guideShieldLimitsTitle,
          body: l10n.guideShieldLimitsBody,
          reveal: _revealLimits,
        ),
      ],
      child: ListView(
        controller: _scroll,
        padding: pageInsets(context),
        children: [
          SurfaceCard(
            key: _shieldKey,
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: TonalBadge(
                        key: ValueKey(state.status.isRunning),
                        label: state.status.isRunning
                            ? l10n.shieldActive
                            : l10n.shieldOff,
                        tone: state.status.isRunning
                            ? context.severityColors.low
                            : neutralTone(context),
                      ),
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
          SectionHeader(title: l10n.shieldCategoriesTitle),
          SurfaceCard(
            key: _categoriesKey,
            child: Column(
              children: [
                for (final category in TrackerDomainCatalog.shieldCategories)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(category.label(l10n)),
                    subtitle: Text(
                      l10n.shieldCategoryCount(
                        state.policy.countsByCategory[category] ?? 0,
                      ),
                    ),
                    value: state.policy.enabledCategories.contains(category),
                    onChanged: state.busy
                        ? null
                        : (value) => unawaited(
                            context
                                .read<TrackerShieldCubit>()
                                .setCategoryEnabled(category, value),
                          ),
                  ),
              ],
            ),
          ),
          SectionHeader(title: l10n.shieldCustomRulesTitle),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: state.busy
                        ? null
                        : () => unawaited(showAddDomainSheet(context)),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.shieldAddDomain),
                  ),
                ),
                if (state.policy.extraBlocked.isEmpty &&
                    state.policy.allowed.isEmpty)
                  Text(l10n.shieldNoCustomRules)
                else ...[
                  for (final domain in state.policy.extraBlocked)
                    _CustomRuleRow(
                      domain: domain,
                      label: l10n.shieldCustomBlocked,
                      onRemove: () => unawaited(
                        context.read<TrackerShieldCubit>().removeCustomDomain(
                          domain,
                        ),
                      ),
                    ),
                  for (final domain in state.policy.allowed)
                    _CustomRuleRow(
                      domain: domain,
                      label: l10n.shieldCustomAllowed,
                      onRemove: () => unawaited(
                        context.read<TrackerShieldCubit>().removeCustomDomain(
                          domain,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          SectionHeader(title: l10n.shieldHourlyTitle),
          SurfaceCard(
            key: _chartKey,
            child: activity.blockedTodayByHour.isEmpty
                ? Text(l10n.shieldEmptyBody)
                : _HourlyChart(values: activity.blockedTodayByHour),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: context.read<TrackerShieldCubit>().setQuery,
                  decoration: InputDecoration(
                    hintText: l10n.shieldSearchHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              PopupMenuButton<ShieldSort>(
                tooltip: l10n.shieldSortHits,
                initialValue: state.sort,
                onSelected: context.read<TrackerShieldCubit>().setSort,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ShieldSort.hits,
                    child: Text(l10n.shieldSortHits),
                  ),
                  PopupMenuItem(
                    value: ShieldSort.recent,
                    child: Text(l10n.shieldSortRecent),
                  ),
                  PopupMenuItem(
                    value: ShieldSort.name,
                    child: Text(l10n.shieldSortName),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Icon(Icons.sort),
                ),
              ),
            ],
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
                    label: Text(
                      l10n.shieldFilterAll(activity.summaries.length),
                    ),
                    onSelected: (_) =>
                        context.read<TrackerShieldCubit>().setCategory(null),
                  ),
                ),
                for (final category in TrackerDomainCatalog.shieldCategories)
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
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: _limitsKey,
              onPressed: () => unawaited(showLimitsSheet(context)),
              child: Text(l10n.shieldLimitsAction),
            ),
          ),
        ],
      ),
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
              TextButton(
                onPressed: () => unawaited(
                  context.read<TrackerShieldCubit>().allowDomain(item.domain),
                ),
                child: Text(l10n.shieldAllowAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomRuleRow extends StatelessWidget {
  const _CustomRuleRow({
    required this.domain,
    required this.label,
    required this.onRemove,
  });

  final String domain;
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(domain),
      subtitle: Text(label),
      trailing: IconButton(
        tooltip: context.l10n.shieldRemoveRule,
        onPressed: onRemove,
        icon: const Icon(Icons.close),
      ),
    );
  }
}

Future<void> showAddDomainSheet(BuildContext context) {
  final cubit = context.read<TrackerShieldCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: BlocProvider.value(value: cubit, child: const _AddDomainSheet()),
    ),
  );
}

class _AddDomainSheet extends StatefulWidget {
  const _AddDomainSheet();

  @override
  State<_AddDomainSheet> createState() => _AddDomainSheetState();
}

class _AddDomainSheetState extends State<_AddDomainSheet> {
  final _controller = TextEditingController();
  var _allow = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.shieldAddDomainTitle,
            style: context.textStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: InputDecoration(hintText: l10n.shieldAddDomainHint),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l10n.shieldBlockDomain)),
              ButtonSegment(value: true, label: Text(l10n.shieldAllowDomain)),
            ],
            selected: {_allow},
            onSelectionChanged: (selected) {
              setState(() => _allow = selected.single);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _submit,
              child: Text(l10n.shieldAddDomain),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final cubit = context.read<TrackerShieldCubit>();
    final raw = _controller.text;
    Navigator.of(context).pop();
    unawaited(cubit.addCustomDomain(raw, allow: _allow));
  }
}
