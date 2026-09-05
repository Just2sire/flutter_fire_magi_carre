import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTopbar;
import "../../../game/presentation/widgets/index.dart" show ClassicGameBoard;
import "../../domain/entities/online_match.dart";
import "../providers/online_match_providers.dart";

/// Écran de partie en ligne — synchronisé avec Supabase via
/// [onlineMatchProvider], réutilise le plateau du mode local.
class OnlineGamePage extends ConsumerStatefulWidget {
  const OnlineGamePage({required this.matchId, super.key});

  final String matchId;

  @override
  ConsumerState<OnlineGamePage> createState() => _OnlineGamePageState();
}

class _OnlineGamePageState extends ConsumerState<OnlineGamePage> {
  Position? _selectedPosition;
  bool _gameOverShown = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final asyncState = ref.watch(onlineMatchProvider(widget.matchId));

    ref.listen(onlineMatchProvider(widget.matchId), (previous, next) {
      final match = next.value?.match;
      if (match != null &&
          match.status == MatchStatus.finished &&
          !_gameOverShown) {
        _gameOverShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showGameOverSheet(match);
        });
      }
    });

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(title: l10n.gameTitle),
          Expanded(
            child: asyncState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => _ErrorView(
                onRetry: () =>
                    ref.invalidate(onlineMatchProvider(widget.matchId)),
              ),
              data: (state) => _buildGame(context, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGame(BuildContext context, OnlineMatchState onlineState) {
    final l10n = context.l10n;
    final match = onlineState.match;
    final gameState = match.gameState;
    final notifier = ref.read(onlineMatchProvider(widget.matchId).notifier);

    if (gameState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final legalMoves = _selectedPosition != null
        ? notifier.validMovesFor(_selectedPosition!)
        : const <Move>[];

    final promotionSlots = switch (gameState.pendingPromotion) {
      null => const <Position>[],
      final p when p.promotingPlayer == onlineState.myColor => p.availableSlots,
      _ => const <Position>[],
    };

    final shouldFlip = onlineState.myColor == PlayerColor.black;

    return Column(
      children: [
        AppSpacing.gapVMd,
        _PlayerBanner(
          color: PlayerColor.black,
          label: onlineState.myColor == PlayerColor.black
              ? l10n.gamePlayerBlack
              : l10n.onlineGameOpponent,
          isActiveTurn:
              gameState.currentPlayer == PlayerColor.black &&
              !gameState.status.isOver,
          timeLeftMs: onlineState.blackTimeLeftMs,
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
            onCellTap: (pos) => _onCellTap(pos, onlineState),
            showLabels: !shouldFlip,
          ),
        ),
        AppSpacing.gapVSm,
        _PlayerBanner(
          color: PlayerColor.white,
          label: onlineState.myColor == PlayerColor.white
              ? l10n.gamePlayerWhite
              : l10n.onlineGameOpponent,
          isActiveTurn:
              gameState.currentPlayer == PlayerColor.white &&
              !gameState.status.isOver,
          timeLeftMs: onlineState.whiteTimeLeftMs,
        ),
        const Spacer(),
        if (!gameState.status.isOver)
          TextButton(
            onPressed: () => _confirmResign(notifier),
            child: Text(
              l10n.onlineGameResignCta,
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        AppSpacing.gapVMd,
      ],
    );
  }

  void _onCellTap(Position pos, OnlineMatchState onlineState) {
    final notifier = ref.read(onlineMatchProvider(widget.matchId).notifier);
    final gameState = onlineState.match.gameState;
    if (gameState == null) return;
    final pendingPromotion = gameState.pendingPromotion;

    if (pendingPromotion != null) {
      if (pendingPromotion.promotingPlayer == onlineState.myColor &&
          pendingPromotion.availableSlots.contains(pos)) {
        notifier.resolvePromotion(pos);
      }
      return;
    }

    if (gameState.status.isOver || !onlineState.isMyTurn) return;

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

    final piece = gameState.board.pieceAt(pos);
    if (piece != null && piece.color == onlineState.myColor) {
      setState(() {
        _selectedPosition = _selectedPosition == pos ? null : pos;
      });
    } else {
      setState(() => _selectedPosition = null);
    }
  }

  Future<void> _confirmResign(OnlineMatchNotifier notifier) async {
    final l10n = context.l10n;
    final accepted = await context.showConfirmDialog(
      title: l10n.onlineGameResignConfirmTitle,
      content: l10n.onlineGameResignConfirmMessage,
      confirmLabel: l10n.onlineGameResignCta,
      cancelLabel: l10n.commonCancel,
      destructive: true,
    );
    if (accepted == true) await notifier.resign();
  }

  Future<void> _showGameOverSheet(OnlineMatch match) async {
    if (!mounted) return;
    final result = await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      builder: (_) => _OnlineGameOverSheet(result: match.result),
    );
    if (!mounted) return;
    context.goLobby();
    // Suppress unused-value lint for the (always-null) sheet result.
    return result;
  }
}

// ─── Player banner ──────────────────────────────────────────────────────

class _PlayerBanner extends StatelessWidget {
  const _PlayerBanner({
    required this.color,
    required this.label,
    required this.isActiveTurn,
    required this.timeLeftMs,
  });

  final PlayerColor color;
  final String label;
  final bool isActiveTurn;
  final int? timeLeftMs;

  String _formatTime(int ms) {
    final totalSeconds = ms ~/ 1000;
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
    final isLow = timeLeftMs != null && timeLeftMs! <= 10000;

    return Padding(
      padding: AppSpacing.screenPaddingH,
      child: AnimatedContainer(
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
            Container(
              width: AppSpacing.avatarSm,
              height: AppSpacing.avatarSm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pieceColor.withAlpha(40),
                border: Border.all(color: pieceColor),
              ),
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.paleMint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (timeLeftMs != null)
              Text(
                _formatTime(timeLeftMs!),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isLow
                      ? const Color(0xFFEF4444)
                      : AppColors.paleMint,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Error view ─────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.alertCircle, size: 40, color: cs.error),
          AppSpacing.gapVMd,
          Text(l10n.commonError, style: context.textTheme.bodyMedium),
          AppSpacing.gapVMd,
          TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}

// ─── Game-over sheet ────────────────────────────────────────────────────

class _OnlineGameOverSheet extends StatelessWidget {
  const _OnlineGameOverSheet({required this.result});

  final MatchResult? result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;

    final (icon, gradient, title, message) = switch (result) {
      MatchResult.whiteWins => (
        AppIcons.trophy,
        const [Color(0xFFD97706), Color(0xFFF59E0B)],
        l10n.gameOverWhiteWinsTitle,
        l10n.gameOverWhiteWinsMessage,
      ),
      MatchResult.blackWins => (
        AppIcons.trophy,
        const [Color(0xFF4338CA), Color(0xFF7C3AED)],
        l10n.gameOverBlackWinsTitle,
        l10n.gameOverBlackWinsMessage,
      ),
      _ => (
        AppIcons.equal,
        [AppColors.primary, const Color(0xFF065F46)],
        l10n.gameOverDrawTitle,
        l10n.gameOverDrawMessage,
      ),
    };

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
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Center(
                  child: Icon(icon, size: 64, color: Colors.white),
                ),
              ),
              Padding(
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
                    AppElevatedButton(
                      text: l10n.onlineGameBackToLobbyCta,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
