import 'package:flutter/material.dart';

import '../../core/design_system/app_radii.dart';
import '../../core/design_system/app_spacing.dart';
import '../extensions/context_extensions.dart';
import 'about_sheet.dart';

class LensAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LensAppBar({super.key, this.actions = const []});

  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      toolbarHeight: preferredSize.height,
      titleSpacing: AppSpacing.pageMargin,
      title: Row(
        children: [
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: AppRadii.mediumAll,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs + 2),
                child: Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: context.colors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.smd),
          Flexible(
            child: Text(l10n.appTitle, style: context.textStyles.titleLarge),
          ),
        ],
      ),
      actions: [
        ...actions,
        Tooltip(
          message: l10n.appTagline,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Icon(
              Icons.lock_outline,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.aboutTooltip,
          icon: const Icon(Icons.help_outline),
          onPressed: () => showAboutSheet(context),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
