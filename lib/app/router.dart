import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/apps/presentation/apps_screen.dart';
import '../features/findings/presentation/findings_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/settings/presentation/settings_cubit.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/trackers/presentation/trackers_screen.dart';
import '../shared/extensions/context_extensions.dart';
import 'app_shell.dart';

final packageNamePattern = RegExp(
  r'^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$',
);

class GoRouterRefresh extends ChangeNotifier {
  GoRouterRefresh(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

GoRouter createRouter({required SettingsCubit settings}) {
  final refresh = GoRouterRefresh(settings.stream);
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final completed = settings.state.onboardingCompleted;
      final onOnboarding = state.uri.path == '/onboarding';
      if (!completed && !onOnboarding) return '/onboarding';
      if (completed && onOnboarding) return '/home';
      return null;
    },
    errorBuilder: (context, state) => const _UnknownRoutePage(),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/apps',
                builder: (context, state) => const AppsScreen(),
                routes: [
                  GoRoute(
                    path: ':packageName',
                    redirect: (context, state) {
                      final name = state.pathParameters['packageName'] ?? '';
                      if (!packageNamePattern.hasMatch(name)) return '/apps';
                      return null;
                    },
                    builder: (context, state) => AppsScreen(
                      selectedPackage: state.pathParameters['packageName'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/findings',
                builder: (context, state) => const FindingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trackers',
                builder: (context, state) => const TrackersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.unknownRouteTitle,
                style: context.textStyles.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(context.l10n.unknownRouteBody, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: Text(context.l10n.unknownRouteHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
