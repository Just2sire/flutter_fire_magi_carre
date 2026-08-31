import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_icons.dart";
import "../../../core/extensions/build_context_extensions.dart";

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.navHome),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.navLobby),
            label: l10n.navLobby,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.navLeaderboard),
            label: l10n.navLeaderboard,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.navProfile),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
