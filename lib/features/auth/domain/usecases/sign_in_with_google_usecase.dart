import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../repositories/auth_repository.dart";

/// Lance le flow OAuth Google via Supabase.
///
/// L'opération ouvre le navigateur externe. Le résultat (session créée)
/// arrive ensuite via le stream d'auth state.
class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call() {
    return _repository.signInWithOAuth(AuthProvider.google);
  }
}
