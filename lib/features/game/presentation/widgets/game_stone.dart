import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";

/// Un pion façon "plateau classique" — sphère glacée avec reflet, comme un
/// vrai pion en bois/verre posé sur le plateau.
class GameStone extends StatelessWidget {
  const GameStone({required this.color, super.key, this.size = 40});

  final PlayerColor color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isWhite = color == PlayerColor.white;
    final base = isWhite ? AppColors.pionBlanc : AppColors.pionNoir;
    final highlight = isWhite ? Colors.white : const Color(0xFF5A4A3A);
    final edge = isWhite ? AppColors.primary : AppColors.pionNoirBorder;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [highlight, base, edge],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowFloating,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
