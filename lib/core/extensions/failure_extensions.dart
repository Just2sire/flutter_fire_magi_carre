import "package:flutter/material.dart";

import "../../shared/domain/failures/index.dart";
import "build_context_extensions.dart";

extension FailureLocalization on BuildContext {
  String localizeFailure(Failure failure) {
    final l10n = this.l10n;
    return switch (failure) {
      InvalidCredentialsFailure() => l10n.authErrorInvalidCredentials,
      UserNotFoundFailure() => l10n.authErrorUserNotFound,
      UsernameTakenFailure() => l10n.authErrorUsernameTaken,
      OAuthCancelledFailure() => l10n.authErrorOAuthCancelled,
      GoogleSignInCancelledFailure() => l10n.authErrorGoogleCancelled,
      NetworkFailure() => l10n.errorNetwork,
      ValidationFailure(:final fieldErrors) =>
        fieldErrors?.values.first ?? l10n.errorValidation,
      ServerFailure() => l10n.errorServer,
      _ => l10n.errorUnknown,
    };
  }
}
