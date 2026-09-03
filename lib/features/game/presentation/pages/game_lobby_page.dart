import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTopbar;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppGroupedCard, AppSectionLabel;

enum _GameMode { solo, online }

/// Écran de configuration d'une partie — choix du mode (solo vs en ligne)
/// et du niveau de l'IA avant de lancer la partie.
class GameLobbyPage extends ConsumerStatefulWidget {
  const GameLobbyPage({super.key});

  @override
  ConsumerState<GameLobbyPage> createState() => _GameLobbyPageState();
}

class _GameLobbyPageState extends ConsumerState<GameLobbyPage> {
  _GameMode _mode = _GameMode.solo;
  AiDifficulty _difficulty = AiDifficulty.medium;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTopbar(title: l10n.gameLobbyTitle),
          AppSpacing.gapVLg,
          Padding(
            padding: AppSpacing.screenPaddingH,
            child: Row(
              spacing: AppSpacing.md,
              children: [
                Expanded(
                  child: _ModeCard(
                    icon: AppIcons.navLobby,
                    title: l10n.gameLobbyModeSolo,
                    subtitle: l10n.gameLobbyModeSoloDescription,
                    selected: _mode == _GameMode.solo,
                    onTap: () => setState(() => _mode = _GameMode.solo),
                  ),
                ),
                Expanded(
                  child: _ModeCard(
                    icon: AppIcons.globe,
                    title: l10n.gameLobbyModeOnline,
                    subtitle: l10n.gameLobbyModeOnlineDescription,
                    selected: _mode == _GameMode.online,
                    comingSoon: true,
                    onTap: () => setState(() => _mode = _GameMode.online),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapVXxl,
          AnimatedSwitcher(
            duration: AppSpacing.durationFast,
            child: _mode == _GameMode.solo
                ? _SoloContent(
                    key: const ValueKey(_GameMode.solo),
                    selectedDifficulty: _difficulty,
                    onDifficultyChanged: (d) =>
                        setState(() => _difficulty = d),
                  )
                : const _OnlineContent(key: ValueKey(_GameMode.online)),
          ),
          AppSpacing.gapVXxl,
          Padding(
            padding: AppSpacing.screenPaddingH,
            child: AppElevatedButton(
              text: l10n.gameLobbyStartCta,
              onPressed: _mode == _GameMode.solo ? _startSoloGame : null,
            ),
          ),
          AppSpacing.gapVLg,
        ],
      ),
    );
  }

  void _startSoloGame() => context.pushGameLocal<void>(extra: _difficulty);
}

// ─── Mode selector cards ───────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.comingSoon = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final bool comingSoon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.durationFast,
        padding: AppSpacing.insetMd,
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceContainer,
          borderRadius: AppSpacing.roundedXl,
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected
                ? AppSpacing.borderWidthMedium
                : AppSpacing.borderWidthBase,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: AppSpacing.iconMd,
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                ),
                if (comingSoon) ...[
                  AppSpacing.gapHSm,
                  const _ComingSoonBadge(),
                ],
              ],
            ),
            AppSpacing.gapVSm,
            Text(
              title,
              style: tt.labelLarge?.copyWith(
                color: selected ? cs.primary : cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: tt.bodySmall?.copyWith(
                color: selected
                    ? cs.primary.withAlpha(180)
                    : cs.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Coming soon badge ─────────────────────────────────────────────────────

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(31),
        borderRadius: AppSpacing.roundedSm,
      ),
      child: Text(
        context.l10n.gameLobbyComingSoon,
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Solo mode content ─────────────────────────────────────────────────────

class _SoloContent extends StatelessWidget {
  const _SoloContent({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  final AiDifficulty selectedDifficulty;
  final ValueChanged<AiDifficulty> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: AppSpacing.screenPaddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionLabel(text: l10n.gameLobbyAiSection),
          AppSpacing.gapVSm,
          AppGroupedCard(
            children: [
              _DifficultyTile(
                icon: AppIcons.difficultyEasy,
                iconColor: const Color(0xFF22C55E),
                title: l10n.gameDifficultyEasy,
                subtitle: l10n.gameDifficultyEasyDescription,
                selected: selectedDifficulty == AiDifficulty.easy,
                onTap: () => onDifficultyChanged(AiDifficulty.easy),
              ),
              _DifficultyTile(
                icon: AppIcons.difficultyMedium,
                iconColor: const Color(0xFFF59E0B),
                title: l10n.gameDifficultyMedium,
                subtitle: l10n.gameDifficultyMediumDescription,
                selected: selectedDifficulty == AiDifficulty.medium,
                onTap: () => onDifficultyChanged(AiDifficulty.medium),
              ),
              _DifficultyTile(
                icon: AppIcons.difficultyHard,
                iconColor: const Color(0xFFEF4444),
                title: l10n.gameDifficultyHard,
                subtitle: l10n.gameDifficultyHardDescription,
                selected: selectedDifficulty == AiDifficulty.hard,
                onTap: () => onDifficultyChanged(AiDifficulty.hard),
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DifficultyTile extends StatelessWidget {
  const _DifficultyTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(31),
                    borderRadius: AppSpacing.roundedMd,
                  ),
                  child: Icon(icon, size: AppSpacing.iconSm, color: iconColor),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: tt.labelLarge?.copyWith(
                          color: selected ? cs.primary : cs.onSurface,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: AppSpacing.durationFast,
                  opacity: selected ? 1.0 : 0.0,
                  child: Icon(
                    AppIcons.check,
                    size: AppSpacing.iconSm,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: AppSpacing.lg + 36 + AppSpacing.md,
            color: cs.outlineVariant,
          ),
      ],
    );
  }
}

// ─── Online mode content ───────────────────────────────────────────────────

class _OnlineContent extends StatelessWidget {
  const _OnlineContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: AppSpacing.screenPaddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionLabel(text: l10n.gameLobbyInviteTitle),
          AppSpacing.gapVSm,
          Opacity(
            opacity: 0.55,
            child: AppGroupedCard(
              children: [
                _OnlineTile(
                  icon: AppIcons.link,
                  title: l10n.gameLobbyInviteTitle,
                  subtitle: l10n.gameLobbyInviteSubtitle,
                ),
              ],
            ),
          ),
          AppSpacing.gapVXxl,
          AppSectionLabel(text: l10n.gameLobbyFriendsTitle),
          AppSpacing.gapVSm,
          Opacity(
            opacity: 0.55,
            child: AppGroupedCard(
              children: [
                _OnlineTile(
                  icon: AppIcons.users,
                  title: l10n.gameLobbyFriendsEmpty,
                ),
              ],
            ),
          ),
          AppSpacing.gapVMd,
          const Center(child: _ComingSoonBadge()),
        ],
      ),
    );
  }
}

class _OnlineTile extends StatelessWidget {
  const _OnlineTile({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.onSurfaceVariant.withAlpha(31),
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconSm,
              color: cs.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: tt.labelLarge),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
