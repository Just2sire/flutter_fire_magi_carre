import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "game_stone.dart";

/// Rendu "plateau classique" façon Alquerque : fond bois, lignes de
/// connexion dorées (y compris les diagonales sur les cases `(row+col)`
/// paires) et pions sphériques posés aux intersections plutôt que dans des
/// cases pleines. C'est le rendu par défaut de l'écran de jeu ; `GameBoard`
/// (grille plate) reste disponible comme variante alternative.
class ClassicGameBoard extends StatelessWidget {
  const ClassicGameBoard({
    required this.board,
    required this.onCellTap,
    super.key,
    this.selectedPosition,
    this.legalMoves = const [],
    this.promotionSlots = const [],
  });

  final Board board;

  /// Position actuellement sélectionnée par le joueur, le cas échéant.
  final Position? selectedPosition;

  /// Coups légaux depuis [selectedPosition], utilisés pour surligner les
  /// destinations possibles.
  final List<Move> legalMoves;

  /// Cases où une promotion en attente peut être résolue.
  final List<Position> promotionSlots;

  final ValueChanged<Position> onCellTap;

  @override
  Widget build(BuildContext context) {
    final size = board.size;
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          borderRadius: AppSpacing.roundedLg,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.neutral800, AppColors.neutral900],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPlateau,
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final extent = constraints.maxWidth;
            // `Stack` clippe par défaut (`Clip.hardEdge`) : sans marge, les
            // pions des bords (row/col 0 et size-1) seraient coupés en deux
            // par les bords du Stack, puisque leur centre tombe pile sur
            // l'arête. On réserve donc une marge — assez large pour
            // contenir la moitié de la zone de tap du plus gros pion —
            // entre le Stack et la grille elle-même.
            final margin = extent * 0.1;
            final gridExtent = extent - margin * 2;
            final step = gridExtent / (size - 1);
            return SizedBox(
              width: extent,
              height: extent,
              child: Stack(
                children: [
                  Positioned(
                    left: margin,
                    top: margin,
                    child: CustomPaint(
                      size: Size.square(gridExtent),
                      painter: _BoardLinesPainter(
                        gridSize: size,
                        color: AppColors.primary.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  for (var row = 0; row < size; row++)
                    for (var col = 0; col < size; col++)
                      _pointAt(Position(row: row, col: col), step, margin),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pointAt(Position pos, double step, double origin) {
    return _BoardPoint(
      position: pos,
      step: step,
      origin: origin,
      piece: board.pieceAt(pos),
      isSelected: selectedPosition == pos,
      isPromotionSlot: promotionSlots.contains(pos),
      destinationMove: _destinationMoveTo(pos),
      onTap: onCellTap,
    );
  }

  Move? _destinationMoveTo(Position pos) {
    for (final move in legalMoves) {
      if (move.to == pos) return move;
    }
    return null;
  }
}

/// Trace les lignes de connexion du plateau — horizontales/verticales entre
/// toutes les intersections voisines, diagonales uniquement entre deux
/// cases `(row+col)` paires (règle Alquerque : la parité se conserve à
/// chaque pas diagonal ±1/±1, donc seules les cases paires sont reliées en
/// diagonale entre elles).
class _BoardLinesPainter extends CustomPainter {
  const _BoardLinesPainter({required this.gridSize, required this.color});

  final int gridSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final step = canvasSize.width / (gridSize - 1);
    Offset center(int row, int col) => Offset(col * step, row * step);

    for (var row = 0; row < gridSize; row++) {
      for (var col = 0; col < gridSize; col++) {
        if (col + 1 < gridSize) {
          canvas.drawLine(center(row, col), center(row, col + 1), paint);
        }
        if (row + 1 < gridSize) {
          canvas.drawLine(center(row, col), center(row + 1, col), paint);
        }
        if ((row + col).isEven) {
          if (row + 1 < gridSize && col + 1 < gridSize) {
            canvas.drawLine(
              center(row, col),
              center(row + 1, col + 1),
              paint,
            );
          }
          if (row + 1 < gridSize && col - 1 >= 0) {
            canvas.drawLine(
              center(row, col),
              center(row + 1, col - 1),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardLinesPainter oldDelegate) =>
      oldDelegate.gridSize != gridSize || oldDelegate.color != color;
}

/// Une intersection du plateau : zone de tap, surbrillance d'état, pion ou
/// simple point décoratif si la case est vide et neutre.
class _BoardPoint extends StatelessWidget {
  const _BoardPoint({
    required this.position,
    required this.step,
    required this.origin,
    required this.piece,
    required this.isSelected,
    required this.isPromotionSlot,
    required this.destinationMove,
    required this.onTap,
  });

  final Position position;
  final double step;

  /// Décalage du coin haut-gauche de la grille dans le `Stack` parent.
  final double origin;
  final Piece? piece;
  final bool isSelected;
  final bool isPromotionSlot;
  final Move? destinationMove;
  final ValueChanged<Position> onTap;

  @override
  Widget build(BuildContext context) {
    final hitSize = step * 0.86;
    final stoneSize = step * 0.72;
    final isHighlighted =
        isSelected || isPromotionSlot || destinationMove != null;

    return Positioned(
      left: origin + position.col * step - hitSize / 2,
      top: origin + position.row * step - hitSize / 2,
      width: hitSize,
      height: hitSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(position),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isHighlighted)
                Container(
                  width: hitSize,
                  height: hitSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPromotionSlot
                        ? AppColors.casePromotion
                        : isSelected
                            ? AppColors.caseSelected
                            : destinationMove!.isCapture
                                ? AppColors.caseCapture
                                : AppColors.caseHover,
                  ),
                ),
              if (piece != null)
                GameStone(color: piece!.color, size: stoneSize)
              else if (destinationMove != null)
                Container(
                  width: stoneSize * 0.3,
                  height: stoneSize * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: destinationMove!.isCapture
                        ? AppColors.semanticError
                        : AppColors.primary,
                  ),
                )
              else
                Container(
                  width: stoneSize * 0.14,
                  height: stoneSize * 0.14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
