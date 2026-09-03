import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../../core/constants/app_icons.dart";
import "../../../core/extensions/build_context_extensions.dart";
import "../../../core/extensions/navigation_extensions.dart";
import "../../../core/routing/app_routes.dart";
import "../../../core/theme/app_colors.dart";
import "../../../core/theme/app_spacing.dart";
import "../../../l10n/app_localizations.dart";

List<NavItemData> getNavItems(AppLocalizations l10n) {
  return <NavItemData>[
    (
      index: 0,
      icon: AppIcons.navHome,
      label: l10n.navHome,
      route: AppRoutes.home,
    ),
    (
      index: 1,
      icon: AppIcons.navLobby,
      label: l10n.navLobby,
      route: AppRoutes.lobby,
    ),
    (
      index: 2,
      icon: AppIcons.navLeaderboard,
      label: l10n.navLeaderboard,
      route: AppRoutes.leaderboard,
    ),
    (
      index: 3,
      icon: AppIcons.navProfile,
      label: l10n.navProfile,
      route: AppRoutes.profile,
    ),
  ];
}

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navItems = getNavItems(l10n);
    final currentIndex = navigationShell.currentIndex;
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationMd,
        onPressed: () => context.pushGameLobby<void>(),
        tooltip: l10n.gameNewGameCta,
        child: const Icon(AppIcons.play, size: AppSpacing.iconMxl),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Onglets 0 et 1 — côté gauche de l'encoche
            ...List.generate(2, (i) {
              final item = navItems[i];
              final selected = currentIndex == i;
              return _NavItem(
                icon: item.icon,
                label: item.label,
                selected: selected,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                onTap: () => navigationShell.goBranch(
                  i,
                  initialLocation: i == navigationShell.currentIndex,
                ),
              );
            }),
            // Espace pour l'encoche du FAB
            const Expanded(child: SizedBox()),
            // Onglets 2 et 3 — côté droit de l'encoche
            ...List.generate(2, (i) {
              final idx = i + 2;
              final item = navItems[idx];
              final selected = currentIndex == idx;
              return _NavItem(
                icon: item.icon,
                label: item.label,
                selected: selected,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                onTap: () => navigationShell.goBranch(
                  idx,
                  initialLocation: idx == navigationShell.currentIndex,
                ),
              );
            }),
          ],
        ),
      ),

      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: navigationShell.currentIndex,
      //   onDestinationSelected: (index) => navigationShell.goBranch(
      //     index,
      //     initialLocation: index == navigationShell.currentIndex,
      //   ),
      //   destinations: [
      //     NavigationDestination(
      //       icon: const Icon(AppIcons.navHome),
      //       label: l10n.navHome,
      //     ),
      //     NavigationDestination(
      //       icon: const Icon(AppIcons.navLobby),
      //       label: l10n.navLobby,
      //     ),
      //     NavigationDestination(
      //       icon: const Icon(AppIcons.navLeaderboard),
      //       label: l10n.navLeaderboard,
      //     ),
      //     NavigationDestination(
      //       icon: const Icon(AppIcons.navProfile),
      //       label: l10n.navProfile,
      //     ),
      //   ],
      // ),
      //
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: AppSpacing.roundedLg,
        onTap: onTap,
        // Zone de tap ≥ 44×44 pt (accessibilité CDC)
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef NavItemData = ({int index, IconData icon, String label, String route});
