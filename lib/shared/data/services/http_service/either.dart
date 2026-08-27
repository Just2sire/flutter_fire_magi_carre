/// Résultat d'une opération pouvant échouer.
///
/// - [Left]  = échec — contient un [L] (sous-classe de Failure).
/// - [Right] = succès — contient un [R] (entité domaine ou valeur de retour).
///
/// Utilisation :
/// ```dart
/// final Either<Failure, User> result = await repo.signIn(...);
/// result.fold(
///   (failure) => showError(failure.message),
///   (user)    => navigateToHome(user),
/// );
/// ```
sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L? get leftOrNull => this is Left<L, R> ? (this as Left<L, R>).value : null;
  R? get rightOrNull =>
      this is Right<L, R> ? (this as Right<L, R>).value : null;
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onLeft(value);

  @override
  String toString() => "Left($value)";
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onRight(value);

  @override
  String toString() => "Right($value)";
}
