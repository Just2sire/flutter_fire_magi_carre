// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Datasource REST (Dio) du classement — voir
/// [LeaderboardRemoteDataSourceImpl] pour le détail du client HTTP maison.

@ProviderFor(leaderboardRemoteDataSource)
final leaderboardRemoteDataSourceProvider =
    LeaderboardRemoteDataSourceProvider._();

/// Datasource REST (Dio) du classement — voir
/// [LeaderboardRemoteDataSourceImpl] pour le détail du client HTTP maison.

final class LeaderboardRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          LeaderboardRemoteDataSourceImpl,
          LeaderboardRemoteDataSourceImpl,
          LeaderboardRemoteDataSourceImpl
        >
    with $Provider<LeaderboardRemoteDataSourceImpl> {
  /// Datasource REST (Dio) du classement — voir
  /// [LeaderboardRemoteDataSourceImpl] pour le détail du client HTTP maison.
  LeaderboardRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<LeaderboardRemoteDataSourceImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LeaderboardRemoteDataSourceImpl create(Ref ref) {
    return leaderboardRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaderboardRemoteDataSourceImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaderboardRemoteDataSourceImpl>(
        value,
      ),
    );
  }
}

String _$leaderboardRemoteDataSourceHash() =>
    r'e96cf2e59b62638672ad5107b19f67837ab0c952';

/// Implémentation [LeaderboardRepository] — REST + cache local + repli
/// hors-ligne.

@ProviderFor(leaderboardRepository)
final leaderboardRepositoryProvider = LeaderboardRepositoryProvider._();

/// Implémentation [LeaderboardRepository] — REST + cache local + repli
/// hors-ligne.

final class LeaderboardRepositoryProvider
    extends
        $FunctionalProvider<
          LeaderboardRepository,
          LeaderboardRepository,
          LeaderboardRepository
        >
    with $Provider<LeaderboardRepository> {
  /// Implémentation [LeaderboardRepository] — REST + cache local + repli
  /// hors-ligne.
  LeaderboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeaderboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LeaderboardRepository create(Ref ref) {
    return leaderboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaderboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaderboardRepository>(value),
    );
  }
}

String _$leaderboardRepositoryHash() =>
    r'e225f1282eecd084051a17b3209d0953e45b5ab9';

@ProviderFor(getLeaderboardUseCase)
final getLeaderboardUseCaseProvider = GetLeaderboardUseCaseProvider._();

final class GetLeaderboardUseCaseProvider
    extends
        $FunctionalProvider<
          GetLeaderboardUseCase,
          GetLeaderboardUseCase,
          GetLeaderboardUseCase
        >
    with $Provider<GetLeaderboardUseCase> {
  GetLeaderboardUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getLeaderboardUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getLeaderboardUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetLeaderboardUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetLeaderboardUseCase create(Ref ref) {
    return getLeaderboardUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetLeaderboardUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetLeaderboardUseCase>(value),
    );
  }
}

String _$getLeaderboardUseCaseHash() =>
    r'd59c400829bf2af802f813ca2c9dfa0a3968c6f4';

@ProviderFor(getMyRankUseCase)
final getMyRankUseCaseProvider = GetMyRankUseCaseProvider._();

final class GetMyRankUseCaseProvider
    extends
        $FunctionalProvider<
          GetMyRankUseCase,
          GetMyRankUseCase,
          GetMyRankUseCase
        >
    with $Provider<GetMyRankUseCase> {
  GetMyRankUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMyRankUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMyRankUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMyRankUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetMyRankUseCase create(Ref ref) {
    return getMyRankUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMyRankUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMyRankUseCase>(value),
    );
  }
}

String _$getMyRankUseCaseHash() => r'df776eca80e9fb33b58a5f5dfc0f5ba97def1eb5';

/// Page du classement global, triée par rating décroissant.

@ProviderFor(topPlayers)
final topPlayersProvider = TopPlayersFamily._();

/// Page du classement global, triée par rating décroissant.

final class TopPlayersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeaderboardEntry>>,
          List<LeaderboardEntry>,
          FutureOr<List<LeaderboardEntry>>
        >
    with
        $FutureModifier<List<LeaderboardEntry>>,
        $FutureProvider<List<LeaderboardEntry>> {
  /// Page du classement global, triée par rating décroissant.
  TopPlayersProvider._({
    required TopPlayersFamily super.from,
    required ({int limit, int offset}) super.argument,
  }) : super(
         retry: null,
         name: r'topPlayersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$topPlayersHash();

  @override
  String toString() {
    return r'topPlayersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LeaderboardEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LeaderboardEntry>> create(Ref ref) {
    final argument = this.argument as ({int limit, int offset});
    return topPlayers(ref, limit: argument.limit, offset: argument.offset);
  }

  @override
  bool operator ==(Object other) {
    return other is TopPlayersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topPlayersHash() => r'b52cf792e2fe736bd7f20f52f148c2ecb6e173d7';

/// Page du classement global, triée par rating décroissant.

final class TopPlayersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LeaderboardEntry>>,
          ({int limit, int offset})
        > {
  TopPlayersFamily._()
    : super(
        retry: null,
        name: r'topPlayersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Page du classement global, triée par rating décroissant.

  TopPlayersProvider call({int limit = 50, int offset = 0}) =>
      TopPlayersProvider._(
        argument: (limit: limit, offset: offset),
        from: this,
      );

  @override
  String toString() => r'topPlayersProvider';
}

/// Rang de l'utilisateur courant dans le classement global.

@ProviderFor(myRank)
final myRankProvider = MyRankProvider._();

/// Rang de l'utilisateur courant dans le classement global.

final class MyRankProvider
    extends
        $FunctionalProvider<
          AsyncValue<LeaderboardEntry>,
          LeaderboardEntry,
          FutureOr<LeaderboardEntry>
        >
    with $FutureModifier<LeaderboardEntry>, $FutureProvider<LeaderboardEntry> {
  /// Rang de l'utilisateur courant dans le classement global.
  MyRankProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRankProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myRankHash();

  @$internal
  @override
  $FutureProviderElement<LeaderboardEntry> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LeaderboardEntry> create(Ref ref) {
    return myRank(ref);
  }
}

String _$myRankHash() => r'020d03c53c746f54f45171a861bbb3e360f61352';
