import "dart:typed_data";

import "../../../../shared/data/services/http_service/either.dart";
import "../../../../shared/domain/failures/failure.dart";
import "../entities/user_profile.dart";
import "../repositories/auth_repository.dart";

/// Upload une nouvelle image d'avatar et met à jour le profil via
/// [AuthRepository].
class UploadAvatarUseCase {
  const UploadAvatarUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, UserProfile>> call(
    Uint8List bytes,
    String fileExtension,
  ) => _repository.uploadAvatar(bytes, fileExtension);
}
