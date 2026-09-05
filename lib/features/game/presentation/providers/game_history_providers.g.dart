// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameHistoryRemoteDataSource)
final gameHistoryRemoteDataSourceProvider =
    GameHistoryRemoteDataSourceProvider._();

final class GameHistoryRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          GameHistoryRemoteDataSourceImpl,
          GameHistoryRemoteDataSourceImpl,
          GameHistoryRemoteDataSourceImpl
        >
    with $Provider<GameHistoryRemoteDataSourceImpl> {
  GameHistoryRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameHistoryRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<GameHistoryRemoteDataSourceImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GameHistoryRemoteDataSourceImpl create(Ref ref) {
    return gameHistoryRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameHistoryRemoteDataSourceImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameHistoryRemoteDataSourceImpl>(
        value,
      ),
    );
  }
}

String _$gameHistoryRemoteDataSourceHash() =>
    r'1232b8ac3abc88aecacc04ab961271dcab882c62';

@ProviderFor(gameHistoryRepository)
final gameHistoryRepositoryProvider = GameHistoryRepositoryProvider._();

final class GameHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          IGameHistoryRepository,
          IGameHistoryRepository,
          IGameHistoryRepository
        >
    with $Provider<IGameHistoryRepository> {
  GameHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<IGameHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IGameHistoryRepository create(Ref ref) {
    return gameHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGameHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGameHistoryRepository>(value),
    );
  }
}

String _$gameHistoryRepositoryHash() =>
    r'c873d6786ee7d98b0e7e419c313461d96bb9414b';

@ProviderFor(recordGameResultUseCase)
final recordGameResultUseCaseProvider = RecordGameResultUseCaseProvider._();

final class RecordGameResultUseCaseProvider
    extends
        $FunctionalProvider<
          RecordGameResult,
          RecordGameResult,
          RecordGameResult
        >
    with $Provider<RecordGameResult> {
  RecordGameResultUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordGameResultUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordGameResultUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecordGameResult> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordGameResult create(Ref ref) {
    return recordGameResultUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordGameResult value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordGameResult>(value),
    );
  }
}

String _$recordGameResultUseCaseHash() =>
    r'c6ae606ebc1a3662743c17bff9a86798bdf49fb5';

@ProviderFor(getGameHistoryUseCase)
final getGameHistoryUseCaseProvider = GetGameHistoryUseCaseProvider._();

final class GetGameHistoryUseCaseProvider
    extends $FunctionalProvider<GetGameHistory, GetGameHistory, GetGameHistory>
    with $Provider<GetGameHistory> {
  GetGameHistoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getGameHistoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getGameHistoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetGameHistory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetGameHistory create(Ref ref) {
    return getGameHistoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetGameHistory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetGameHistory>(value),
    );
  }
}

String _$getGameHistoryUseCaseHash() =>
    r'e245a9a4016aa17c1b0a0e59cc77816648455a27';

/// Historique de parties d'un joueur, trié du plus récent au plus ancien.

@ProviderFor(playerHistory)
final playerHistoryProvider = PlayerHistoryFamily._();

/// Historique de parties d'un joueur, trié du plus récent au plus ancien.

final class PlayerHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameHistoryEntry>>,
          List<GameHistoryEntry>,
          FutureOr<List<GameHistoryEntry>>
        >
    with
        $FutureModifier<List<GameHistoryEntry>>,
        $FutureProvider<List<GameHistoryEntry>> {
  /// Historique de parties d'un joueur, trié du plus récent au plus ancien.
  PlayerHistoryProvider._({
    required PlayerHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playerHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerHistoryHash();

  @override
  String toString() {
    return r'playerHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GameHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameHistoryEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return playerHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerHistoryHash() => r'2ca9dce4c567e7a8e60301c68b11daeb7a3baee5';

/// Historique de parties d'un joueur, trié du plus récent au plus ancien.

final class PlayerHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GameHistoryEntry>>, String> {
  PlayerHistoryFamily._()
    : super(
        retry: null,
        name: r'playerHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Historique de parties d'un joueur, trié du plus récent au plus ancien.

  PlayerHistoryProvider call(String playerId) =>
      PlayerHistoryProvider._(argument: playerId, from: this);

  @override
  String toString() => r'playerHistoryProvider';
}
