import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "game_piece.dart";

/// Grille de jeu 5x5 (ou NxN selon [board]) — affiche les pions, la case
/// sélectionnée, les destinations légales (dont les captures) et les cases
/// de promotion disponibles. Ne connaît aucune règle : tout lui est fourni
/// par l'appelant.
class GameBoard extends StatelessWidget {
  const GameBoard({
    required this.board,
    required this.onCellTap,
    super.key,
    this.selectedPosition,
    this.legalMoves = const [],
    this.promotionSlots = const [],
  });

  final Board board;
  final Position? selectedPosition;

  /// Coups légaux depuis [selectedPosition] — sert à surligner les
  /// destinations (et distinguer les captures).
  final List<Move> legalMoves;

  /// Cases de promotion disponibles (surlignées si non vide).
  final List<Position> promotionSlots;

  final ValueChanged<Position> onCellTap;

  @override
  Widget build(BuildContext context) {
    final size = board.size;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(color: AppColors.borderHairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var row = 0; row < size; row++)
              Expanded(
                child: Row(
                  children: [
                    for (var col = 0; col < size; col++)
                      Expanded(child: _buildCell(Position(row: row, col: col))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(Position pos) {
    final piece = board.pieceAt(pos);
    final isSelected = selectedPosition == pos;
    final isPromotionSlot = promotionSlots.contains(pos);
    Move? destinationMove;
    for (final move in legalMoves) {
      if (move.to == pos) {
        destinationMove = move;
        break;
      }
    }

    final Color background;
    if (isPromotionSlot) {
      background = AppColors.casePromotion;
    } else if (isSelected) {
      background = AppColors.caseSelected;
    } else if (destinationMove != null) {
      background = destinationMove.isCapture
          ? AppColors.caseCapture
          : AppColors.caseHover;
    } else {
      background = Colors.transparent;
    }

    return GestureDetector(
      onTap: () => onCellTap(pos),
      child: Container(
        margin: const EdgeInsets.all(0.5),
        color: background,
        child: Center(
          child: piece == null
              ? (destinationMove != null || isPromotionSlot
                    ? FractionallySizedBox(
                        widthFactor: 0.3,
                        heightFactor: 0.3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: destinationMove?.isCapture ?? false
                                ? AppColors.semanticError
                                : AppColors.primary,
                          ),
                        ),
                      )
                    : null)
              : Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: GamePiece(color: piece.color),
                ),
        ),
      ),
    );
  }
}
