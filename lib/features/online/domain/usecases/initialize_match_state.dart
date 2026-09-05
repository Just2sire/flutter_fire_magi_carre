import "package:carre_magic_logic/carre_magic_logic.dart";

import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Initialise l'état de jeu d'une partie tout juste activée. No-op côté
/// serveur si un autre client l'a déjà fait.
class InitializeMatchState {
  const InitializeMatchState(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, void>> call({
    required String matchId,
    required GameState gameState,
  }) {
    return _repository.initializeMatchState(
      matchId: matchId,
      gameState: gameState,
    );
  }
}
