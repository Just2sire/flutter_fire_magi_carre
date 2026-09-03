import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "game_providers.g.dart";

/// État d'une partie en cours, câblé sur le moteur pur `carre_magic_logic`.
///
/// Portée par partie (pas `keepAlive`) : quand l'écran de jeu qui l'observe
/// est démonté, la partie en cours est abandonnée — pas de persistance ici,
/// c'est un choix pour une future couche data (local ou Supabase Realtime
/// pour le multijoueur), hors périmètre de ce câblage.
@riverpod
class GameNotifier extends _$GameNotifier {
  /// Pile des états précédant chaque coup joué (humain ou IA), pour
  /// [undo]. Volontairement hors de `state` : ce n'est pas une donnée de
  /// partie, juste un historique d'interaction UI.
  final List<GameState> _history = [];

  @override
  GameState build() => InitializeGame.call();

  /// Démarre une nouvelle partie standard (taille/règles au choix).
  void newGame({
    BoardConfig config = BoardConfig.standard5x5,
    GameRules rules = GameRules.standard,
  }) {
    _history.clear();
    state = InitializeGame.call(config: config, rules: rules);
  }

  /// Démarre une partie à partir d'un niveau/puzzle prédéfini.
  void newGameFromLevel(GameLevel level) {
    _history.clear();
    state = InitializeGame.fromLevel(level);
  }

  /// Coups légaux pour le pion à [pos], selon l'état courant.
  List<Move> validMovesFor(Position pos) => GetValidMoves.forState(state, pos);

  /// Joue [move] — doit provenir de [validMovesFor] ou [GetValidMoves].
  void playMove(Move move) {
    _history.add(state);
    state = ApplyMove.call(state, move);
  }

  /// Résout une promotion en attente en choisissant [slot]. Retourne `false`
  /// sans modifier l'état si le slot est invalide ou qu'aucune promotion
  /// n'est en attente.
  bool resolvePromotion(Position slot) {
    final previousState = state;
    final result = ApplyPromotion.call(state, slot);
    if (result is Ok<GameState>) {
      _history.add(previousState);
      state = result.value;
      return true;
    }
    return false;
  }

  /// `true` s'il existe un état antérieur vers lequel revenir.
  bool get canUndo => _history.isNotEmpty;

  /// Annule le dernier coup humain — et la réponse de l'IA qui l'a suivi,
  /// le cas échéant, pour retomber directement sur un état où les blancs
  /// peuvent rejouer. Un unique ply reste dans l'historique par coup joué
  /// (humain ou IA), donc annuler "un tour humain" veut dire dépiler
  /// jusqu'à retrouver un état où c'est aux blancs de jouer.
  void undo() {
    if (_history.isEmpty) return;
    var target = _history.removeLast();
    while (_history.isNotEmpty &&
        target.currentPlayer == PlayerColor.black &&
        target.pendingPromotion == null) {
      target = _history.removeLast();
    }
    state = target;
  }

  /// Abandonne la partie — [loser] perd, l'adversaire gagne.
  /// Utilisé pour la perte sur le temps en mode 2 joueurs avec minuterie.
  void forfeit(PlayerColor loser) {
    final status = loser == PlayerColor.white
        ? GameStatus.blackWins
        : GameStatus.whiteWins;
    state = state.copyWith(status: status);
  }

  /// Réclame le nul si [GameState.drawClaimAvailable] est vrai.
  /// No-op si aucune condition de nul n'est active.
  void claimDraw() {
    final result = ClaimDraw.call(state);
    if (result is Ok<GameState>) state = result.value;
  }

  /// Calcule et joue le coup de l'IA pour le joueur courant. No-op si la
  /// partie est terminée ou qu'une promotion est en attente.
  ///
  /// Si le coup de l'IA déclenche elle-même une promotion, elle est
  /// auto-résolue (pas de choix humain pour l'IA) via
  /// [MinimaxEngine.resolvePendingPromotion].
  /// [level] : force de l'IA sur une échelle 1 (débutant) à 10 (maître),
  /// interpolée via [AiConfigStrength.fromStrength].
  Future<Move?> requestAiMove(int level) async {
    if (state.status.isOver || state.pendingPromotion != null) return null;
    final config = AiConfigStrength.fromStrength(level);
    final move = await ComputeAiMove.callWithConfig(state, config);
    if (move != null) playMove(move);
    if (state.pendingPromotion != null) {
      state = MinimaxEngine.resolvePendingPromotion(state);
    }
    return move;
  }
}
