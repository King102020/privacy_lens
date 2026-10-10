import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/presentation/formatters.dart';
import '../../../shared/presentation/label_maps.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/page_padding.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/severity_badge.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../access/presentation/access_cubit.dart';
import '../../audit/domain/entities/audit_report.dart';
import '../../audit/presentation/audit_cubit.dart';

class AppDetailPane extends StatelessWidget {
  const AppDetailPane({required this.packageName, super.key});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditCubit, AuditState>(
      builder: (context, state) {
        final audit = state.report?.auditFor(packageName);
        if (audit == null) {
          return MessageView(
            icon: Icons.apps_outlined,
            title: context.l10n.detailNotFound,
            message: context.l10n.appsEmptyBody,
            actionLabel: context.l10n.back,
            onAction: () => context.go('/apps'),
          );
        }
        return _DetailBody(audit: audit);
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.audit});

  final AppAudit audit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final app = audit.app;
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;
    return ListView(
      padding: pageInsets(context),
      children: [
        if (!wide)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.go('/apps'),
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.back),
            ),
          ),
        Row(
          children: [
            AppIcon(
              label: app.label,
              iconPath: app.iconPath,
              size: AppDimensions.appIconSizeLarge,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.label, style: context.textStyles.headlineSmall),
                  Text(
                    app.packageName,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  if (app.versionName case final version?)
                    Text(
                      l10n.detailVersion(version),
                      style: context.textStyles.labelMedium,
                    ),
                ],
              ),
            ),
            RiskBadge(level: audit.riskLevel),
          ],
        ),
        if (audit.findings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SurfaceCard(
            color: context.colors.secondaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.detailElevatedAttention,
                  style: context.textStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(audit.findings.first.type.body(l10n)),
              ],
            ),
          ),
        ],
        SectionHeader(title: l10n.detailUsage),
        SurfaceCard(
          child: app.usage == null
              ? Text(l10n.detailUsageUnavailable)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.detailScanDay,
                          style: context.textStyles.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          l10n.detailForeground(
                            formatDuration(app.usage!.foreground, l10n),
                          ),
                          style: AppTypography.tabular(
                            context.textStyles.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: AppDimensions.usageBarHeight,
                        value: (app.usage!.foreground.inMinutes / 180).clamp(
                          0,
                          1,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      app.usage!.lastUsedAt == null
                          ? l10n.detailNeverUsed
                          : l10n.detailLastUsed(
                              formatRelativeTime(
                                value: app.usage!.lastUsedAt!,
                                now: DateTime.now(),
                                l10n: l10n,
                              ),
                            ),
                    ),
                  ],
                ),
        ),
        SectionHeader(
          title: l10n.detailTrackers,
          trailing: Text(l10n.detailLibraries(app.trackers.length)),
        ),
        SurfaceCard(
          child: app.trackers.isEmpty
              ? Text(l10n.detailNoTrackers)
              : Column(
                  children: [
                    for (final sdk in app.trackers)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.hub_outlined),
                        title: Text(sdk.name),
                        subtitle: Text(sdk.category.label(l10n)),
                      ),
                  ],
                ),
        ),
        SectionHeader(
          title: l10n.detailPermissions,
          trailing: Text(l10n.detailGranted(app.granted.length)),
        ),
        SurfaceCard(
          child: app.granted.isEmpty && app.specialAccess.isEmpty
              ? Text(l10n.detailNoPermissions)
              : Column(
                  children: [
                    for (final capability in app.granted)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(capability.icon),
                        title: Text(capability.label(l10n)),
                      ),
                    for (final kind in app.specialAccess)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(kind.icon),
                        title: Text(kind.label(l10n)),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.primaryButtonHeight,
          child: FilledButton.icon(
            onPressed: () =>
                context.read<AccessCubit>().openAppDetails(app.packageName),
            icon: const Icon(Icons.settings_outlined),
            label: Text(l10n.detailOpenSettings),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.detailOpenSettingsHint,
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
