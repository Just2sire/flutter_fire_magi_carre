import "package:flutter_test/flutter_test.dart";
import "package:magi_carre/features/game/data/datasources/game_history_remote_datasource.dart";
import "package:magi_carre/features/game/data/models/game_history_entry_model.dart";
import "package:magi_carre/features/game/data/repositories/game_history_repository_impl.dart";
import "package:magi_carre/shared/data/services/local_cache_service.dart";
import "package:magi_carre/shared/domain/failures/index.dart";
import "package:magi_carre/shared/domain/network_info.dart";
import "package:mocktail/mocktail.dart";

class _MockRemoteDataSource extends Mock
    implements GameHistoryRemoteDataSource {}

class _MockLocalCacheService extends Mock implements LocalCacheService {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remoteDataSource;
  late _MockLocalCacheService cache;
  late _MockNetworkInfo networkInfo;
  late GameHistoryRepositoryImpl repository;

  final remoteEntries = [
    GameHistoryEntryModel(
      id: "g1",
      playerId: "u1",
      opponentType: "ai",
      aiDifficulty: "medium",
      result: "win",
      boardSize: 5,
      moveCount: 24,
      playerRatingBefore: 1000,
      playerRatingAfter: 1016,
      ratingDelta: 16,
      playedAt: DateTime(2026),
    ),
  ];

  setUp(() {
    remoteDataSource = _MockRemoteDataSource();
    cache = _MockLocalCacheService();
    networkInfo = _MockNetworkInfo();
    repository = GameHistoryRepositoryImpl(
      dataSource: remoteDataSource,
      cache: cache,
      networkInfo: networkInfo,
    );

    when(() => cache.saveList(any(), any())).thenAnswer((_) async {});
  });

  group("getGameHistory", () {
    test(
      "retourne Right avec les entrées distantes et les met en cache",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.getGameHistory(
            playerId: any(named: "playerId"),
            limit: any(named: "limit"),
            offset: any(named: "offset"),
          ),
        ).thenAnswer((_) async => remoteEntries);

        final result = await repository.getGameHistory(playerId: "u1");

        expect(result.isRight, isTrue);
        expect(result.rightOrNull, equals(remoteEntries));
        verify(() => cache.saveList("game_history_u1", any())).called(1);
      },
    );

    test(
      "retourne le cache (Right) quand l'appareil est hors-ligne",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(() => cache.readList("game_history_u1")).thenReturn(
          CachedList(
            items: [remoteEntries.first.toCacheJson()],
            cachedAt: DateTime(2026),
          ),
        );

        final result = await repository.getGameHistory(playerId: "u1");

        expect(result.isRight, isTrue);
        expect(result.rightOrNull?.single.id, "g1");
        verifyNever(
          () => remoteDataSource.getGameHistory(
            playerId: any(named: "playerId"),
            limit: any(named: "limit"),
            offset: any(named: "offset"),
          ),
        );
      },
    );

    test(
      "retourne Left(NetworkFailure) hors-ligne sans donnée en cache",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(() => cache.readList("game_history_u1")).thenReturn(null);

        final result = await repository.getGameHistory(playerId: "u1");

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<NetworkFailure>());
      },
    );

    test(
      "retourne Left(ServerFailure) si l'appel distant échoue sans cache",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.getGameHistory(
            playerId: any(named: "playerId"),
            limit: any(named: "limit"),
            offset: any(named: "offset"),
          ),
        ).thenThrow(Exception("boom"));
        when(() => cache.readList("game_history_u1")).thenReturn(null);

        final result = await repository.getGameHistory(playerId: "u1");

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<ServerFailure>());
      },
    );
  });

  group("recordGameResult", () {
    test("retourne Right(null) quand la RPC réussit", () async {
      when(
        () => remoteDataSource.recordGameResult(
          playerId: any(named: "playerId"),
          opponentType: any(named: "opponentType"),
          result: any(named: "result"),
          boardSize: any(named: "boardSize"),
          moveCount: any(named: "moveCount"),
          aiDifficulty: any(named: "aiDifficulty"),
          opponentId: any(named: "opponentId"),
          rated: any(named: "rated"),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.recordGameResult(
        playerId: "u1",
        opponentType: "ai",
        result: "win",
        boardSize: 5,
        moveCount: 24,
        aiDifficulty: "medium",
      );

      expect(result.isRight, isTrue);
    });

    test("retourne Left(ServerFailure) quand la RPC échoue", () async {
      when(
        () => remoteDataSource.recordGameResult(
          playerId: any(named: "playerId"),
          opponentType: any(named: "opponentType"),
          result: any(named: "result"),
          boardSize: any(named: "boardSize"),
          moveCount: any(named: "moveCount"),
          aiDifficulty: any(named: "aiDifficulty"),
          opponentId: any(named: "opponentId"),
          rated: any(named: "rated"),
        ),
      ).thenThrow(Exception("network down"));

      final result = await repository.recordGameResult(
        playerId: "u1",
        opponentType: "ai",
        result: "loss",
        boardSize: 5,
        moveCount: 10,
      );

      expect(result.isLeft, isTrue);
      expect(result.leftOrNull, isA<ServerFailure>());
    });
  });
}
