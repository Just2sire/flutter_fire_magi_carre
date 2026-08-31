// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Datasource Supabase Auth (GoTrue) + Google Sign-In natif.

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Datasource Supabase Auth (GoTrue) + Google Sign-In natif.

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSourceImpl,
          AuthRemoteDataSourceImpl,
          AuthRemoteDataSourceImpl
        >
    with $Provider<AuthRemoteDataSourceImpl> {
  /// Datasource Supabase Auth (GoTrue) + Google Sign-In natif.
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSourceImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSourceImpl create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSourceImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSourceImpl>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'bbe1f55585a628f973e5db452139976cbb37127c';

/// Cache local de session (SharedPreferences).

@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider = AuthLocalDataSourceProvider._();

/// Cache local de session (SharedPreferences).

final class AuthLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AuthLocalDataSource,
          AuthLocalDataSource,
          AuthLocalDataSource
        >
    with $Provider<AuthLocalDataSource> {
  /// Cache local de session (SharedPreferences).
  AuthLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthLocalDataSource create(Ref ref) {
    return authLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocalDataSource>(value),
    );
  }
}

String _$authLocalDataSourceHash() =>
    r'c88213ab2ab5d453d1881b1ba6037a25c85aad67';

/// Implémentation [AuthRepository] branchée sur Supabase + cache local.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Implémentation [AuthRepository] branchée sur Supabase + cache local.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Implémentation [AuthRepository] branchée sur Supabase + cache local.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'ce731388241ca810f2d21165dbcff2ee5d524f01';

@ProviderFor(signupUseCase)
final signupUseCaseProvider = SignupUseCaseProvider._();

final class SignupUseCaseProvider
    extends $FunctionalProvider<SignupUseCase, SignupUseCase, SignupUseCase>
    with $Provider<SignupUseCase> {
  SignupUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignupUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignupUseCase create(Ref ref) {
    return signupUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupUseCase>(value),
    );
  }
}

String _$signupUseCaseHash() => r'8cef5bc1ca1491025030035fb4274231401b2de3';

@ProviderFor(loginUseCase)
final loginUseCaseProvider = LoginUseCaseProvider._();

final class LoginUseCaseProvider
    extends $FunctionalProvider<LoginUseCase, LoginUseCase, LoginUseCase>
    with $Provider<LoginUseCase> {
  LoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoginUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginUseCase create(Ref ref) {
    return loginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUseCase>(value),
    );
  }
}

String _$loginUseCaseHash() => r'5a95b111ff086652f0c947b88bcfe26ea7ce95be';

@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = LogoutUseCaseProvider._();

final class LogoutUseCaseProvider
    extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase>
    with $Provider<LogoutUseCase> {
  LogoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'c3c6c589cbff5a2f6618cc56b1f9faae632da27a';

@ProviderFor(signInWithGoogleUseCase)
final signInWithGoogleUseCaseProvider = SignInWithGoogleUseCaseProvider._();

final class SignInWithGoogleUseCaseProvider
    extends
        $FunctionalProvider<
          SignInWithGoogleUseCase,
          SignInWithGoogleUseCase,
          SignInWithGoogleUseCase
        >
    with $Provider<SignInWithGoogleUseCase> {
  SignInWithGoogleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInWithGoogleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInWithGoogleUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInWithGoogleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInWithGoogleUseCase create(Ref ref) {
    return signInWithGoogleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInWithGoogleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInWithGoogleUseCase>(value),
    );
  }
}

String _$signInWithGoogleUseCaseHash() =>
    r'e677af0f5be96979b5ffb65257967d4357e7eb4d';

@ProviderFor(signInWithGithubUseCase)
final signInWithGithubUseCaseProvider = SignInWithGithubUseCaseProvider._();

final class SignInWithGithubUseCaseProvider
    extends
        $FunctionalProvider<
          SignInWithGithubUseCase,
          SignInWithGithubUseCase,
          SignInWithGithubUseCase
        >
    with $Provider<SignInWithGithubUseCase> {
  SignInWithGithubUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInWithGithubUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInWithGithubUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInWithGithubUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInWithGithubUseCase create(Ref ref) {
    return signInWithGithubUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInWithGithubUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInWithGithubUseCase>(value),
    );
  }
}

String _$signInWithGithubUseCaseHash() =>
    r'adcd4d9cf24581009fc3999f3046c875e449fd57';

@ProviderFor(completeOAuthSignInUseCase)
final completeOAuthSignInUseCaseProvider =
    CompleteOAuthSignInUseCaseProvider._();

final class CompleteOAuthSignInUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteOAuthSignInUseCase,
          CompleteOAuthSignInUseCase,
          CompleteOAuthSignInUseCase
        >
    with $Provider<CompleteOAuthSignInUseCase> {
  CompleteOAuthSignInUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeOAuthSignInUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeOAuthSignInUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteOAuthSignInUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteOAuthSignInUseCase create(Ref ref) {
    return completeOAuthSignInUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteOAuthSignInUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteOAuthSignInUseCase>(value),
    );
  }
}

String _$completeOAuthSignInUseCaseHash() =>
    r'34ad2b9c40f459d0f8d34f6cddacfeb68f074ad8';

@ProviderFor(completeOnboardingUseCase)
final completeOnboardingUseCaseProvider = CompleteOnboardingUseCaseProvider._();

final class CompleteOnboardingUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteOnboardingUseCase,
          CompleteOnboardingUseCase,
          CompleteOnboardingUseCase
        >
    with $Provider<CompleteOnboardingUseCase> {
  CompleteOnboardingUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeOnboardingUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeOnboardingUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteOnboardingUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteOnboardingUseCase create(Ref ref) {
    return completeOnboardingUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteOnboardingUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteOnboardingUseCase>(value),
    );
  }
}

String _$completeOnboardingUseCaseHash() =>
    r'15a8e9455ad55342e7daad46dd97d6740e22566e';

@ProviderFor(resetPasswordUseCase)
final resetPasswordUseCaseProvider = ResetPasswordUseCaseProvider._();

final class ResetPasswordUseCaseProvider
    extends
        $FunctionalProvider<
          ResetPasswordUseCase,
          ResetPasswordUseCase,
          ResetPasswordUseCase
        >
    with $Provider<ResetPasswordUseCase> {
  ResetPasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResetPasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResetPasswordUseCase create(Ref ref) {
    return resetPasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetPasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetPasswordUseCase>(value),
    );
  }
}

String _$resetPasswordUseCaseHash() =>
    r'954e56b2b94719a458ccec2b3c9101151c1cde49';

@ProviderFor(updatePasswordUseCase)
final updatePasswordUseCaseProvider = UpdatePasswordUseCaseProvider._();

final class UpdatePasswordUseCaseProvider
    extends
        $FunctionalProvider<
          UpdatePasswordUseCase,
          UpdatePasswordUseCase,
          UpdatePasswordUseCase
        >
    with $Provider<UpdatePasswordUseCase> {
  UpdatePasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatePasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatePasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdatePasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdatePasswordUseCase create(Ref ref) {
    return updatePasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdatePasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdatePasswordUseCase>(value),
    );
  }
}

String _$updatePasswordUseCaseHash() =>
    r'f686146f4d5d26bf19d76f7eb8ce974a6fadec44';

@ProviderFor(updateBioUseCase)
final updateBioUseCaseProvider = UpdateBioUseCaseProvider._();

final class UpdateBioUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateBioUseCase,
          UpdateBioUseCase,
          UpdateBioUseCase
        >
    with $Provider<UpdateBioUseCase> {
  UpdateBioUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateBioUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateBioUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateBioUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateBioUseCase create(Ref ref) {
    return updateBioUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateBioUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateBioUseCase>(value),
    );
  }
}

String _$updateBioUseCaseHash() => r'fc7ea49451dbb395d42cd94d32cccd0537f6784c';

@ProviderFor(updateUsernameUseCase)
final updateUsernameUseCaseProvider = UpdateUsernameUseCaseProvider._();

final class UpdateUsernameUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateUsernameUseCase,
          UpdateUsernameUseCase,
          UpdateUsernameUseCase
        >
    with $Provider<UpdateUsernameUseCase> {
  UpdateUsernameUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateUsernameUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateUsernameUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateUsernameUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateUsernameUseCase create(Ref ref) {
    return updateUsernameUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateUsernameUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateUsernameUseCase>(value),
    );
  }
}

String _$updateUsernameUseCaseHash() =>
    r'66e832b1f4236c75039cbbe6c37bb830c730d12d';

@ProviderFor(uploadAvatarUseCase)
final uploadAvatarUseCaseProvider = UploadAvatarUseCaseProvider._();

final class UploadAvatarUseCaseProvider
    extends
        $FunctionalProvider<
          UploadAvatarUseCase,
          UploadAvatarUseCase,
          UploadAvatarUseCase
        >
    with $Provider<UploadAvatarUseCase> {
  UploadAvatarUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadAvatarUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadAvatarUseCaseHash();

  @$internal
  @override
  $ProviderElement<UploadAvatarUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UploadAvatarUseCase create(Ref ref) {
    return uploadAvatarUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadAvatarUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadAvatarUseCase>(value),
    );
  }
}

String _$uploadAvatarUseCaseHash() =>
    r'ce6e027ccbb2078182af0e540b7af1851be617f7';

@ProviderFor(watchAuthStateUseCase)
final watchAuthStateUseCaseProvider = WatchAuthStateUseCaseProvider._();

final class WatchAuthStateUseCaseProvider
    extends
        $FunctionalProvider<
          WatchAuthStateUseCase,
          WatchAuthStateUseCase,
          WatchAuthStateUseCase
        >
    with $Provider<WatchAuthStateUseCase> {
  WatchAuthStateUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchAuthStateUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchAuthStateUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchAuthStateUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchAuthStateUseCase create(Ref ref) {
    return watchAuthStateUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchAuthStateUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchAuthStateUseCase>(value),
    );
  }
}

String _$watchAuthStateUseCaseHash() =>
    r'ce45fc80bcbfbc02d8cd563506f6a73d7fbe4cfa';

/// Notifier central de l'état d'authentification.
///
/// - Restaure la session au démarrage depuis le cache local.
/// - Écoute [WatchAuthStateUseCase] pour détecter les callbacks OAuth.
/// - Expose des méthodes d'action (signup, login, OAuth, logout, onboarding).

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

/// Notifier central de l'état d'authentification.
///
/// - Restaure la session au démarrage depuis le cache local.
/// - Écoute [WatchAuthStateUseCase] pour détecter les callbacks OAuth.
/// - Expose des méthodes d'action (signup, login, OAuth, logout, onboarding).
final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthState> {
  /// Notifier central de l'état d'authentification.
  ///
  /// - Restaure la session au démarrage depuis le cache local.
  /// - Écoute [WatchAuthStateUseCase] pour détecter les callbacks OAuth.
  /// - Expose des méthodes d'action (signup, login, OAuth, logout, onboarding).
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authNotifierHash() => r'32a812221a3b2d1a620527882dfa83ba4549c940';

/// Notifier central de l'état d'authentification.
///
/// - Restaure la session au démarrage depuis le cache local.
/// - Écoute [WatchAuthStateUseCase] pour détecter les callbacks OAuth.
/// - Expose des méthodes d'action (signup, login, OAuth, logout, onboarding).

abstract class _$AuthNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
