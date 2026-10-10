import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_radii.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/surface_card.dart';
import '../../access/presentation/access_cubit.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../trackers/presentation/tracker_shield_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() => context.read<SettingsCubit>().completeOnboarding();

  void _next() {
    if (_page >= 2) {
      unawaited(_finish());
      return;
    }
    unawaited(
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ExcludeSemantics(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        borderRadius: AppRadii.mediumAll,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Icon(
                          Icons.shield_outlined,
                          size: 18,
                          color: context.colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.appTitle, style: context.textStyles.titleMedium),
                  const Spacer(),
                  TextButton(onPressed: _finish, child: Text(l10n.skip)),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) => setState(() => _page = index),
                  children: const [_IntroPage(), _UsagePage(), _ShieldPage()],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: i == _page
                              ? context.colors.primary
                              : context.colors.outlineVariant,
                          borderRadius: AppRadii.pillAll,
                        ),
                        child: SizedBox(width: i == _page ? 22 : 8, height: 8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.primaryButtonHeight,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _page == 2 ? l10n.onboardingFinish : l10n.continueAction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        const _HeroIcon(icon: Icons.auto_graph),
        const SizedBox(height: AppSpacing.lg),
        _Eyebrow(l10n.onboardingPage1Eyebrow),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingPage1Title,
          style: context.textStyles.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingPage1Body,
          style: context.textStyles.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _Bullet(
          icon: Icons.apps_outlined,
          title: l10n.onboardingPage1Item1Title,
          body: l10n.onboardingPage1Item1Body,
        ),
        const SizedBox(height: AppSpacing.sm),
        _Bullet(
          icon: Icons.hub_outlined,
          title: l10n.onboardingPage1Item2Title,
          body: l10n.onboardingPage1Item2Body,
        ),
      ],
    );
  }
}

class _UsagePage extends StatelessWidget {
  const _UsagePage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        const _HeroIcon(icon: Icons.schedule_outlined),
        const SizedBox(height: AppSpacing.lg),
        _Eyebrow(l10n.onboardingPage2Eyebrow),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingPage2Title,
          style: context.textStyles.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingPage2Body,
          style: context.textStyles.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        BlocBuilder<AccessCubit, AccessState>(
          builder: (context, state) {
            final ready = state is AccessReady ? state.status : null;
            final granted = ready?.hasUsageAccess ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (ready?.isRestrictedSettingsLikely ?? false) ...[
                  SurfaceCard(
                    color: context.colors.secondaryContainer,
                    child: Text(
                      l10n.onboardingRestrictedBody,
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    onPressed: () =>
                        context.read<AccessCubit>().openOwnAppDetails(),
                    child: Text(l10n.onboardingOpenAppInfo),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                FilledButton.tonal(
                  onPressed: granted
                      ? null
                      : () => context
                            .read<AccessCubit>()
                            .openUsageAccessSettings(),
                  child: Text(
                    granted
                        ? l10n.onboardingUsageGranted
                        : l10n.onboardingGrantUsage,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ShieldPage extends StatelessWidget {
  const _ShieldPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      children: [
        const _HeroIcon(icon: Icons.shield_outlined),
        const SizedBox(height: AppSpacing.lg),
        _Eyebrow(l10n.onboardingPage3Eyebrow),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingPage3Title,
          style: context.textStyles.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingPage3Body,
          style: context.textStyles.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.tonal(
          onPressed: () => context.read<TrackerShieldCubit>().start(),
          child: Text(l10n.onboardingStartShield),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingSkipShield,
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: SizedBox.square(
          dimension: 120,
          child: Icon(icon, size: 48, color: context.colors.primary),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.secondaryContainer,
          borderRadius: AppRadii.pillAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            text.toUpperCase(),
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleSmall),
                Text(
                  body,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
