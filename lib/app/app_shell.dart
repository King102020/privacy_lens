import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/app_dimensions.dart';
import '../shared/extensions/context_extensions.dart';
import '../shared/guide/tab_guide.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final destinations = [
      (Icons.home_outlined, Icons.home, context.l10n.navHome),
      (Icons.apps_outlined, Icons.apps, context.l10n.navApps),
      (Icons.shield_outlined, Icons.shield, context.l10n.navFindings),
      (Icons.hub_outlined, Icons.hub, context.l10n.navTrackers),
      (Icons.tune, Icons.tune, context.l10n.navSettings),
    ];
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;
    final scaffold = wide
        ? Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: navigationShell.goBranch,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final (outlined, filled, label) in destinations)
                      NavigationRailDestination(
                        icon: Icon(outlined),
                        selectedIcon: Icon(filled),
                        label: Text(label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          )
        : Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: [
                for (final (outlined, filled, label) in destinations)
                  NavigationDestination(
                    icon: Icon(outlined),
                    selectedIcon: Icon(filled),
                    label: label,
                  ),
              ],
            ),
          );
    return TabGuideHost(
      tabIndex: navigationShell.currentIndex,
      child: scaffold,
    );
  }
}
