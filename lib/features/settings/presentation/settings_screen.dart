import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/presentation/failure_text.dart';
import '../../../shared/presentation/formatters.dart';
import '../../../shared/widgets/about_sheet.dart';
import '../../../shared/widgets/lens_app_bar.dart';
import '../../../shared/widgets/page_padding.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../../shared/widgets/tonal_badge.dart';
import '../../audit/presentation/audit_cubit.dart';
import '../domain/data_vault_repository.dart';
import 'data_vault_cubit.dart';
import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LensAppBar(),
      body: ConstrainedContent(
        child: BlocConsumer<DataVaultCubit, DataVaultState>(
          listenWhen: (previous, current) =>
              current is DataVaultReady && current.notice != null,
          listener: (context, state) {
            if (state is! DataVaultReady || state.notice == null) return;
            final l10n = context.l10n;
            context.showSnack(switch (state.notice!) {
              VaultNotice.exportSaved => l10n.settingsExportSaved,
              VaultNotice.exportCanceled => l10n.settingsExportCanceled,
              VaultNotice.exportEmpty => l10n.settingsExportEmpty,
            });
          },
          builder: (context, vault) => switch (vault) {
            DataVaultLoading() => const LoadingView(),
            DataVaultFailure(:final failure) => ErrorView(
              message: failure.message(context.l10n),
              onRetry: () => context.read<DataVaultCubit>().load(),
            ),
            DataVaultReady() => _Body(vault: vault),
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.vault});

  final DataVaultReady vault;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsCubit>().state;
    return ListView(
      padding: pageInsets(context),
      children: [
        SectionHeader(title: l10n.settingsDataControl),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.settingsVaultSecure,
                    style: context.textStyles.titleMedium,
                  ),
                  const Spacer(),
                  TonalBadge(
                    label: vault.info.isEncrypted
                        ? l10n.settingsEncrypted
                        : l10n.errorTitle,
                    tone: vault.info.isEncrypted
                        ? context.severityColors.low
                        : context.severityColors.high,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${l10n.settingsVaultSize(formatBytes(vault.info.sizeBytes, l10n))}'
                '${vault.info.cipherVersion == null ? '' : ' · ${vault.info.cipherVersion}'}',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.settingsRetentionTitle,
                style: context.textStyles.titleSmall,
              ),
              Text(l10n.settingsRetentionBody),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<int>(
                segments: [
                  for (final days in AppPreferences.retentionChoicesDays)
                    ButtonSegment(
                      value: days,
                      label: Text(l10n.settingsRetentionDays(days)),
                    ),
                ],
                selected: {settings.retentionDays},
                onSelectionChanged: (value) => context
                    .read<SettingsCubit>()
                    .setRetentionDays(value.single),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.settingsDnsRetentionTitle,
                style: context.textStyles.titleSmall,
              ),
              Text(l10n.settingsDnsRetentionBody),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 1, label: Text(l10n.settingsDnsDaily)),
                  ButtonSegment(value: 7, label: Text(l10n.settingsDnsWeekly)),
                ],
                selected: {settings.dnsRetentionDays},
                onSelectionChanged: (value) => context
                    .read<SettingsCubit>()
                    .setDnsRetentionDays(value.single),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsIncludeSystemTitle),
                subtitle: Text(l10n.settingsIncludeSystemBody),
                value: settings.includeSystemApps,
                onChanged: (value) =>
                    context.read<SettingsCubit>().setIncludeSystemApps(value),
              ),
              Text(
                l10n.settingsExportTitle,
                style: context.textStyles.titleSmall,
              ),
              Text(l10n.settingsExportBody),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: vault.busy
                          ? null
                          : () => context.read<DataVaultCubit>().export(
                              ExportFormat.json,
                            ),
                      child: Text(l10n.settingsExportJson),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: vault.busy
                          ? null
                          : () => context.read<DataVaultCubit>().export(
                              ExportFormat.csv,
                            ),
                      child: Text(l10n.settingsExportCsv),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: vault.busy ? null : () => _confirmWipe(context),
                  child: Text(l10n.settingsWipeAction),
                ),
              ),
            ],
          ),
        ),
        SectionHeader(title: l10n.settingsTransparency),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsInternetTitle,
                style: context.textStyles.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.settingsInternetBody),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SurfaceCard(
          onTap: () =>
              unawaited(context.read<SettingsCubit>().replayTabGuides()),
          child: Row(
            children: [
              const Icon(Icons.tips_and_updates_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.settingsReplayTips),
                    Text(
                      l10n.settingsReplayTipsBody,
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SurfaceCard(
          onTap: () => showAboutSheet(context),
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(l10n.settingsHowItWorks)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SurfaceCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsPowerModeLocked,
                      style: context.textStyles.titleSmall,
                    ),
                    Text(l10n.settingsPowerModeHint),
                  ],
                ),
              ),
              TonalBadge(
                label: l10n.settingsComingLater,
                tone: neutralTone(context),
              ),
            ],
          ),
        ),
        SectionHeader(title: l10n.settingsAppearance),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settingsTheme, style: context.textStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (value) =>
                    context.read<SettingsCubit>().setThemeMode(value.single),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.settingsVersion('1.0.0'),
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmWipe(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsWipeConfirmTitle),
        content: Text(l10n.settingsWipeConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.settingsWipeAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final wiped = await context.read<DataVaultCubit>().wipe();
    if (wiped && context.mounted) {
      await context.read<AuditCubit>().loadLatest();
    }
  }
}
