import 'package:flutter/material.dart';

import '../../core/design_system/app_spacing.dart';
import '../extensions/context_extensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.only(
      top: AppSpacing.lg,
      bottom: AppSpacing.sm,
    ),
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: context.colors.primary),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: context.textStyles.titleMedium),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
