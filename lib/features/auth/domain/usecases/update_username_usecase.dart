import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";
import "../repositories/auth_repository.dart";

/// Met à jour le nom d'utilisateur du profil courant via [AuthRepository].
class UpdateUsernameUseCase {
  const UpdateUsernameUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, UserProfile>> call(String username) =>
      _repository.updateUsername(username);
}
