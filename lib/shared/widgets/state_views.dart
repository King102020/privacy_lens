import 'package:flutter/material.dart';

import '../../core/design_system/app_dimensions.dart';
import '../../core/design_system/app_spacing.dart';
import '../extensions/context_extensions.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message, this.progress});

  final String? message;

  /// Null shows an indeterminate indicator.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: progress,
              semanticsLabel: text ?? context.l10n.loading,
            ),
            if (text != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                text,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Centered icon, title, explanation, and optional action. Used for empty,
/// error, and access-required states so they look consistent.
class MessageView extends StatelessWidget {
  const MessageView({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
    this.secondary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Icon(
                    icon,
                    size: 32,
                    color: context.colors.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              if (label != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(
                      AppDimensions.minTouchTarget * 4,
                      AppDimensions.primaryButtonHeight,
                    ),
                  ),
                  child: Text(label),
                ),
              ],
              if (secondary case final secondary?) ...[
                const SizedBox(height: AppSpacing.sm),
                secondary,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
    icon: Icons.error_outline,
    title: context.l10n.errorTitle,
    message: message,
    actionLabel: context.l10n.retry,
    onAction: onRetry,
  );
}
