import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/auth_repository.dart";

/// Envoi d'un email de réinitialisation du mot de passe via [AuthRepository].
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call(String email) =>
      _repository.resetPassword(email);
}
