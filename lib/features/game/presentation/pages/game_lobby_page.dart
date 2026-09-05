import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTopbar, AppDivider;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppGroupedCard, AppSectionLabel;
import "../widgets/index.dart" show TimerPicker;
import "game_start_config.dart";

// ─── Bot data ──────────────────────────────────────────────────────────────

/// Caractère bot — personnalité IA avec un niveau sur l'échelle 1-10.
class _BotCharacter {
  const _BotCharacter({
    required this.name,
    required this.catchphrase,
    required this.level,
    required this.color,
    required this.assetPath,
  });

  final String name;
  final String catchphrase;
  final int level;
  final Color color;

  /// Path to the pre-generated SVG asset bundled in assets/avatars/bots/.
  final String assetPath;

  static const List<_BotCharacter> all = [
    _BotCharacter(
      name: "Ama",
      catchphrase: "C'est ma première partie !",
      level: 1,
      color: Color(0xFF4ADE80),
      assetPath: "assets/avatars/bots/ama.svg",
    ),
    _BotCharacter(
      name: "Kofi",
      catchphrase: "Je fais de mon mieux.",
      level: 2,
      color: Color(0xFF60A5FA),
      assetPath: "assets/avatars/bots/kofi.svg",
    ),
    _BotCharacter(
      name: "Yaa",
      catchphrase: "Je suis encore en apprentissage.",
      level: 3,
      color: Color(0xFFF87171),
      assetPath: "assets/avatars/bots/yaa.svg",
    ),
    _BotCharacter(
      name: "Kwamé",
      catchphrase: "Je ne recule jamais !",
      level: 4,
      color: Color(0xFFFBBF24),
      assetPath: "assets/avatars/bots/kwame.svg",
    ),
    _BotCharacter(
      name: "Abéna",
      catchphrase: "Chaque coup est une leçon.",
      level: 5,
      color: Color(0xFFA78BFA),
      assetPath: "assets/avatars/bots/abena.svg",
    ),
    _BotCharacter(
      name: "Kojo",
      catchphrase: "Je connais bien ce plateau.",
      level: 6,
      color: Color(0xFFFB923C),
      assetPath: "assets/avatars/bots/kojo.svg",
    ),
    _BotCharacter(
      name: "Akua",
      catchphrase: "Les pièges sont ma spécialité.",
      level: 7,
      color: Color(0xFFF472B6),
      assetPath: "assets/avatars/bots/akua.svg",
    ),
    _BotCharacter(
      name: "Efua",
      catchphrase: "Je vois plusieurs coups d'avance.",
      level: 8,
      color: Color(0xFF2DD4BF),
      assetPath: "assets/avatars/bots/efua.svg",
    ),
    _BotCharacter(
      name: "Yaw",
      catchphrase: "Tu devras te surpasser pour m'avoir.",
      level: 9,
      color: Color(0xFF818CF8),
      assetPath: "assets/avatars/bots/yaw.svg",
    ),
    _BotCharacter(
      name: "Nana",
      catchphrase: "Le Carré n'a plus de secrets pour moi.",
      level: 10,
      color: Color(0xFFEAB308),
      assetPath: "assets/avatars/bots/nana.svg",
    ),
  ];
}

// ─── Enums ─────────────────────────────────────────────────────────────────

enum _GameMode { solo, local2p, online }

// ─── Page ──────────────────────────────────────────────────────────────────

/// Écran de configuration d'une partie — choix du mode (solo vs en ligne)
/// et du bot adversaire avant de lancer la partie.
class GameLobbyPage extends ConsumerStatefulWidget {
  const GameLobbyPage({super.key});

  @override
  ConsumerState<GameLobbyPage> createState() => _GameLobbyPageState();
}

class _GameLobbyPageState extends ConsumerState<GameLobbyPage> {
  _GameMode _mode = _GameMode.solo;
  _BotCharacter _selectedBot = _BotCharacter.all[4]; // Abéna, niveau 5
  bool _flipBoard = false;
  int _timerDurationSeconds = 0; // 0 = sans minuterie
  int _incrementSeconds = 0;


  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(title: l10n.gameLobbyTitle),
          AppSpacing.gapVMd,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
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
                          icon: AppIcons.users,
                          title: l10n.gameLobbyModeLocal2p,
                          subtitle: l10n.gameLobbyModeLocal2pDescription,
                          selected: _mode == _GameMode.local2p,
                          onTap: () =>
                              setState(() => _mode = _GameMode.local2p),
                        ),
                      ),
                      Expanded(
                        child: _ModeCard(
                          icon: AppIcons.globe,
                          title: l10n.gameLobbyModeOnline,
                          subtitle: l10n.gameLobbyModeOnlineDescription,
                          selected: _mode == _GameMode.online,
                          onTap: () => setState(() => _mode = _GameMode.online),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapVXxl,
                  AnimatedSwitcher(
                    duration: AppSpacing.durationFast,
                    child: switch (_mode) {
                      _GameMode.solo => _SoloContent(
                        key: const ValueKey(_GameMode.solo),
                        selectedBot: _selectedBot,
                        onBotChanged: (bot) =>
                            setState(() => _selectedBot = bot),
                      ),
                      _GameMode.local2p => _Local2PContent(
                        key: const ValueKey(_GameMode.local2p),
                        flipBoard: _flipBoard,
                        onFlipBoardChanged: (v) =>
                            setState(() => _flipBoard = v),
                        timerDurationSeconds: _timerDurationSeconds,
                        incrementSeconds: _incrementSeconds,
                        onTimerChanged: (base, inc) => setState(() {
                          _timerDurationSeconds = base;
                          _incrementSeconds = inc;
                        }),
                      ),
                      _GameMode.online => const SizedBox.shrink(
                        key: ValueKey(_GameMode.online),
                      ),
                    },
                  ),
                  AppSpacing.gapVXxl,
                ],
              ),
            ),
          ),
          AppElevatedButton(
            text: l10n.gameLobbyStartCta,
            onPressed: switch (_mode) {
              _GameMode.solo => _startSoloGame,
              _GameMode.local2p => _startLocal2PGame,
              _GameMode.online => () => context.goLobby(),
            },
          ),
        ],
      ),
    );
  }

  void _startSoloGame() => context.pushGameLocal<void>(
    extra: GameStartConfig(
      level: _selectedBot.level,
      botName: _selectedBot.name,
      botColor: _selectedBot.color,
    ),
  );

  void _startLocal2PGame() => context.pushGameLocal<void>(
    extra: GameStartConfig(
      level: 1,
      botName: "",
      botColor: Colors.transparent,
      isLocalMultiplayer: true,
      timerDurationSeconds: _timerDurationSeconds,
      incrementSeconds: _incrementSeconds,
      flipBoard: _flipBoard,
    ),
  );
}

// ─── Mode selector cards ───────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: AppSpacing.yotta * 1.4,
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
            Icon(
              icon,
              size: AppSpacing.iconMd,
              color: selected ? cs.primary : cs.onSurfaceVariant,
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
                    ? cs.primary.withAlpha(225)
                    : cs.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: .ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Solo mode content ─────────────────────────────────────────────────────

/// Section Solo — sélection du bot adversaire par groupe de difficulté.
class _SoloContent extends StatelessWidget {
  const _SoloContent({
    super.key,
    required this.selectedBot,
    required this.onBotChanged,
  });

  final _BotCharacter selectedBot;
  final ValueChanged<_BotCharacter> onBotChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(text: l10n.gameLobbySelectBot),
        AppSpacing.gapVSm,
        AnimatedSwitcher(
          duration: AppSpacing.durationFast,
          child: _BotHeroCard(
            key: ValueKey(selectedBot.level),
            bot: selectedBot,
          ),
        ),
        AppSpacing.gapVLg,
        _BotGroup(
          label: l10n.gameDifficultyEasy,
          bots: _BotCharacter.all.where((b) => b.level <= 3).toList(),
          selectedBot: selectedBot,
          onBotSelected: onBotChanged,
        ),
        AppSpacing.gapVMd,
        _BotGroup(
          label: l10n.gameDifficultyMedium,
          bots: _BotCharacter.all
              .where((b) => b.level >= 4 && b.level <= 7)
              .toList(),
          selectedBot: selectedBot,
          onBotSelected: onBotChanged,
        ),
        AppSpacing.gapVMd,
        _BotGroup(
          label: l10n.gameDifficultyHard,
          bots: _BotCharacter.all.where((b) => b.level >= 8).toList(),
          selectedBot: selectedBot,
          onBotSelected: onBotChanged,
        ),
      ],
    );
  }
}

/// Carte héros du bot sélectionné — avatar, nom, niveau et phrase d'accroche.
class _BotHeroCard extends StatelessWidget {
  const _BotHeroCard({super.key, required this.bot});

  final _BotCharacter bot;

  static Color _levelColor(int level) {
    if (level <= 3) return const Color(0xFF22C55E);
    if (level <= 7) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final levelColor = _levelColor(bot.level);
    final levelLabel = bot.level <= 3
        ? l10n.gameDifficultyEasy
        : bot.level <= 7
        ? l10n.gameDifficultyMedium
        : l10n.gameDifficultyHard;

    return Container(
      padding: AppSpacing.insetLg,
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(
          color: bot.color.withAlpha(80),
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          SvgPicture.asset(
            bot.assetPath,
            width: AppSpacing.avatarLg,
            height: AppSpacing.avatarLg,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bot.name,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: levelColor.withAlpha(30),
                        borderRadius: AppSpacing.roundedFull,
                      ),
                      child: Text(
                        "${bot.level}/10",
                        style: tt.labelSmall?.copyWith(
                          color: levelColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVXs,
                Text(
                  levelLabel,
                  style: tt.labelMedium?.copyWith(
                    color: levelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapVXs,
                Text(
                  '"${bot.catchphrase}"',
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Groupe de bots par catégorie de difficulté, disposés en ligne horizontale.
class _BotGroup extends StatelessWidget {
  const _BotGroup({
    required this.label,
    required this.bots,
    required this.selectedBot,
    required this.onBotSelected,
  });

  final String label;
  final List<_BotCharacter> bots;
  final _BotCharacter selectedBot;
  final ValueChanged<_BotCharacter> onBotSelected;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: tt.titleSmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Expanded(child: AppDivider()),
          ],
        ),
        AppSpacing.gapVSm,
        Row(
          spacing: AppSpacing.lg,
          children: bots
              .map(
                (bot) => _BotPortrait(
                  bot: bot,
                  isSelected: selectedBot.level == bot.level,
                  onTap: () => onBotSelected(bot),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// Portrait cliquable d'un bot — cercle coloré avec initiale,
/// badge de niveau et nom en dessous.
class _BotPortrait extends StatelessWidget {
  const _BotPortrait({
    required this.bot,
    required this.isSelected,
    required this.onTap,
  });

  final _BotCharacter bot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: AppSpacing.durationFast,
                width: AppSpacing.peta,
                height: AppSpacing.peta,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? cs.primary : Colors.transparent,
                    width: AppSpacing.borderWidthThick,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: cs.primary.withAlpha(60),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: SvgPicture.asset(
                  bot.assetPath,
                  width: AppSpacing.peta,
                  height: AppSpacing.peta,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: cs.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: bot.color),
                  ),
                  child: Center(
                    child: Text(
                      "${bot.level}",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: bot.color,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVXs,
          Text(
            bot.name,
            style: tt.labelSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? cs.primary : cs.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Local 2-player content ────────────────────────────────────────────────

/// Section 2 Joueurs — configuration du plateau et de la minuterie.
class _Local2PContent extends StatelessWidget {
  const _Local2PContent({
    super.key,
    required this.flipBoard,
    required this.onFlipBoardChanged,
    required this.timerDurationSeconds,
    required this.incrementSeconds,
    required this.onTimerChanged,
  });

  final bool flipBoard;
  final ValueChanged<bool> onFlipBoardChanged;
  final int timerDurationSeconds;
  final int incrementSeconds;
  final void Function(int base, int increment) onTimerChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(text: l10n.gameLobbyLocal2pSettings),
        AppSpacing.gapVSm,
        AppGroupedCard(
          children: [
            _Local2PToggleTile(
              label: l10n.gameLobbyLocal2pFlipBoard,
              icon: AppIcons.flipBoard,
              value: flipBoard,
              onChanged: onFlipBoardChanged,
            ),
          ],
        ),
        AppSpacing.gapVLg,
        AppSectionLabel(text: l10n.gameLobbyLocal2pTimer),
        AppSpacing.gapVSm,
        TimerPicker(
          selectedBase: timerDurationSeconds,
          selectedIncrement: incrementSeconds,
          onChanged: onTimerChanged,
        ),
      ],
    );
  }
}

/// Ligne de toggle dans la configuration 2 joueurs — icône, libellé et switch.
class _Local2PToggleTile extends StatelessWidget {
  const _Local2PToggleTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: cs.onSurfaceVariant),
          AppSpacing.gapHMd,
          Expanded(child: Text(label, style: tt.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
