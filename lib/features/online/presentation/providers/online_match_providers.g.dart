// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_match_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onlineMatchRemoteDataSource)
final onlineMatchRemoteDataSourceProvider =
    OnlineMatchRemoteDataSourceProvider._();

final class OnlineMatchRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          OnlineMatchRemoteDataSourceImpl,
          OnlineMatchRemoteDataSourceImpl,
          OnlineMatchRemoteDataSourceImpl
        >
    with $Provider<OnlineMatchRemoteDataSourceImpl> {
  OnlineMatchRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onlineMatchRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onlineMatchRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<OnlineMatchRemoteDataSourceImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnlineMatchRemoteDataSourceImpl create(Ref ref) {
    return onlineMatchRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnlineMatchRemoteDataSourceImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnlineMatchRemoteDataSourceImpl>(
        value,
      ),
    );
  }
}

String _$onlineMatchRemoteDataSourceHash() =>
    r'29723724608501a487920649acade03848d52bfb';

@ProviderFor(onlineMatchRepository)
final onlineMatchRepositoryProvider = OnlineMatchRepositoryProvider._();

final class OnlineMatchRepositoryProvider
    extends
        $FunctionalProvider<
          IOnlineMatchRepository,
          IOnlineMatchRepository,
          IOnlineMatchRepository
        >
    with $Provider<IOnlineMatchRepository> {
  OnlineMatchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onlineMatchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onlineMatchRepositoryHash();

  @$internal
  @override
  $ProviderElement<IOnlineMatchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IOnlineMatchRepository create(Ref ref) {
    return onlineMatchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IOnlineMatchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IOnlineMatchRepository>(value),
    );
  }
}

String _$onlineMatchRepositoryHash() =>
    r'9731492c25de4c960f3a7cee919fb59ae0e2d1e6';

@ProviderFor(joinQueueUseCase)
final joinQueueUseCaseProvider = JoinQueueUseCaseProvider._();

final class JoinQueueUseCaseProvider
    extends $FunctionalProvider<JoinQueue, JoinQueue, JoinQueue>
    with $Provider<JoinQueue> {
  JoinQueueUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'joinQueueUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$joinQueueUseCaseHash();

  @$internal
  @override
  $ProviderElement<JoinQueue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JoinQueue create(Ref ref) {
    return joinQueueUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JoinQueue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JoinQueue>(value),
    );
  }
}

String _$joinQueueUseCaseHash() => r'930423170e9652a55028bc4e5679c2ffe1095410';

@ProviderFor(leaveQueueUseCase)
final leaveQueueUseCaseProvider = LeaveQueueUseCaseProvider._();

final class LeaveQueueUseCaseProvider
    extends $FunctionalProvider<LeaveQueue, LeaveQueue, LeaveQueue>
    with $Provider<LeaveQueue> {
  LeaveQueueUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveQueueUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveQueueUseCaseHash();

  @$internal
  @override
  $ProviderElement<LeaveQueue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaveQueue create(Ref ref) {
    return leaveQueueUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveQueue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveQueue>(value),
    );
  }
}

String _$leaveQueueUseCaseHash() => r'e8eff7385a10e9693606fc085cd5836d8a20b9e4';

@ProviderFor(createInviteMatchUseCase)
final createInviteMatchUseCaseProvider = CreateInviteMatchUseCaseProvider._();

final class CreateInviteMatchUseCaseProvider
    extends
        $FunctionalProvider<
          CreateInviteMatch,
          CreateInviteMatch,
          CreateInviteMatch
        >
    with $Provider<CreateInviteMatch> {
  CreateInviteMatchUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createInviteMatchUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createInviteMatchUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateInviteMatch> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateInviteMatch create(Ref ref) {
    return createInviteMatchUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateInviteMatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateInviteMatch>(value),
    );
  }
}

String _$createInviteMatchUseCaseHash() =>
    r'90f78858bbf9801352c6f0a1c4a6da7fc53fd637';

@ProviderFor(joinInviteMatchUseCase)
final joinInviteMatchUseCaseProvider = JoinInviteMatchUseCaseProvider._();

final class JoinInviteMatchUseCaseProvider
    extends
        $FunctionalProvider<JoinInviteMatch, JoinInviteMatch, JoinInviteMatch>
    with $Provider<JoinInviteMatch> {
  JoinInviteMatchUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'joinInviteMatchUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$joinInviteMatchUseCaseHash();

  @$internal
  @override
  $ProviderElement<JoinInviteMatch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JoinInviteMatch create(Ref ref) {
    return joinInviteMatchUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JoinInviteMatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JoinInviteMatch>(value),
    );
  }
}

String _$joinInviteMatchUseCaseHash() =>
    r'e6296add3b3d49abaedd43428c6b38b86108267f';

@ProviderFor(getMatchByInviteCodeUseCase)
final getMatchByInviteCodeUseCaseProvider =
    GetMatchByInviteCodeUseCaseProvider._();

final class GetMatchByInviteCodeUseCaseProvider
    extends
        $FunctionalProvider<
          GetMatchByInviteCode,
          GetMatchByInviteCode,
          GetMatchByInviteCode
        >
    with $Provider<GetMatchByInviteCode> {
  GetMatchByInviteCodeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMatchByInviteCodeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMatchByInviteCodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMatchByInviteCode> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetMatchByInviteCode create(Ref ref) {
    return getMatchByInviteCodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMatchByInviteCode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMatchByInviteCode>(value),
    );
  }
}

String _$getMatchByInviteCodeUseCaseHash() =>
    r'6a6f33f9f5ecd1fc49a8a95b5d0f657a25594fa4';

@ProviderFor(initializeMatchStateUseCase)
final initializeMatchStateUseCaseProvider =
    InitializeMatchStateUseCaseProvider._();

final class InitializeMatchStateUseCaseProvider
    extends
        $FunctionalProvider<
          InitializeMatchState,
          InitializeMatchState,
          InitializeMatchState
        >
    with $Provider<InitializeMatchState> {
  InitializeMatchStateUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initializeMatchStateUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializeMatchStateUseCaseHash();

  @$internal
  @override
  $ProviderElement<InitializeMatchState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InitializeMatchState create(Ref ref) {
    return initializeMatchStateUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitializeMatchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitializeMatchState>(value),
    );
  }
}

String _$initializeMatchStateUseCaseHash() =>
    r'ac6e57ee8512aafe7bf693c6a73cf6b8136bfd35';

@ProviderFor(submitMoveUseCase)
final submitMoveUseCaseProvider = SubmitMoveUseCaseProvider._();

final class SubmitMoveUseCaseProvider
    extends $FunctionalProvider<SubmitMove, SubmitMove, SubmitMove>
    with $Provider<SubmitMove> {
  SubmitMoveUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitMoveUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitMoveUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubmitMove> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SubmitMove create(Ref ref) {
    return submitMoveUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitMove value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitMove>(value),
    );
  }
}

String _$submitMoveUseCaseHash() => r'5d8537f374c039b10ae8a20508f7d17577d50ab6';

@ProviderFor(resignMatchUseCase)
final resignMatchUseCaseProvider = ResignMatchUseCaseProvider._();

final class ResignMatchUseCaseProvider
    extends $FunctionalProvider<ResignMatch, ResignMatch, ResignMatch>
    with $Provider<ResignMatch> {
  ResignMatchUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resignMatchUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resignMatchUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResignMatch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResignMatch create(Ref ref) {
    return resignMatchUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResignMatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResignMatch>(value),
    );
  }
}

String _$resignMatchUseCaseHash() =>
    r'e2d8e73173385d894ddccc3d17dcb34d692978ad';

@ProviderFor(claimTimeoutUseCase)
final claimTimeoutUseCaseProvider = ClaimTimeoutUseCaseProvider._();

final class ClaimTimeoutUseCaseProvider
    extends $FunctionalProvider<ClaimTimeout, ClaimTimeout, ClaimTimeout>
    with $Provider<ClaimTimeout> {
  ClaimTimeoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claimTimeoutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claimTimeoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<ClaimTimeout> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClaimTimeout create(Ref ref) {
    return claimTimeoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClaimTimeout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClaimTimeout>(value),
    );
  }
}

String _$claimTimeoutUseCaseHash() =>
    r'02d09dac39608ffcc8a0c7561f7e0b1a6ad74188';

@ProviderFor(markMatchRecordedUseCase)
final markMatchRecordedUseCaseProvider = MarkMatchRecordedUseCaseProvider._();

final class MarkMatchRecordedUseCaseProvider
    extends
        $FunctionalProvider<
          MarkMatchRecorded,
          MarkMatchRecorded,
          MarkMatchRecorded
        >
    with $Provider<MarkMatchRecorded> {
  MarkMatchRecordedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markMatchRecordedUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markMatchRecordedUseCaseHash();

  @$internal
  @override
  $ProviderElement<MarkMatchRecorded> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkMatchRecorded create(Ref ref) {
    return markMatchRecordedUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkMatchRecorded value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkMatchRecorded>(value),
    );
  }
}

String _$markMatchRecordedUseCaseHash() =>
    r'e95f6a3796ef5950b1c2573d0cb06ef4e9d3b91e';

@ProviderFor(watchMatchUseCase)
final watchMatchUseCaseProvider = WatchMatchUseCaseProvider._();

final class WatchMatchUseCaseProvider
    extends $FunctionalProvider<WatchMatch, WatchMatch, WatchMatch>
    with $Provider<WatchMatch> {
  WatchMatchUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchMatchUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchMatchUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchMatch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WatchMatch create(Ref ref) {
    return watchMatchUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchMatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchMatch>(value),
    );
  }
}

String _$watchMatchUseCaseHash() => r'5cb73c8ec8d66e0ee1f7b986ec9163d2197f645a';

@ProviderFor(watchMyActiveMatchesUseCase)
final watchMyActiveMatchesUseCaseProvider =
    WatchMyActiveMatchesUseCaseProvider._();

final class WatchMyActiveMatchesUseCaseProvider
    extends
        $FunctionalProvider<
          WatchMyActiveMatches,
          WatchMyActiveMatches,
          WatchMyActiveMatches
        >
    with $Provider<WatchMyActiveMatches> {
  WatchMyActiveMatchesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchMyActiveMatchesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchMyActiveMatchesUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchMyActiveMatches> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchMyActiveMatches create(Ref ref) {
    return watchMyActiveMatchesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchMyActiveMatches value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchMyActiveMatches>(value),
    );
  }
}

String _$watchMyActiveMatchesUseCaseHash() =>
    r'd5a550c73adcb61291b1aa899075f5497be40b78';

@ProviderFor(watchAssignedMatchUseCase)
final watchAssignedMatchUseCaseProvider = WatchAssignedMatchUseCaseProvider._();

final class WatchAssignedMatchUseCaseProvider
    extends
        $FunctionalProvider<
          WatchAssignedMatch,
          WatchAssignedMatch,
          WatchAssignedMatch
        >
    with $Provider<WatchAssignedMatch> {
  WatchAssignedMatchUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchAssignedMatchUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchAssignedMatchUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchAssignedMatch> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchAssignedMatch create(Ref ref) {
    return watchAssignedMatchUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchAssignedMatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchAssignedMatch>(value),
    );
  }
}

String _$watchAssignedMatchUseCaseHash() =>
    r'2929c2572476e4a50bf82238bce7c9f9226f806f';

@ProviderFor(myActiveMatches)
final myActiveMatchesProvider = MyActiveMatchesProvider._();

final class MyActiveMatchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OnlineMatch>>,
          List<OnlineMatch>,
          Stream<List<OnlineMatch>>
        >
    with
        $FutureModifier<List<OnlineMatch>>,
        $StreamProvider<List<OnlineMatch>> {
  MyActiveMatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myActiveMatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myActiveMatchesHash();

  @$internal
  @override
  $StreamProviderElement<List<OnlineMatch>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OnlineMatch>> create(Ref ref) {
    return myActiveMatches(ref);
  }
}

String _$myActiveMatchesHash() => r'6ea5a89ef30f103a3cc36909439fb0094178d065';

/// Remplace GameNotifier (mode local) pour une partie en ligne : la
/// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
/// via Realtime, applique les coups localement avec les mêmes fonctions
/// pures du moteur avant de les soumettre, et fait tourner les deux
/// pendules à l'affichage entre deux syncs serveur.

@ProviderFor(OnlineMatchNotifier)
final onlineMatchProvider = OnlineMatchNotifierFamily._();

/// Remplace GameNotifier (mode local) pour une partie en ligne : la
/// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
/// via Realtime, applique les coups localement avec les mêmes fonctions
/// pures du moteur avant de les soumettre, et fait tourner les deux
/// pendules à l'affichage entre deux syncs serveur.
final class OnlineMatchNotifierProvider
    extends $AsyncNotifierProvider<OnlineMatchNotifier, OnlineMatchState> {
  /// Remplace GameNotifier (mode local) pour une partie en ligne : la
  /// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
  /// via Realtime, applique les coups localement avec les mêmes fonctions
  /// pures du moteur avant de les soumettre, et fait tourner les deux
  /// pendules à l'affichage entre deux syncs serveur.
  OnlineMatchNotifierProvider._({
    required OnlineMatchNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'onlineMatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$onlineMatchNotifierHash();

  @override
  String toString() {
    return r'onlineMatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OnlineMatchNotifier create() => OnlineMatchNotifier();

  @override
  bool operator ==(Object other) {
    return other is OnlineMatchNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$onlineMatchNotifierHash() =>
    r'b659896e862210d117613bea5be3d5f92b5ee96a';

/// Remplace GameNotifier (mode local) pour une partie en ligne : la
/// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
/// via Realtime, applique les coups localement avec les mêmes fonctions
/// pures du moteur avant de les soumettre, et fait tourner les deux
/// pendules à l'affichage entre deux syncs serveur.

final class OnlineMatchNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          OnlineMatchNotifier,
          AsyncValue<OnlineMatchState>,
          OnlineMatchState,
          FutureOr<OnlineMatchState>,
          String
        > {
  OnlineMatchNotifierFamily._()
    : super(
        retry: null,
        name: r'onlineMatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Remplace GameNotifier (mode local) pour une partie en ligne : la
  /// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
  /// via Realtime, applique les coups localement avec les mêmes fonctions
  /// pures du moteur avant de les soumettre, et fait tourner les deux
  /// pendules à l'affichage entre deux syncs serveur.

  OnlineMatchNotifierProvider call(String matchId) =>
      OnlineMatchNotifierProvider._(argument: matchId, from: this);

  @override
  String toString() => r'onlineMatchProvider';
}

/// Remplace GameNotifier (mode local) pour une partie en ligne : la
/// vérité de l'état de jeu vit dans Supabase, ce notifier s'y synchronise
/// via Realtime, applique les coups localement avec les mêmes fonctions
/// pures du moteur avant de les soumettre, et fait tourner les deux
/// pendules à l'affichage entre deux syncs serveur.

abstract class _$OnlineMatchNotifier extends $AsyncNotifier<OnlineMatchState> {
  late final _$args = ref.$arg as String;
  String get matchId => _$args;

  FutureOr<OnlineMatchState> build(String matchId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<OnlineMatchState>, OnlineMatchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OnlineMatchState>, OnlineMatchState>,
              AsyncValue<OnlineMatchState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
