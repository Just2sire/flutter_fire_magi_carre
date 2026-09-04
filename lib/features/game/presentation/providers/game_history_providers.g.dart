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
    r'2fef5660d2b34a69ad7707b8eb039a6694ead891';

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
