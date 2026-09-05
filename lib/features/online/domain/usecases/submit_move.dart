import "package:carre_magic_logic/carre_magic_logic.dart";

import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Soumet un coup joué localement — vérifié côté serveur (ordre des tours,
/// temps restant) dans la RPC `submit_move`.
class SubmitMove {
  const SubmitMove(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, void>> call({
    required String matchId,
    required GameState newGameState,
    required PlayerColor nextPlayer,
    required GameStatus newStatus,
  }) {
    return _repository.submitMove(
      matchId: matchId,
      newGameState: newGameState,
      nextPlayer: nextPlayer,
      newStatus: newStatus,
    );
  }
}
