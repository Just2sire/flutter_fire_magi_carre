import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppElevatedButton;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppSectionLabel, AppGroupedCard, AppTileRow, AppAvatar;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";

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

    return AppScaffold(
      scrollable: true,
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          AppTopbar(
            title: l10n.profileTitle,
            showLeading: false,
            actions: [
              IconButton(
                onPressed: () => context.pushSettings<void>(),
                icon: const Icon(AppIcons.settings, size: AppSpacing.iconXl),
              ),
            ],
          ),
          AppSpacing.gapVSm,
          Container(
            padding: AppSpacing.insetLg,
            // padding: const EdgeInsets.symmetric(
            //   vertical: AppSpacing.xl,
            //   horizontal: AppSpacing.lg,
            // ),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                AppAvatar(avatarUrl: profile.avatarUrl),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      profile.username,
                      style: tt.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                      Text(
                        profile.bio!,
                        style: tt.labelLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        overflow: .ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatPill(
                          icon: AppIcons.navLeaderboard,
                          value: "${profile.rating}",
                          label: l10n.profileRatingLabel,
                        ),
                        AppSpacing.gapHXl,
                        _StatPill(
                          icon: AppIcons.users,
                          value: "${profile.friendsCount}",
                          label: l10n.profileFriendsLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapVXxl,
          AppSectionLabel(text: l10n.settingsAccountSection),
          AppSpacing.gapVSm,
          AppGroupedCard(
            children: [
              AppTileRow(
                icon: AppIcons.pencil,
                title: l10n.profileEditTitle,
                onTap: () => context.pushProfileEdit<void>(),
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
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: cs.primary),
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                label,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
