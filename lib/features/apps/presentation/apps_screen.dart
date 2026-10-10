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
import '../../../shared/widgets/permission_chip.dart';
import '../../../shared/widgets/severity_badge.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../audit/domain/entities/audit_report.dart';
import '../../audit/presentation/audit_cubit.dart';
import 'app_detail_screen.dart';
import 'apps_filter_cubit.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key, this.selectedPackage});

  final String? selectedPackage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppsFilterCubit(),
      child: _AppsView(selectedPackage: selectedPackage),
    );
  }
}

class _AppsView extends StatelessWidget {
  const _AppsView({required this.selectedPackage});

  final String? selectedPackage;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;
    return Scaffold(
      appBar: const LensAppBar(),
      body: ConstrainedContent(
        child: Column(
          children: [
            LocalOnlyBanner(sectionLabel: context.l10n.appsSectionLabel),
            Expanded(
              child: BlocBuilder<AuditCubit, AuditState>(
                builder: (context, audit) {
                  final report = audit.report;
                  if (audit is AuditLoading ||
                      (audit is AuditScanning && report == null)) {
                    return const LoadingView();
                  }
                  if (audit is AuditFailure && report == null) {
                    return ErrorView(
                      message: audit.failure.message(context.l10n),
                      onRetry: () => context.read<AuditCubit>().loadLatest(),
                    );
                  }
                  if (report == null) {
                    return MessageView(
                      icon: Icons.apps_outlined,
                      title: context.l10n.appsEmptyTitle,
                      message: context.l10n.appsEmptyBody,
                      actionLabel: context.l10n.homeRunAudit,
                      onAction: () => context.read<AuditCubit>().scan(),
                    );
                  }
                  if (wide) {
                    return Row(
                      children: [
                        SizedBox(
                          width: AppBreakpoints.listPaneWidth,
                          child: _AppsList(
                            report: report,
                            selectedPackage: selectedPackage,
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          child: selectedPackage == null
                              ? Center(child: Text(context.l10n.appsSelectHint))
                              : AppDetailPane(packageName: selectedPackage!),
                        ),
                      ],
                    );
                  }
                  if (selectedPackage != null) {
                    return AppDetailPane(packageName: selectedPackage!);
                  }
                  return _AppsList(
                    report: report,
                    selectedPackage: selectedPackage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppsList extends StatelessWidget {
  const _AppsList({required this.report, required this.selectedPackage});

  final AuditReport report;
  final String? selectedPackage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AppsFilterCubit, AppsFilterState>(
      builder: (context, filter) {
        final visible = filter.apply(report.apps);
        return Column(
          children: [
            Padding(
              padding: pageInsets(context).copyWith(bottom: AppSpacing.sm),
              child: TextField(
                onChanged: context.read<AppsFilterCubit>().setQuery,
                decoration: InputDecoration(
                  hintText: l10n.appsSearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: AppDimensions.filterChipHeight + AppSpacing.sm,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: pageInsets(context).left,
                ),
                children: [
                  for (final option in AppsFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        selected: filter.filter == option,
                        label: Text(switch (option) {
                          AppsFilter.all => l10n.appsFilterAll(
                            filter.count(report.apps, option),
                          ),
                          AppsFilter.highRisk => l10n.appsFilterHighRisk(
                            filter.count(report.apps, option),
                          ),
                          AppsFilter.camera => l10n.appsFilterCamera(
                            filter.count(report.apps, option),
                          ),
                          AppsFilter.microphone => l10n.appsFilterMicrophone(
                            filter.count(report.apps, option),
                          ),
                        }),
                        onSelected: (_) =>
                            context.read<AppsFilterCubit>().setFilter(option),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? MessageView(
                      icon: Icons.search_off,
                      title: l10n.appsNoMatchTitle,
                      message: l10n.appsNoMatchBody,
                    )
                  : ListView.builder(
                      padding: pageInsets(context),
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final audit = visible[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _AppRow(
                            audit: audit,
                            selected: audit.app.packageName == selectedPackage,
                            onTap: () =>
                                context.go('/apps/${audit.app.packageName}'),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: pageInsets(context),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.appsMonitored(report.apps.length),
                      style: context.textStyles.bodySmall,
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () => context.read<AuditCubit>().scan(),
                    child: Text(l10n.appsRescan),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({
    required this.audit,
    required this.selected,
    required this.onTap,
  });

  final AppAudit audit;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final app = audit.app;
    return SurfaceCard(
      color: selected ? context.colors.secondaryContainer : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(label: app.label, iconPath: app.iconPath),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.label, style: context.textStyles.titleMedium),
                    Text(
                      app.trackers.isEmpty && !app.requestsInternet
                          ? l10n.appsNoNetwork
                          : l10n.appsTrackersCount(app.trackers.length),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          if (app.granted.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final capability in app.granted.take(4))
                  PermissionChip(
                    label: capability.label(l10n),
                    icon: capability.icon,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
