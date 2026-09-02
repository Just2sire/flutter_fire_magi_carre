import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";

/// Un pion — cercle plein coloré selon le camp.
class GamePiece extends StatelessWidget {
  const GamePiece({required this.color, super.key});

  final PlayerColor color;

  @override
  Widget build(BuildContext context) {
    final isWhite = color == PlayerColor.white;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isWhite ? AppColors.pionBlanc : AppColors.pionNoir,
        border: Border.all(
          color: isWhite ? AppColors.primary : AppColors.pionNoirBorder,
          width: AppSpacing.borderWidthMedium,
        ),
        boxShadow: isWhite
            ? const [BoxShadow(color: AppColors.pionBlancGlow, blurRadius: 8)]
            : null,
      ),
    );
  }
}
