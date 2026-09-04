import "dart:ui" show lerpDouble;

import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../providers/board_theme_provider.dart";
import "game_stone.dart";

/// Rendu "plateau classique" façon Alquerque : fond bois, lignes de
/// connexion dorées (y compris les diagonales sur les cases `(row+col)`
/// paires) et pions sphériques posés aux intersections plutôt que dans des
/// cases pleines. C'est le rendu par défaut de l'écran de jeu ; `GameBoard`
/// (grille plate) reste disponible comme variante alternative.
///
/// Le dernier coup IA ([lastMove]) est surligné, et toute transition de
/// [lastMove] vers une valeur non nulle déclenche une [SlideTransition]
/// animée du pion depuis sa case d'origine jusqu'à sa destination.
class ClassicGameBoard extends StatefulWidget {
  const ClassicGameBoard({
    required this.board,
    required this.onCellTap,
    super.key,
    this.selectedPosition,
    this.legalMoves = const [],
    this.promotionSlots = const [],
    this.lastMove,
    this.showLabels = false,
    this.boardTheme,
  });

  final Board board;

  /// Position actuellement sélectionnée par le joueur, le cas échéant.
  final Position? selectedPosition;

  /// Coups légaux depuis [selectedPosition], utilisés pour surligner les
  /// destinations possibles.
  final List<Move> legalMoves;

  /// Cases où une promotion en attente peut être résolue.
  final List<Position> promotionSlots;

  /// Dernier coup joué — ses cases d'origine et de destination sont
  /// surlignées, et un changement de valeur déclenche l'animation de
  /// déplacement du pion.
  final Move? lastMove;

  /// Affiche les labels de coordonnées algébriques (a–e, 1–5) autour du
  /// plateau.
  final bool showLabels;

  /// Palette visuelle optionnelle — se substitue aux couleurs par défaut
  /// (fond, lignes, pions des deux camps).
  final BoardTheme? boardTheme;

  final ValueChanged<Position> onCellTap;

  @override
  State<ClassicGameBoard> createState() => _ClassicGameBoardState();
}

class _ClassicGameBoardState extends State<ClassicGameBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _moveController;
  late final CurvedAnimation _moveAnimation;

  // Coup en cours d'animation — null quand aucune animation n'est active.
  Move? _animatingMove;
  PlayerColor? _animatingPieceColor;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _moveAnimation = CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    );
    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animatingMove = null;
          _animatingPieceColor = null;
        });
      }
    });
  }

  @override
  void didUpdateWidget(ClassicGameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Déclenche l'animation dès qu'un nouveau coup est communiqué.
    if (widget.lastMove != oldWidget.lastMove && widget.lastMove != null) {
      final move = widget.lastMove!;
      final piece = widget.board.pieceAt(move.to);
      if (piece != null) {
        setState(() {
          _animatingMove = move;
          _animatingPieceColor = piece.color;
        });
        _moveController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _moveAnimation.dispose();
    _moveController.dispose();
    super.dispose();
  }

  BoardTheme get _theme => widget.boardTheme ?? BoardTheme.classic;

  @override
  Widget build(BuildContext context) {
    final size = widget.board.size;
    final theme = _theme;
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedLg,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.boardColors,
          ),
          boxShadow: const [
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
            final margin = extent * 0.1;
            final gridExtent = extent - margin * 2;
            final step = gridExtent / (size - 1);
            final stoneSize = step * 0.72;
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
                        color: theme.lineColor,
                      ),
                    ),
                  ),
                  for (var row = 0; row < size; row++)
                    for (var col = 0; col < size; col++)
                      _pointAt(
                        Position(row: row, col: col),
                        step,
                        margin,
                        stoneSize,
                        theme,
                      ),
                  if (widget.showLabels) ...[
                    for (var col = 0; col < size; col++)
                      _CoordLabel(
                        label: String.fromCharCode(97 + col),
                        left: margin + col * step,
                        top: margin + (size - 1) * step + margin * 0.35,
                      ),
                    for (var row = 0; row < size; row++)
                      _CoordLabel(
                        label: "${size - row}",
                        left: margin * 0.25,
                        top: margin + row * step,
                      ),
                  ],
                  // Pion animé glissant de sa case d'origine à sa destination.
                  if (_animatingMove != null && _animatingPieceColor != null)
                    AnimatedBuilder(
                      animation: _moveAnimation,
                      builder: (context, _) {
                        final from = _animatingMove!.from;
                        final to = _animatingMove!.to;
                        final t = _moveAnimation.value;
                        final left = lerpDouble(
                          margin + from.col * step,
                          margin + to.col * step,
                          t,
                        )!;
                        final top = lerpDouble(
                          margin + from.row * step,
                          margin + to.row * step,
                          t,
                        )!;
                        return Positioned(
                          left: left - stoneSize / 2,
                          top: top - stoneSize / 2,
                          width: stoneSize,
                          height: stoneSize,
                          child: _themedStone(
                            _animatingPieceColor!,
                            stoneSize,
                            theme,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pointAt(
    Position pos,
    double step,
    double origin,
    double stoneSize,
    BoardTheme theme,
  ) {
    // Masque le pion à la destination pendant l'animation (il est rendu
    // par l'overlay animé).
    final hideStone = _animatingMove != null && pos == _animatingMove!.to;
    return _BoardPoint(
      position: pos,
      step: step,
      origin: origin,
      piece: hideStone ? null : widget.board.pieceAt(pos),
      isSelected: widget.selectedPosition == pos,
      isPromotionSlot: widget.promotionSlots.contains(pos),
      destinationMove: _destinationMoveTo(pos),
      isLastMoveFrom: widget.lastMove?.from == pos,
      isLastMoveTo: widget.lastMove?.to == pos,
      boardTheme: theme,
      onTap: widget.onCellTap,
    );
  }

  Move? _destinationMoveTo(Position pos) {
    for (final move in widget.legalMoves) {
      if (move.to == pos) return move;
    }
    return null;
  }

  /// Builds a [GameStone] with colors resolved from [theme].
  static Widget _themedStone(
    PlayerColor color,
    double size,
    BoardTheme theme,
  ) {
    final isWhite = color == PlayerColor.white;
    return GameStone(
      color: color,
      size: size,
      overrideBase: isWhite ? theme.stone1Base : theme.stone2Base,
      overrideHighlight:
          isWhite ? theme.stone1Highlight : theme.stone2Highlight,
      overrideEdge: isWhite ? theme.stone1Edge : theme.stone2Edge,
    );
  }
}

// ─── Coord label ─────────────────────────────────────────────────────────────

/// Label de coordonnée algébrique (lettre de colonne ou chiffre de rangée)
/// positionné par son centre dans le Stack du plateau.
class _CoordLabel extends StatelessWidget {
  const _CoordLabel({
    required this.label,
    required this.left,
    required this.top,
  });

  final String label;
  final double left;
  final double top;

  static const double _size = 14;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left - _size / 2,
      top: top - _size / 2,
      width: _size,
      height: _size,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: AppColors.paleMint54,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ─── Lines painter ───────────────────────────────────────────────────────────

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

// ─── Board point ─────────────────────────────────────────────────────────────

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
    required this.isLastMoveFrom,
    required this.isLastMoveTo,
    required this.onTap,
    required this.boardTheme,
  });

  final Position position;
  final double step;
  final double origin;
  final Piece? piece;
  final bool isSelected;
  final bool isPromotionSlot;
  final Move? destinationMove;
  final bool isLastMoveFrom;
  final bool isLastMoveTo;
  final ValueChanged<Position> onTap;
  final BoardTheme boardTheme;

  @override
  Widget build(BuildContext context) {
    final hitSize = step * 0.86;
    final stoneSize = step * 0.72;
    final isHighlighted =
        isSelected || isPromotionSlot || destinationMove != null;
    final isLastMove = isLastMoveFrom || isLastMoveTo;

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
              if (isLastMove)
                Container(
                  width: hitSize,
                  height: hitSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLastMoveTo
                        ? AppColors.caseAiMoveTo
                        : AppColors.caseAiMoveFrom,
                  ),
                ),
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
                _ClassicGameBoardState._themedStone(
                  piece!.color,
                  stoneSize,
                  boardTheme,
                )
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
