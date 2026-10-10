import 'package:flutter/material.dart';

import '../../core/design_system/app_radii.dart';
import '../../core/design_system/app_spacing.dart';
import '../extensions/context_extensions.dart';

/// Reminder strip under the app bar: nothing is sent off the phone.
class LocalOnlyBanner extends StatelessWidget {
  const LocalOnlyBanner({required this.sectionLabel, super.key});

  final String sectionLabel;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.labelMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: AppRadii.mediumAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smd,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, size: 16, color: context.colors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.localOnlyBanner,
                  style: style,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                sectionLabel,
                style: style?.copyWith(color: context.colors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
