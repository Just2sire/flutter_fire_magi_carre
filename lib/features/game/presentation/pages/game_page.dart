import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppOptionsSheet;
import "../providers/game_providers.dart";
import "../widgets/index.dart";

/// Écran de partie locale — l'utilisateur (blancs) affronte l'IA (noirs)
/// sur un plateau standard 5x5.
class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  Position? _selectedPosition;
  AiDifficulty _difficulty = AiDifficulty.medium;
  bool _aiMoveInFlight = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    ref.listen<GameState>(gameProvider, (previous, next) {
      final shouldTriggerAi =
          !next.status.isOver &&
          next.currentPlayer == PlayerColor.black &&
          next.pendingPromotion == null &&
          !_aiMoveInFlight;
      if (shouldTriggerAi) _triggerAiMove();

      final justEnded =
          next.status.isOver && (previous == null || !previous.status.isOver);
      if (justEnded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showGameOverDialog(next.status);
        });
      }
    });

    final legalMoves = _selectedPosition != null
        ? notifier.validMovesFor(_selectedPosition!)
        : const <Move>[];
    final promotionSlots =
        gameState.pendingPromotion != null &&
            gameState.pendingPromotion!.promotingPlayer == PlayerColor.white
        ? gameState.pendingPromotion!.availableSlots
        : const <Position>[];

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(
            title: l10n.gameTitle,
            actions: [
              IconButton(
                tooltip: l10n.gameUndoCta,
                onPressed: _aiMoveInFlight || !notifier.canUndo
                    ? null
                    : _undo,
                icon: const Icon(AppIcons.undo),
              ),
              IconButton(
                tooltip: l10n.gameDifficultyTitle,
                onPressed: _aiMoveInFlight ? null : _pickDifficulty,
                icon: const Icon(AppIcons.settings),
              ),
              IconButton(
                tooltip: l10n.gameRestartCta,
                onPressed: _aiMoveInFlight ? null : _restart,
                icon: const Icon(AppIcons.refresh),
              ),
            ],
          ),
          AppSpacing.gapVMd,
          Padding(
            padding: AppSpacing.screenPaddingH,
            child: GamePlayerCard(
              color: PlayerColor.black,
              playerName: l10n.gamePlayerBlack,
              // Le camp noir capture des pions BLANCS : c'est bien
              // `whiteCapturedCount` (pertes blanches) qui compte ses prises.
              piecesCapturedLabel: l10n.gamePiecesCaptured(
                gameState.whiteCapturedCount,
              ),
              isActiveTurn:
                  gameState.currentPlayer == PlayerColor.black &&
                  !gameState.status.isOver,
            ),
          ),
          AppSpacing.gapVSm,
          // Toujours monté (juste son opacité change) : sinon l'ajout/retrait
          // de ce `Row` dans la `Column` fait sauter la hauteur du plateau
          // en dessous à chaque passage en/hors "L'IA réfléchit…".
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AnimatedOpacity(
              duration: AppSpacing.durationFast,
              opacity: _aiMoveInFlight ? 1 : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  AppSpacing.gapHSm,
                  Text(
                    l10n.gameAiThinking,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: AppSpacing.screenPaddingH,
            child: ClassicGameBoard(
              board: gameState.board,
              selectedPosition: _selectedPosition,
              legalMoves: legalMoves,
              promotionSlots: promotionSlots,
              onCellTap: _onCellTap,
            ),
          ),
          AppSpacing.gapVSm,
          Padding(
            padding: AppSpacing.screenPaddingH,
            child: GamePlayerCard(
              color: PlayerColor.white,
              playerName: l10n.gamePlayerWhite,
              // Symétriquement, le camp blanc capture des pions noirs.
              piecesCapturedLabel: l10n.gamePiecesCaptured(
                gameState.blackCapturedCount,
              ),
              isActiveTurn:
                  gameState.currentPlayer == PlayerColor.white &&
                  !gameState.status.isOver,
            ),
          ),
        ],
      ),
    );
  }

  void _onCellTap(Position pos) {
    if (_aiMoveInFlight) return;
    final state = ref.read(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    final pendingPromotion = state.pendingPromotion;

    if (pendingPromotion != null) {
      if (pendingPromotion.promotingPlayer == PlayerColor.white &&
          pendingPromotion.availableSlots.contains(pos)) {
        notifier.resolvePromotion(pos);
      }
      return;
    }

    if (state.status.isOver || state.currentPlayer != PlayerColor.white) {
      return;
    }

    if (_selectedPosition != null) {
      final legalMoves = notifier.validMovesFor(_selectedPosition!);
      Move? move;
      for (final candidate in legalMoves) {
        if (candidate.to == pos) {
          move = candidate;
          break;
        }
      }
      if (move != null) {
        notifier.playMove(move);
        setState(() => _selectedPosition = null);
        return;
      }
    }

    final piece = state.board.pieceAt(pos);
    if (piece != null && piece.color == PlayerColor.white) {
      setState(() {
        _selectedPosition = _selectedPosition == pos ? null : pos;
      });
    } else {
      setState(() => _selectedPosition = null);
    }
  }

  void _undo() {
    ref.read(gameProvider.notifier).undo();
    setState(() => _selectedPosition = null);
  }

  void _restart() {
    ref.read(gameProvider.notifier).newGame();
    setState(() => _selectedPosition = null);
  }

  Future<void> _triggerAiMove() async {
    setState(() => _aiMoveInFlight = true);
    await ref.read(gameProvider.notifier).requestAiMove(_difficulty);
    if (mounted) setState(() => _aiMoveInFlight = false);
  }

  Future<void> _pickDifficulty() async {
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<AiDifficulty>(
      context: context,
      builder: (_) => AppOptionsSheet<AiDifficulty>(
        title: l10n.gameDifficultyTitle,
        current: _difficulty,
        options: [
          (
            value: AiDifficulty.easy,
            label: l10n.gameDifficultyEasy,
            icon: AppIcons.difficultyEasy,
          ),
          (
            value: AiDifficulty.medium,
            label: l10n.gameDifficultyMedium,
            icon: AppIcons.difficultyMedium,
          ),
          (
            value: AiDifficulty.hard,
            label: l10n.gameDifficultyHard,
            icon: AppIcons.difficultyHard,
          ),
        ],
      ),
    );
    if (selected != null) setState(() => _difficulty = selected);
  }

  Future<void> _showGameOverDialog(GameStatus status) async {
    final l10n = context.l10n;
    final (title, message) = switch (status) {
      GameStatus.whiteWins => (
        l10n.gameOverWhiteWinsTitle,
        l10n.gameOverWhiteWinsMessage,
      ),
      GameStatus.blackWins => (
        l10n.gameOverBlackWinsTitle,
        l10n.gameOverBlackWinsMessage,
      ),
      GameStatus.draw => (l10n.gameOverDrawTitle, l10n.gameOverDrawMessage),
      GameStatus.playing => (l10n.gameTitle, ""),
    };

    final playAgain = await context.showConfirmDialog(
      title: title,
      content: message,
      confirmLabel: l10n.gameNewGameCta,
      cancelLabel: l10n.gameQuitCta,
    );

    if (!mounted) return;
    if (playAgain == true) {
      ref.read(gameProvider.notifier).newGame();
      setState(() => _selectedPosition = null);
    } else {
      context.popScreen();
    }
  }
}
