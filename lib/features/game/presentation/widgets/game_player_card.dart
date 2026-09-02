import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "game_stone.dart";

/// Carte d'information d'un camp — nom, nombre de pions capturés par ce
/// camp, mise en valeur dorée quand c'est à lui de jouer.
class GamePlayerCard extends StatelessWidget {
  const GamePlayerCard({
    required this.color,
    required this.playerName,
    required this.piecesCapturedLabel,
    required this.isActiveTurn,
    super.key,
  });

  final PlayerColor color;
  final String playerName;

  /// Texte déjà localisé et pluralisé (ex. "3 pions capturés").
  final String piecesCapturedLabel;

  /// `true` si c'est actuellement le tour de ce camp.
  final bool isActiveTurn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppSpacing.durationFast,
      padding: AppSpacing.cardPaddingCompact,
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(
          color: isActiveTurn ? AppColors.primary : Colors.transparent,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      child: Row(
        children: [
          GameStone(color: color, size: AppSpacing.avatarSm),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.paleMint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  piecesCapturedLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.paleMint54,
                  ),
                ),
              ],
            ),
          ),
          if (isActiveTurn)
            Container(
              width: AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
