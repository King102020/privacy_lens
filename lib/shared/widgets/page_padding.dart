import 'package:flutter/material.dart';

import '../../core/design_system/app_dimensions.dart';
import '../../core/design_system/app_spacing.dart';

EdgeInsets pageInsets(BuildContext context) {
  final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;
  final horizontal = wide ? AppSpacing.pageMarginWide : AppSpacing.pageMargin;
  return EdgeInsets.fromLTRB(
    horizontal,
    AppSpacing.sm,
    horizontal,
    AppSpacing.md,
  );
}

class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppBreakpoints.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
