import 'package:flutter/material.dart';

import '../../core/design_system/app_radii.dart';
import '../../core/design_system/app_spacing.dart';

/// Tonal container used for every grouped block of content.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.color,
    this.onTap,
    this.borderRadius = AppRadii.extraLargeAll,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
