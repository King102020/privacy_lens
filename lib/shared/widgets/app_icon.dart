import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/design_system/app_dimensions.dart';
import '../../core/design_system/app_radii.dart';
import '../extensions/context_extensions.dart';

/// Launcher icon cached by the native side, with a letter fallback.
class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.label,
    super.key,
    this.iconPath,
    this.size = AppDimensions.appIconSize,
  });

  final String label;
  final String? iconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    final path = iconPath;
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: AppRadii.mediumAll,
        child: SizedBox.square(
          dimension: size,
          child: path == null
              ? _Fallback(label: label)
              : Image.file(
                  File(path),
                  cacheWidth: cacheSize,
                  cacheHeight: cacheSize,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) =>
                      _Fallback(label: label),
                ),
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final initial = label.isEmpty ? '?' : label.characters.first.toUpperCase();
    return ColoredBox(
      color: context.colors.secondaryContainer,
      child: Center(
        child: Text(
          initial,
          style: context.textStyles.titleMedium?.copyWith(
            color: context.colors.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
