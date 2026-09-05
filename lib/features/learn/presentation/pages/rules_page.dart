import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/index.dart" show BuildContextExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;
import "../../../game/presentation/providers/board_theme_provider.dart";
import "../../../game/presentation/widgets/game_board_classic.dart";

/// Page de règles du jeu — cinq sections en PageView horizontal, chacune
/// accompagnée d'un plateau illustratif en lecture seule.
class RulesPage extends ConsumerStatefulWidget {
  const RulesPage({super.key});

  @override
  ConsumerState<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends ConsumerState<RulesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final boardTheme = ref.watch(boardThemeProvider);
    final l10n = context.l10n;

    final sections = [
      // 1 — But du jeu
      _SectionData(
        index: 1,
        title: l10n.learnGoalTitle,
        body: l10n.learnGoalBody,
        board: Board.initial(BoardConfig.standard5x5),
        boardTheme: boardTheme,
      ),

      // 2 — Déplacement : blanc au centre (intersection paire → 8 directions).
      _SectionData(
        index: 2,
        title: l10n.learnMoveTitle,
        body: l10n.learnMoveBody,
        board: Board.fromPlacement(BoardConfig.standard5x5, {
          const Position(row: 2, col: 2): const Piece(
            color: PlayerColor.white,
          ),
        }),
        selectedPosition: const Position(row: 2, col: 2),
        legalMoves: const [
          Move(from: Position(row: 2, col: 2), to: Position(row: 1, col: 1)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 1, col: 2)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 1, col: 3)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 2, col: 1)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 2, col: 3)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 3, col: 1)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 3, col: 2)),
          Move(from: Position(row: 2, col: 2), to: Position(row: 3, col: 3)),
        ],
        boardTheme: boardTheme,
      ),

      // 3 — Capture : blanc saute par-dessus noir.
      _SectionData(
        index: 3,
        title: l10n.learnCaptureTitle,
        body: l10n.learnCaptureBody,
        board: Board.fromPlacement(BoardConfig.standard5x5, {
          const Position(row: 4, col: 2): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 3, col: 2): const Piece(
            color: PlayerColor.black,
          ),
        }),
        selectedPosition: const Position(row: 4, col: 2),
        legalMoves: const [
          Move(
            from: Position(row: 4, col: 2),
            to: Position(row: 2, col: 2),
            capturedAt: Position(row: 3, col: 2),
          ),
        ],
        boardTheme: boardTheme,
      ),

      // 4 — Promotion : blanc en (1,2) peut atteindre la rangée 0 et déclenche
      //     la promotion ; les cases dorées (4,1),(4,2),(4,3) sont les slots
      //     disponibles sur sa propre rangée de départ.
      _SectionData(
        index: 4,
        title: l10n.learnChainTitle,
        body: l10n.learnChainBody,
        board: Board.fromPlacement(BoardConfig.standard5x5, {
          const Position(row: 0, col: 0): const Piece(
            color: PlayerColor.black,
          ),
          const Position(row: 1, col: 2): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 4, col: 0): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 4, col: 4): const Piece(
            color: PlayerColor.white,
          ),
        }),
        selectedPosition: const Position(row: 1, col: 2),
        legalMoves: const [
          Move(
            from: Position(row: 1, col: 2),
            to: Position(row: 0, col: 2),
            triggersPromotion: true,
          ),
        ],
        promotionSlots: const [
          Position(row: 4, col: 1),
          Position(row: 4, col: 2),
          Position(row: 4, col: 3),
        ],
        boardTheme: boardTheme,
      ),

      // 5 — Victoire : seules les pièces blanches sont présentes, aucun coup
      //     noir possible — illustration d'une fin de partie.
      _SectionData(
        index: 5,
        title: l10n.learnPromotionTitle,
        body: l10n.learnPromotionBody,
        board: Board.fromPlacement(BoardConfig.standard5x5, {
          const Position(row: 2, col: 1): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 2, col: 3): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 3, col: 2): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 4, col: 1): const Piece(
            color: PlayerColor.white,
          ),
          const Position(row: 4, col: 3): const Piece(
            color: PlayerColor.white,
          ),
        }),
        boardTheme: boardTheme,
      ),
    ];

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTopbar(title: l10n.learnTitle),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: sections.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, i) => _RuleSection(data: sections[i]),
            ),
          ),
          _PageNav(
            total: sections.length,
            current: _currentPage,
            onPrev: _currentPage > 0
                ? () => _goTo(_currentPage - 1)
                : null,
            onNext: _currentPage < sections.length - 1
                ? () => _goTo(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

// ─── Section data ────────────────────────────────────────────────────────────

class _SectionData {
  const _SectionData({
    required this.index,
    required this.title,
    required this.body,
    required this.board,
    required this.boardTheme,
    this.selectedPosition,
    this.legalMoves = const [],
    this.promotionSlots = const [],
  });

  final int index;
  final String title;
  final String body;
  final Board board;
  final BoardTheme boardTheme;
  final Position? selectedPosition;
  final List<Move> legalMoves;
  final List<Position> promotionSlots;
}

// ─── Section widget ──────────────────────────────────────────────────────────

class _RuleSection extends StatelessWidget {
  const _RuleSection({required this.data});

  final _SectionData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.gapVMd,
          Row(
            children: [
              _IndexBadge(index: data.index),
              AppSpacing.gapHSm,
              Expanded(
                child: Text(
                  data.title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVSm,
          Text(
            data.body,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          AppSpacing.gapVMd,
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClassicGameBoard(
                board: data.board,
                onCellTap: (_) {},
                selectedPosition: data.selectedPosition,
                legalMoves: data.legalMoves,
                promotionSlots: data.promotionSlots,
                boardTheme: data.boardTheme,
              ),
            ),
          ),
          AppSpacing.gapVSm,
        ],
      ),
    );
  }
}

// ─── Page navigation ─────────────────────────────────────────────────────────

class _PageNav extends StatelessWidget {
  const _PageNav({
    required this.total,
    required this.current,
    required this.onPrev,
    required this.onNext,
  });

  final int total;
  final int current;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left_rounded),
            color: onPrev != null
                ? AppColors.primary
                : AppColors.textSecondary,
            iconSize: AppSpacing.iconXxl,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(total, (i) => _Dot(active: i == current)),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
            color: onNext != null
                ? AppColors.primary
                : AppColors.textSecondary,
            iconSize: AppSpacing.iconXxl,
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: active
            ? AppColors.primary
            : AppColors.textSecondary.withAlpha(80),
      ),
    );
  }
}

// ─── Badge ───────────────────────────────────────────────────────────────────

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xxl,
      height: AppSpacing.xxl,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      alignment: Alignment.center,
      child: Text(
        "$index",
        style: context.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
