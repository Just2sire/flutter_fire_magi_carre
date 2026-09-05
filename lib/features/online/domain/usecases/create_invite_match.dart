import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/i_online_match_repository.dart";

/// Crée une partie en attente d'invitation, retourne le code à partager.
class CreateInviteMatch {
  const CreateInviteMatch(this._repository);

  final IOnlineMatchRepository _repository;

  Future<Either<Failure, String>> call({
    required int timerBaseSeconds,
    required int timerIncrementSeconds,
    required bool rated,
  }) {
    return _repository.createInviteMatch(
      timerBaseSeconds: timerBaseSeconds,
      timerIncrementSeconds: timerIncrementSeconds,
      rated: rated,
    );
  }
}
