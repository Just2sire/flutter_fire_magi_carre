import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";
import "../repositories/auth_repository.dart";

/// Met à jour la bio du profil courant via [AuthRepository].
class UpdateBioUseCase {
  const UpdateBioUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, UserProfile>> call(String bio) =>
      _repository.updateBio(bio);
}
