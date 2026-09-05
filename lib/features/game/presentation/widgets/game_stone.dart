import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";

/// A game stone — a spherical pawn rendered with a radial gradient to
/// simulate depth, as if it were a glass or wood piece on the board.
///
/// Defaults to the app's standard piece colors; pass [overrideBase],
/// [overrideHighlight], or [overrideEdge] to apply a board theme palette.
class GameStone extends StatelessWidget {
  const GameStone({
    required this.color,
    super.key,
    this.size = 40,
    this.overrideBase,
    this.overrideHighlight,
    this.overrideEdge,
  });

  final PlayerColor color;
  final double size;

  /// Replaces the default fill color for this stone.
  final Color? overrideBase;

  /// Replaces the default radial-highlight color.
  final Color? overrideHighlight;

  /// Replaces the default rim/edge color.
  final Color? overrideEdge;

  @override
  Widget build(BuildContext context) {
    final isWhite = color == PlayerColor.white;
    final base =
        overrideBase ?? (isWhite ? AppColors.pionBlanc : AppColors.pionNoir);
    final highlight = overrideHighlight ??
        (isWhite ? Colors.white : const Color(0xFF5A4A3A));
    final edge = overrideEdge ??
        (isWhite ? AppColors.primary : AppColors.pionNoirBorder);

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
