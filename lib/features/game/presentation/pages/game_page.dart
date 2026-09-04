import "dart:async";

import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTopbar;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../providers/board_theme_provider.dart";
import "../providers/game_history_providers.dart";
import "../providers/game_providers.dart";
import "../widgets/index.dart";
import "game_start_config.dart";

/// Écran de partie locale — l'utilisateur (blancs) affronte l'IA (noirs)
/// sur un plateau standard 5x5.
class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  Position? _selectedPosition;
  Move? _lastAiMove;
  int _difficultyLevel = 5;
  bool _aiMoveInFlight = false;
  bool _difficultyInitialized = false;
  bool _showMoveHints = true;
  bool _showLastAiMove = true;
  // Each false→true transition of drawClaimAvailable triggers one dialog.
  bool _prevDrawClaimAvailable = false;

  // ─── Move notation ────────────────────────────────────────────────────────
  Move? _lastMove;
  int _halfMoveCount = 0;

  // Bot identity — filled from GameStartConfig extra.
  // Defaults to Abéna (niv. 5) when no config is provided.
  String _botName = "Abéna";
  Color _botColor = const Color(0xFFA78BFA);

  // ─── Game duration tracking ───────────────────────────────────────────────
  final Stopwatch _gameStopwatch = Stopwatch();

  // ─── 2-player local mode ──────────────────────────────────────────────────
  bool _isLocalMultiplayer = false;
  bool _flipBoard = false;
  bool _timerEnabled = false;
  int _timerDurationSeconds = 0;
  int _incrementSeconds = 0;
  int _whiteTimeLeft = 0;
  int _blackTimeLeft = 0;
  Timer? _clockTimer;

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_difficultyInitialized) {
      _difficultyInitialized = true;
      _gameStopwatch.start();
      final extra = GoRouterState.of(context).extra;
      if (extra is GameStartConfig) {
        _difficultyLevel = extra.level;
        _botName = extra.botName;
        _botColor = extra.botColor;
        _isLocalMultiplayer = extra.isLocalMultiplayer;
        _flipBoard = extra.flipBoard;
        _timerDurationSeconds = extra.timerDurationSeconds;
        _incrementSeconds = extra.incrementSeconds;
        _timerEnabled = extra.timerDurationSeconds > 0;
        if (_timerEnabled) {
          _whiteTimeLeft = extra.timerDurationSeconds;
          _blackTimeLeft = extra.timerDurationSeconds;
          _startClock();
        }
      } else if (extra is int) {
        _difficultyLevel = extra;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    final boardTheme = ref.watch(boardThemeProvider);

    ref.listen<GameState>(gameProvider, (previous, next) {
      // AI move — solo mode only.
      final shouldTriggerAi =
          !_isLocalMultiplayer &&
          !next.status.isOver &&
          next.currentPlayer == PlayerColor.black &&
          next.pendingPromotion == null &&
          !_aiMoveInFlight;
      if (shouldTriggerAi) _triggerAiMove();

      if (next.status.isOver) _clockTimer?.cancel();

      final justEnded =
          next.status.isOver && (previous == null || !previous.status.isOver);
      if (justEnded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showGameOverSheet(next.status);
        });
      }

      // Draw claim — show dialog once per false→true transition.
      if (!_prevDrawClaimAvailable && next.drawClaimAvailable) {
        final reasons = next.drawClaimReasons;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showDrawClaimDialog(next, reasons);
        });
      }
      _prevDrawClaimAvailable = next.drawClaimAvailable;
    });

    final legalMoves = _showMoveHints && _selectedPosition != null
        ? notifier.validMovesFor(_selectedPosition!)
        : const <Move>[];

    // In 2P mode both promotions are resolved by the current human player;
    // in solo mode only white promotions are shown (black's are auto-resolved).
    final promotionSlots = switch (gameState.pendingPromotion) {
      null => const <Position>[],
      final p when _isLocalMultiplayer => p.availableSlots,
      final p when p.promotingPlayer == PlayerColor.white => p.availableSlots,
      _ => const <Position>[],
    };

    final shouldFlip =
        _isLocalMultiplayer &&
        _flipBoard &&
        gameState.currentPlayer == PlayerColor.black;

    return AppScaffold(
      // bottomSafeArea: false,
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       _GameAction(
      //         icon: AppIcons.undo,
      //         label: l10n.gameActionUndo,
      //         onPressed: _aiMoveInFlight || !notifier.canUndo ? null : _undo,
      //       ),
      //       _GameAction(
      //         icon: AppIcons.refresh,
      //         label: l10n.gameActionNew,
      //         onPressed: _aiMoveInFlight ? null : _restart,
      //       ),
      //       _GameAction(
      //         icon: AppIcons.settings,
      //         label: l10n.gameActionOptions,
      //         onPressed: _aiMoveInFlight ? null : _pickDifficulty,
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          AppTopbar(title: l10n.gameTitle),
          AppSpacing.gapVXl,
          if (_isLocalMultiplayer)
            _Local2PPlayerCard(
              color: PlayerColor.black,
              playerName: l10n.gamePlayerBlack,
              piecesCapturedLabel: l10n.gamePiecesCaptured(
                gameState.whiteCapturedCount,
              ),
              isActiveTurn:
                  gameState.currentPlayer == PlayerColor.black &&
                  !gameState.status.isOver,
              timerEnabled: _timerEnabled,
              timeLeftSeconds: _blackTimeLeft,
            )
          else
            _BotPlayerCard(
              botName: _botName,
              botColor: _botColor,
              difficultyLevel: _difficultyLevel,
              piecesCapturedLabel: l10n.gamePiecesCaptured(
                gameState.whiteCapturedCount,
              ),
              thinkingLabel: l10n.gameAiThinking,
              isActiveTurn:
                  gameState.currentPlayer == PlayerColor.black &&
                  !gameState.status.isOver,
              isThinking: _aiMoveInFlight,
            ),
          AppSpacing.gapVSm,
          AnimatedRotation(
            turns: shouldFlip ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ClassicGameBoard(
              board: gameState.board,
              selectedPosition: _selectedPosition,
              legalMoves: legalMoves,
              promotionSlots: promotionSlots,
              lastMove: !_isLocalMultiplayer && _showLastAiMove
                  ? _lastAiMove
                  : null,
              onCellTap: _onCellTap,
              showLabels: !shouldFlip,
              boardTheme: boardTheme,
            ),
          ),
          AppSpacing.gapVSm,
          _MoveNotationBar(
            lastMove: _lastMove,
            halfMoveCount: _halfMoveCount,
            boardSize: gameState.board.size,
          ),
          if (_isLocalMultiplayer)
            _Local2PPlayerCard(
              color: PlayerColor.white,
              playerName: l10n.gamePlayerWhite,
              piecesCapturedLabel: l10n.gamePiecesCaptured(
                gameState.blackCapturedCount,
              ),
              isActiveTurn:
                  gameState.currentPlayer == PlayerColor.white &&
                  !gameState.status.isOver,
              timerEnabled: _timerEnabled,
              timeLeftSeconds: _whiteTimeLeft,
            )
          else
            GamePlayerCard(
              color: PlayerColor.white,
              playerName: l10n.gamePlayerWhite,
              piecesCapturedLabel: l10n.gamePiecesCaptured(
                gameState.blackCapturedCount,
              ),
              isActiveTurn:
                  gameState.currentPlayer == PlayerColor.white &&
                  !gameState.status.isOver,
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _GameAction(
                icon: AppIcons.undo,
                label: l10n.gameActionUndo,
                onPressed: _aiMoveInFlight || !notifier.canUndo ? null : _undo,
              ),
              _GameAction(
                icon: AppIcons.refresh,
                label: l10n.gameActionNew,
                onPressed: _aiMoveInFlight ? null : _restart,
              ),
              if (!_isLocalMultiplayer)
                _GameAction(
                  icon: AppIcons.settings,
                  label: l10n.gameActionOptions,
                  onPressed: _aiMoveInFlight ? null : _pickDifficulty,
                ),
            ],
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
      // 2P: the current player resolves their own promotion.
      // Solo: only white resolves (black's are auto-resolved by the engine).
      final canResolve = _isLocalMultiplayer
          ? pendingPromotion.promotingPlayer == state.currentPlayer
          : pendingPromotion.promotingPlayer == PlayerColor.white;
      if (canResolve && pendingPromotion.availableSlots.contains(pos)) {
        notifier.resolvePromotion(pos);
      }
      return;
    }

    if (state.status.isOver) return;

    final currentPlayer = state.currentPlayer;
    // Solo: only white taps; 2P: the current player taps.
    if (!_isLocalMultiplayer && currentPlayer != PlayerColor.white) return;

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
        final playerWhoMoved = currentPlayer;
        notifier.playMove(move);
        setState(() {
          _selectedPosition = null;
          _lastAiMove = null;
          _lastMove = move;
          _halfMoveCount++;
          _applyIncrement(playerWhoMoved);
        });
        return;
      }
    }

    final piece = state.board.pieceAt(pos);
    if (piece != null && piece.color == currentPlayer) {
      setState(() {
        _selectedPosition = _selectedPosition == pos ? null : pos;
      });
    } else {
      setState(() => _selectedPosition = null);
    }
  }

  void _undo() {
    ref.read(gameProvider.notifier).undo();
    setState(() {
      _selectedPosition = null;
      _lastAiMove = null;
      _lastMove = null;
    });
  }

  void _restart() {
    _clockTimer?.cancel();
    _gameStopwatch
      ..reset()
      ..start();
    ref.read(gameProvider.notifier).newGame();
    setState(() {
      _selectedPosition = null;
      _lastAiMove = null;
      _lastMove = null;
      _halfMoveCount = 0;
      if (_timerEnabled) {
        _whiteTimeLeft = _timerDurationSeconds;
        _blackTimeLeft = _timerDurationSeconds;
      }
    });
    if (_timerEnabled) _startClock();
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _onClockTick(),
    );
  }

  void _onClockTick() {
    final state = ref.read(gameProvider);
    if (state.status.isOver) {
      _clockTimer?.cancel();
      return;
    }
    setState(() {
      if (state.currentPlayer == PlayerColor.white) {
        if (_whiteTimeLeft > 0) _whiteTimeLeft--;
        if (_whiteTimeLeft == 30) HapticFeedback.vibrate();
        if (_whiteTimeLeft == 0) {
          _clockTimer?.cancel();
          ref.read(gameProvider.notifier).forfeit(PlayerColor.white);
        }
      } else {
        if (_blackTimeLeft > 0) _blackTimeLeft--;
        if (_blackTimeLeft == 30) HapticFeedback.vibrate();
        if (_blackTimeLeft == 0) {
          _clockTimer?.cancel();
          ref.read(gameProvider.notifier).forfeit(PlayerColor.black);
        }
      }
    });
  }

  Future<void> _triggerAiMove() async {
    setState(() => _aiMoveInFlight = true);
    final aiMove = await ref
        .read(gameProvider.notifier)
        .requestAiMove(_difficultyLevel);
    if (mounted) {
      setState(() {
        _aiMoveInFlight = false;
        if (aiMove != null) {
          _lastAiMove = aiMove;
          _lastMove = aiMove;
          _halfMoveCount++;
          _applyIncrement(PlayerColor.black);
        }
      });
    }
  }

  /// Ajoute [_incrementSeconds] au compteur du joueur [player] s'il y a
  /// une minuterie active et un incrément configuré.
  void _applyIncrement(PlayerColor player) {
    if (!_timerEnabled || _incrementSeconds == 0) return;
    if (player == PlayerColor.white) {
      _whiteTimeLeft += _incrementSeconds;
    } else {
      _blackTimeLeft += _incrementSeconds;
    }
  }

  Future<void> _pickDifficulty() async {
    final options = await showModalBottomSheet<_GameOptions>(
      context: context,
      builder: (_) => _GameOptionsSheet(
        initialLevel: _difficultyLevel,
        initialShowMoveHints: _showMoveHints,
        initialShowLastAiMove: _showLastAiMove,
      ),
    );
    if (options != null && mounted) {
      setState(() {
        _difficultyLevel = options.difficultyLevel;
        _showMoveHints = options.showMoveHints;
        _showLastAiMove = options.showLastAiMove;
      });
    }
  }

  Future<void> _showDrawClaimDialog(
    GameState state,
    List<DrawClaimReason> reasons,
  ) async {
    if (!mounted || state.status.isOver) return;
    final l10n = context.l10n;
    final message = reasons.contains(DrawClaimReason.moveRepetition)
        ? l10n.gameDrawClaimRepetitionMessage
        : l10n.gameDrawClaimNoCaptureMessage(
            ref.read(gameProvider).noCaptureMoveCount,
          );

    final accepted = await context.showConfirmDialog(
      title: l10n.gameDrawClaimTitle,
      content: message,
      confirmLabel: l10n.gameDrawClaimAccept,
      cancelLabel: l10n.gameDrawClaimDecline,
    );

    if (!mounted) return;
    if (accepted == true) ref.read(gameProvider.notifier).claimDraw();
  }

  /// Maps difficulty level (1–10) to an opponent type string for the RPC.
  String _opponentType() {
    if (_difficultyLevel <= 3) return "ai_easy";
    if (_difficultyLevel <= 6) return "ai_medium";
    return "ai_hard";
  }

  Future<void> _showGameOverSheet(GameStatus status) async {
    if (!mounted) return;
    _gameStopwatch.stop();
    final gameState = ref.read(gameProvider);

    // Record result for authenticated users in solo mode only.
    if (!_isLocalMultiplayer) {
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        final resultStr = switch (status) {
          GameStatus.whiteWins => "win",
          GameStatus.blackWins => "loss",
          _ => "draw",
        };
        await ref
            .read(recordGameResultUseCaseProvider)
            .call(
              playerId: authState.profile.id,
              opponentType: _opponentType(),
              result: resultStr,
              boardSize: gameState.board.size,
              moveCount: gameState.moveHistory.length,
              durationSeconds: _gameStopwatch.elapsed.inSeconds,
            );
      }
    }

    if (!mounted) return;
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      builder: (_) => _GameOverSheet(
        status: status,
        whiteCaptured: gameState.whiteCapturedCount,
        blackCaptured: gameState.blackCapturedCount,
      ),
    );
    if (!mounted) return;
    if (result == true) {
      _restart();
    } else {
      context.popScreen();
    }
  }
}

// ─── Move notation bar ───────────────────────────────────────────────────────

/// Displays algebraic notation of the last played move (e.g. "2. c3 — d4").
/// Collapses to nothing when [lastMove] is null.
class _MoveNotationBar extends StatelessWidget {
  const _MoveNotationBar({
    required this.lastMove,
    required this.halfMoveCount,
    required this.boardSize,
  });

  final Move? lastMove;
  final int halfMoveCount;
  final int boardSize;

  String _notation() {
    if (lastMove == null) return "";
    final move = lastMove!;
    final num = ((halfMoveCount - 1) ~/ 2) + 1;
    final fromFile = String.fromCharCode(97 + move.from.col);
    final fromRank = "${boardSize - move.from.row}";
    final toFile = String.fromCharCode(97 + move.to.col);
    final toRank = "${boardSize - move.to.row}";
    return "$num. $fromFile$fromRank — $toFile$toRank";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: lastMove == null ? 0.0 : 1.0,
      duration: AppSpacing.durationFast,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          _notation(),
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.paleMint54,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ─── Bot player card ────────────────────────────────────────────────────────

/// Carte du bot (camp noir) : avatar coloré avec initiale, badge de niveau,
/// nom, et indicateur de réflexion intégré (remplace le spinner flottant).
class _BotPlayerCard extends StatelessWidget {
  const _BotPlayerCard({
    required this.botName,
    required this.botColor,
    required this.difficultyLevel,
    required this.piecesCapturedLabel,
    required this.thinkingLabel,
    required this.isActiveTurn,
    required this.isThinking,
  });

  final String botName;
  final Color botColor;
  final int difficultyLevel;
  final String piecesCapturedLabel;
  final String thinkingLabel;
  final bool isActiveTurn;
  final bool isThinking;

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
          _BotAvatar(name: botName, color: botColor, level: difficultyLevel),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  botName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.paleMint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                // Both subtitles always mounted for stable card height.
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AnimatedOpacity(
                      opacity: isThinking ? 0.0 : 1.0,
                      duration: AppSpacing.durationFast,
                      child: Text(
                        piecesCapturedLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.paleMint54,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isThinking ? 1.0 : 0.0,
                      duration: AppSpacing.durationFast,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                          AppSpacing.gapHSm,
                          Text(
                            thinkingLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.paleMint54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isActiveTurn && !isThinking)
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

// ─── Bot avatar ─────────────────────────────────────────────────────────────

/// Cercle coloré avec la première lettre du bot et un badge de niveau.
class _BotAvatar extends StatelessWidget {
  const _BotAvatar({
    required this.name,
    required this.color,
    required this.level,
  });

  final String name;
  final Color color;
  final int level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppSpacing.avatarSm,
          height: AppSpacing.avatarSm,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(80),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              name.substring(0, 1),
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -4,
          right: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.neutral800,
              borderRadius: AppSpacing.roundedSm,
              border: Border.all(color: color.withAlpha(128)),
            ),
            child: Text(
              "$level",
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.paleMint,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Local 2P player card ────────────────────────────────────────────────────

/// Carte joueur pour le mode 2 joueurs locaux — affiche le camp, le nom,
/// les pièces capturées et, si activé, le temps restant en MM:SS.
class _Local2PPlayerCard extends StatelessWidget {
  const _Local2PPlayerCard({
    required this.color,
    required this.playerName,
    required this.piecesCapturedLabel,
    required this.isActiveTurn,
    required this.timerEnabled,
    required this.timeLeftSeconds,
  });

  final PlayerColor color;
  final String playerName;
  final String piecesCapturedLabel;
  final bool isActiveTurn;
  final bool timerEnabled;
  final int timeLeftSeconds;

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pieceColor = color == PlayerColor.white
        ? AppColors.pionBlanc
        : AppColors.pionNoir;
    final isLow = timerEnabled && timeLeftSeconds <= 10;
    final timerColor = isLow ? const Color(0xFFEF4444) : AppColors.paleMint;

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
          // Filled circle — visual stand-in for the piece color.
          Container(
            width: AppSpacing.avatarSm,
            height: AppSpacing.avatarSm,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pieceColor.withAlpha(40),
              border: Border.all(color: pieceColor),
            ),
            child: Center(
              child: Container(
                width: AppSpacing.avatarSm * 0.5,
                height: AppSpacing.avatarSm * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pieceColor,
                ),
              ),
            ),
          ),
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
                const SizedBox(height: 2),
                Text(
                  piecesCapturedLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.paleMint54,
                  ),
                ),
              ],
            ),
          ),
          if (timerEnabled)
            Text(
              _formatTime(timeLeftSeconds),
              style: theme.textTheme.titleSmall?.copyWith(
                color: timerColor,
                fontWeight: FontWeight.w700,
              ),
            )
          else if (isActiveTurn)
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

// ─── Game action button ─────────────────────────────────────────────────────

/// Bouton de la barre d'actions inférieure — icône centrée + libellé court.
class _GameAction extends StatelessWidget {
  const _GameAction({required this.icon, required this.label, this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;
    final color = isDisabled
        ? theme.colorScheme.onSurface.withAlpha(97)
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onPressed,
      borderRadius: AppSpacing.roundedMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Game options ────────────────────────────────────────────────────────────

/// Valeurs retournées par [_GameOptionsSheet].
class _GameOptions {
  const _GameOptions({
    required this.difficultyLevel,
    required this.showMoveHints,
    required this.showLastAiMove,
  });

  final int difficultyLevel;
  final bool showMoveHints;
  final bool showLastAiMove;
}

/// Feuille modale d'options de partie — niveau IA et toggles visuels.
class _GameOptionsSheet extends StatefulWidget {
  const _GameOptionsSheet({
    required this.initialLevel,
    required this.initialShowMoveHints,
    required this.initialShowLastAiMove,
  });

  final int initialLevel;
  final bool initialShowMoveHints;
  final bool initialShowLastAiMove;

  @override
  State<_GameOptionsSheet> createState() => _GameOptionsSheetState();
}

class _GameOptionsSheetState extends State<_GameOptionsSheet> {
  late int _level;
  late bool _showMoveHints;
  late bool _showLastAiMove;

  @override
  void initState() {
    super.initState();
    _level = widget.initialLevel;
    _showMoveHints = widget.initialShowMoveHints;
    _showLastAiMove = widget.initialShowLastAiMove;
  }

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
    final color = _levelColor(_level);
    final levelLabel = _level <= 3
        ? l10n.gameDifficultyEasy
        : _level <= 7
        ? l10n.gameDifficultyMedium
        : l10n.gameDifficultyHard;

    return Padding(
      padding: AppSpacing.bottomSheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.gameDifficultyTitle,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.gapVLg,
          // ── Difficulté IA ────────────────────────────────────────────────
          Container(
            padding: AppSpacing.insetLg,
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      levelLabel,
                      style: tt.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.withAlpha(31),
                        borderRadius: AppSpacing.roundedSm,
                      ),
                      child: Text(
                        "$_level / 10",
                        style: tt.labelMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: color,
                    thumbColor: color,
                    overlayColor: color.withAlpha(31),
                    inactiveTrackColor: cs.outlineVariant,
                  ),
                  child: Slider(
                    value: _level.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => setState(() => _level = v.round()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.gameDifficultyEasy,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    Text(
                      l10n.gameDifficultyHard,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapVLg,
          // ── Affichage ────────────────────────────────────────────────────
          Text(
            l10n.gameOptionsVisualSection,
            style: tt.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapVSm,
          DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: [
                _ToggleRow(
                  label: l10n.gameOptionsMoveHints,
                  value: _showMoveHints,
                  onChanged: (v) => setState(() => _showMoveHints = v),
                ),
                Divider(height: 1, color: cs.outlineVariant),
                _ToggleRow(
                  label: l10n.gameOptionsLastAiMove,
                  value: _showLastAiMove,
                  onChanged: (v) => setState(() => _showLastAiMove = v),
                ),
              ],
            ),
          ),
          AppSpacing.gapVLg,
          AppElevatedButton(
            text: l10n.gameDifficultyApply,
            onPressed: () => Navigator.pop(
              context,
              _GameOptions(
                difficultyLevel: _level,
                showMoveHints: _showMoveHints,
                showLastAiMove: _showLastAiMove,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ligne toggle — libellé à gauche, Switch à droite.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: tt.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ─── Game-over sheet ─────────────────────────────────────────────────────────

/// Feuille modale de fin de partie — style jeu avec animation d'icône,
/// bandeau coloré selon le résultat, stats de captures et boutons d'action.
class _GameOverSheet extends StatefulWidget {
  const _GameOverSheet({
    required this.status,
    required this.whiteCaptured,
    required this.blackCaptured,
  });

  final GameStatus status;
  final int whiteCaptured;
  final int blackCaptured;

  @override
  State<_GameOverSheet> createState() => _GameOverSheetState();
}

class _GameOverSheetState extends State<_GameOverSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _iconScale;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _iconScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
    );
    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;

    final IconData icon;
    final List<Color> gradient;
    final String title;
    final String message;
    switch (widget.status) {
      case GameStatus.whiteWins:
        icon = AppIcons.trophy;
        gradient = const [Color(0xFFD97706), Color(0xFFF59E0B)];
        title = l10n.gameOverWhiteWinsTitle;
        message = l10n.gameOverWhiteWinsMessage;
      case GameStatus.blackWins:
        icon = AppIcons.trophy;
        gradient = const [Color(0xFF4338CA), Color(0xFF7C3AED)];
        title = l10n.gameOverBlackWinsTitle;
        message = l10n.gameOverBlackWinsMessage;
      case GameStatus.draw:
        icon = AppIcons.equal;
        gradient = [AppColors.primary, const Color(0xFF065F46)];
        title = l10n.gameOverDrawTitle;
        message = l10n.gameOverDrawMessage;
      case GameStatus.playing:
        icon = AppIcons.close;
        gradient = const [];
        title = l10n.gameTitle;
        message = "";
    }

    return SafeArea(
      minimum: const EdgeInsets.all(AppSpacing.md),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.neutral800,
          borderRadius: AppSpacing.roundedXxl,
        ),
        child: ClipRRect(
          borderRadius: AppSpacing.roundedXxl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Bandeau coloré + icône animée ──────────────────────────
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Center(
                  child: ScaleTransition(
                    scale: _iconScale,
                    child: Icon(icon, size: 72, color: Colors.white),
                  ),
                ),
              ),
              // ── Titre + message + stats + actions ──────────────────────
              FadeTransition(
                opacity: _contentFade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xl,
                    AppSpacing.xl,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.paleMint,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.gapVXs,
                      Text(
                        message,
                        style: tt.bodyMedium?.copyWith(
                          color: AppColors.paleMint54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.gapVLg,
                      // ── Stats captures ──────────────────────────────────
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          Expanded(
                            child: _GameOverStatTile(
                              pieceColor: AppColors.pionBlanc,
                              playerName: l10n.gamePlayerWhite,
                              captured: widget.whiteCaptured,
                              capturedLabel: l10n.gamePiecesCaptured(
                                widget.whiteCaptured,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _GameOverStatTile(
                              pieceColor: AppColors.pionNoir,
                              playerName: l10n.gamePlayerBlack,
                              captured: widget.blackCaptured,
                              capturedLabel: l10n.gamePiecesCaptured(
                                widget.blackCaptured,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapVLg,
                      // ── Actions ─────────────────────────────────────────
                      AppElevatedButton(
                        text: l10n.gameNewGameCta,
                        onPressed: () => Navigator.pop(context, true),
                      ),
                      AppSpacing.gapVSm,
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          l10n.gameQuitCta,
                          style: tt.labelLarge?.copyWith(
                            color: AppColors.paleMint54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tuile de stat — cercle couleur du camp, nombre de captures, libellé.
class _GameOverStatTile extends StatelessWidget {
  const _GameOverStatTile({
    required this.pieceColor,
    required this.playerName,
    required this.captured,
    required this.capturedLabel,
  });

  final Color pieceColor;
  final String playerName;
  final int captured;
  final String capturedLabel;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: pieceColor.withAlpha(60)),
      ),
      child: Padding(
        padding: AppSpacing.insetMd,
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pieceColor.withAlpha(40),
                border: Border.all(color: pieceColor),
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pieceColor,
                  ),
                ),
              ),
            ),
            AppSpacing.gapVXs,
            Text(
              playerName,
              style: tt.labelSmall?.copyWith(color: AppColors.paleMint54),
            ),
            Text(
              "$captured",
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.paleMint,
              ),
            ),
            Text(
              capturedLabel,
              style: tt.labelSmall?.copyWith(
                color: AppColors.paleMint54,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
