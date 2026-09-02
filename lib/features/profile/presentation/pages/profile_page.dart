import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/providers/index.dart"
    show appThemeModeProvider;
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppElevatedButton;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppSectionLabel, AppGroupedCard, AppTileRow;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../widgets/profile_avatar.dart";

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final authState = ref.watch(authProvider);

    if (authState is AuthGuest) {
      return AppScaffold(
        body: Column(
          children: [
            AppTopbar(title: l10n.profileTitle, showLeading: false),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.profileGuestMessage, style: tt.bodyMedium),
                    AppSpacing.gapVLg,
                    AppElevatedButton(
                      text: l10n.profileGuestCta,
                      onPressed: () => context.goAuthLogin(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (authState is! AuthAuthenticated) {
      return AppScaffold(
        body: Column(
          children: [
            AppTopbar(title: l10n.profileTitle, showLeading: false),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    final profile = authState.profile;
    final cs = context.colorScheme;
    final themeMode = ref.watch(appThemeModeProvider);

    return AppScaffold(
      scrollable: true,
      body: Column(
        children: [
          AppTopbar(title: l10n.profileTitle, showLeading: false),
          AppSpacing.gapVSm,
          Container(
            padding: AppSpacing.insetLg,
            decoration: const BoxDecoration(
              borderRadius: AppSpacing.roundedXl,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.neutral900, AppColors.primaryPressed],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowPlateau,
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      spacing: AppSpacing.md,
                      crossAxisAlignment: .start,
                      children: [
                        ProfileAvatar(
                          avatarUrl: profile.avatarUrl,
                          isEditable: true,
                          onEdit: () => context.pushProfileEdit<void>(),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppSpacing.gapVLg,
                              Text(
                                profile.username,
                                style: tt.titleLarge?.copyWith(
                                  color: AppColors.paleMint,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (profile.bio != null &&
                                  profile.bio!.isNotEmpty)
                                Text(
                                  profile.bio!,
                                  style: tt.labelLarge?.copyWith(
                                    color: AppColors.paleMint70,
                                  ),
                                  overflow: .ellipsis,
                                  maxLines: 1,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapVLg,
                    Row(
                      spacing: AppSpacing.md,
                      children: [
                        Expanded(
                          child: _StatPill(
                            icon: AppIcons.navLeaderboard,
                            value: "${profile.rating}",
                            label: l10n.profileRatingLabel,
                          ),
                        ),
                        Expanded(
                          child: _StatPill(
                            icon: AppIcons.users,
                            value: "${profile.friendsCount}",
                            label: l10n.profileFriendsLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapVXxl,
          AppSectionLabel(text: l10n.profileAppearanceLabel),
          AppSpacing.gapVSm,
          _ThemeModeSwitcher(
            current: themeMode,
            onChanged: (mode) =>
                ref.read(appThemeModeProvider.notifier).setTheme(mode),
          ),
          AppSpacing.gapVXxl,
          AppSectionLabel(text: l10n.settingsAccountSection),
          AppSpacing.gapVSm,
          AppGroupedCard(
            children: [
              AppTileRow(
                icon: AppIcons.settings,
                title: l10n.settingsTitle,
                onTap: () => context.pushSettings<void>(),
              ),
              AppTileRow(
                icon: AppIcons.history,
                title: l10n.profileActivityTitle,
                onTap: () => context.pushProfileHistory<void>(),
              ),
              AppTileRow(
                icon: AppIcons.lockKeyhole,
                title: l10n.profileChangePasswordCta,
                onTap: () => context.pushProfileChangePassword<void>(),
              ),
              AppTileRow(
                icon: AppIcons.logout,
                title: l10n.settingsLogout,
                iconColor: cs.error,
                iconBackgroundColor: cs.error.withAlpha(31),
                titleColor: cs.error,
                onTap: () => _logout(context, ref),
                isLast: true,
              ),
            ],
          ),
          AppSpacing.gapVLg,
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.settingsLogoutConfirmTitle,
      content: context.l10n.settingsLogoutConfirmMessage,
      confirmLabel: context.l10n.settingsLogout,
      cancelLabel: context.l10n.commonCancel,
      destructive: true,
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }
}

/// Badge compact icône + valeur + libellé, utilisé pour les stats du profil.
///
/// Couleurs fixes (pas `ColorScheme`) : cette carte vit toujours sur le
/// dégradé sombre de la carte héro, quel que soit le thème clair/sombre
/// de l'app.
class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: AppColors.primary),
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: tt.titleMedium?.copyWith(
                  color: AppColors.paleMint,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: tt.bodySmall?.copyWith(color: AppColors.paleMint54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Badge "Modifier" en surimpression sur la carte héro du profil.
class _EditBadge extends StatelessWidget {
  const _EditBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;

    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: AppSpacing.roundedFull,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedFull,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            spacing: AppSpacing.xs,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.pencil,
                size: AppSpacing.iconXs,
                color: AppColors.paleMint,
              ),
              Text(
                l10n.profileEditCta,
                style: tt.labelSmall?.copyWith(
                  color: AppColors.paleMint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sélecteur inline du thème de l'app (clair / sombre / système) — trois
/// segments dans un même conteneur, celui actif mis en évidence.
class _ThemeModeSwitcher extends StatelessWidget {
  const _ThemeModeSwitcher({required this.current, required this.onChanged});

  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colorScheme;
    final options = [
      (
        mode: ThemeMode.light,
        icon: AppIcons.sun,
        label: l10n.settingsThemeLight,
      ),
      (
        mode: ThemeMode.dark,
        icon: AppIcons.moon,
        label: l10n.settingsThemeDark,
      ),
      (
        mode: ThemeMode.system,
        icon: AppIcons.monitor,
        label: l10n.settingsThemeSystem,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          for (final option in options)
            Expanded(
              child: _ThemeModeSegment(
                icon: option.icon,
                label: option.label,
                selected: option.mode == current,
                onTap: () => onChanged(option.mode),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemeModeSegment extends StatelessWidget {
  const _ThemeModeSegment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Material(
      color: Colors.transparent,
      borderRadius: AppSpacing.roundedMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedMd,
        child: AnimatedContainer(
          duration: AppSpacing.durationFast,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected ? cs.primaryContainer : Colors.transparent,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppSpacing.iconMd,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
              AppSpacing.gapVXs,
              Text(
                label,
                style: tt.labelMedium?.copyWith(
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
