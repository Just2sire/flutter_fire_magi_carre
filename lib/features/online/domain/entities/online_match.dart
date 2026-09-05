import "package:carre_magic_logic/carre_magic_logic.dart";

/// Statut d'une partie en ligne.
enum MatchStatus { waiting, active, finished }

/// Issue d'une partie en ligne terminée.
enum MatchResult { whiteWins, blackWins, draw }

/// Raison de fin de partie.
enum MatchEndReason { normal, resignation, timeout }

/// Une partie en ligne — miroir de la table Supabase `matches`.
class OnlineMatch {
  const OnlineMatch({
    required this.id,
    required this.status,
    required this.rated,
    required this.creatorId,
    required this.timerBaseSeconds,
    required this.timerIncrementSeconds,
    required this.whiteRecorded,
    required this.blackRecorded,
    this.inviteCode,
    this.whitePlayerId,
    this.blackPlayerId,
    this.gameState,
    this.currentPlayer,
    this.whiteTimeRemainingMs,
    this.blackTimeRemainingMs,
    this.turnStartedAt,
    this.result,
    this.endReason,
  });

  final String id;
  final MatchStatus status;

  /// Présent seulement pour les parties créées par invitation.
  final String? inviteCode;

  final bool rated;
  final String creatorId;

  /// Nulls tant que la partie n'est pas activée (couleurs tirées au sort à
  /// l'activation, quand le 2e joueur rejoint).
  final String? whitePlayerId;
  final String? blackPlayerId;

  /// État de partie décodé via le codec du moteur — null tant que la partie
  /// n'a pas démarré.
  final GameState? gameState;
  final PlayerColor? currentPlayer;

  final int timerBaseSeconds;
  final int timerIncrementSeconds;

  /// Null quand [timerBaseSeconds] est 0 (partie sans pendule).
  final int? whiteTimeRemainingMs;
  final int? blackTimeRemainingMs;
  final DateTime? turnStartedAt;

  final MatchResult? result;
  final MatchEndReason? endReason;

  /// `true` une fois que le joueur correspondant a appelé
  /// `record_game_result` pour lui-même (garde d'idempotence).
  final bool whiteRecorded;
  final bool blackRecorded;

  /// Couleur de [userId] dans cette partie, ou null s'il n'y est pas
  /// (encore) participant.
  PlayerColor? colorFor(String userId) {
    if (userId == whitePlayerId) return PlayerColor.white;
    if (userId == blackPlayerId) return PlayerColor.black;
    return null;
  }

  /// Id de l'adversaire de [userId] dans cette partie, ou null.
  String? opponentIdFor(String userId) {
    if (userId == whitePlayerId) return blackPlayerId;
    if (userId == blackPlayerId) return whitePlayerId;
    return null;
  }
}
