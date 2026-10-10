import 'package:flutter/material.dart';

import '../../core/design_system/app_radii.dart';
import '../../core/design_system/app_spacing.dart';
import '../../core/theme/severity_colors.dart';
import '../extensions/context_extensions.dart';

/// Small pill that labels a level, such as "High risk" or "Active".
class TonalBadge extends StatelessWidget {
  const TonalBadge({
    required this.label,
    required this.tone,
    super.key,
    this.icon,
  });

  final String label;
  final ToneColors tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.container,
        borderRadius: AppRadii.pillAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smd,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: tone.onContainer),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelMedium?.copyWith(
                  color: tone.onContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Neutral tone for badges that do not express severity.
ToneColors neutralTone(BuildContext context) => ToneColors(
  accent: context.colors.primary,
  container: context.colors.secondaryContainer,
  onContainer: context.colors.onSecondaryContainer,
);
