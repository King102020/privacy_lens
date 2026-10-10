import 'package:flutter/material.dart';

import '../../core/design_system/app_spacing.dart';
import '../extensions/context_extensions.dart';

Future<void> showAboutSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) => const _AboutSheet(),
);

class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (
        Icons.apps_outlined,
        l10n.aboutPermissionsTitle,
        l10n.aboutPermissionsBody,
      ),
      (Icons.schedule_outlined, l10n.aboutUsageTitle, l10n.aboutUsageBody),
      (Icons.hub_outlined, l10n.aboutTrackersTitle, l10n.aboutTrackersBody),
      (Icons.shield_outlined, l10n.aboutShieldTitle, l10n.aboutShieldBody),
      (
        Icons.visibility_off_outlined,
        l10n.aboutLimitsTitle,
        l10n.aboutLimitsBody,
      ),
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.aboutTitle,
              style: context.textStyles.headlineSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.aboutIntro, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          for (final (icon, title, body) in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon),
              title: Text(title),
              subtitle: Text(body),
            ),
        ],
      ),
    );
  }
}
