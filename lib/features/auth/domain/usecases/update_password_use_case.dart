import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/auth_repository.dart";

/// Définit un nouveau mot de passe via [AuthRepository] — utilisé sur la
/// session de récupération temporaire ouverte par le deep link de reset.
class UpdatePasswordUseCase {
  const UpdatePasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call(String newPassword) =>
      _repository.updatePassword(newPassword);
}
