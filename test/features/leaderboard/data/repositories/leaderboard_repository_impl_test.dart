import "package:flutter_test/flutter_test.dart";
import "package:magi_carre/features/leaderboard/data/datasources/leaderboard_remote_datasource.dart";
import "package:magi_carre/features/leaderboard/data/models/leaderboard_entry_model.dart";
import "package:magi_carre/features/leaderboard/data/repositories/leaderboard_repository_impl.dart";
import "package:magi_carre/shared/data/services/local_cache_service.dart";
import "package:magi_carre/shared/domain/failures/index.dart";
import "package:magi_carre/shared/domain/network_info.dart";
import "package:mocktail/mocktail.dart";

class _MockRemoteDataSource extends Mock
    implements LeaderboardRemoteDataSource {}

class _MockLocalCacheService extends Mock implements LocalCacheService {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remoteDataSource;
  late _MockLocalCacheService cache;
  late _MockNetworkInfo networkInfo;
  late LeaderboardRepositoryImpl repository;

  final remoteEntries = [
    const LeaderboardEntryModel(
      rank: 1,
      userId: "u1",
      username: "Ama",
      rating: 1500,
    ),
    const LeaderboardEntryModel(
      rank: 2,
      userId: "u2",
      username: "Kofi",
      rating: 1400,
    ),
  ];

  final cachedItems = [
    {
      "rank": 1,
      "id": "u1",
      "username": "Ama (cache)",
      "rating": 1500,
      "avatar_url": null,
    },
  ];

  setUp(() {
    remoteDataSource = _MockRemoteDataSource();
    cache = _MockLocalCacheService();
    networkInfo = _MockNetworkInfo();
    repository = LeaderboardRepositoryImpl(
      remoteDataSource: remoteDataSource,
      cache: cache,
      networkInfo: networkInfo,
    );

    // Défaut : le cache accepte toute écriture sans erreur.
    when(() => cache.saveList(any(), any())).thenAnswer((_) async {});
  });

  group("fetchTopPlayers", () {
    test(
      "retourne Right avec les entrées distantes quand le réseau est "
      "disponible",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.fetchTopPlayers(
            limit: any(named: "limit"),
            offset: any(named: "offset"),
          ),
        ).thenAnswer((_) async => remoteEntries);

        final result = await repository.fetchTopPlayers();

        expect(result.isRight, isTrue);
        expect(result.rightOrNull, equals(remoteEntries));
        verify(() => cache.saveList(any(), any())).called(1);
      },
    );

    test(
      "retourne les données en cache (Right) quand l'appareil est hors-ligne",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => cache.readList(any()),
        ).thenReturn(CachedList(items: cachedItems, cachedAt: DateTime(2026)));

        final result = await repository.fetchTopPlayers();

        expect(result.isRight, isTrue);
        expect(result.rightOrNull?.single.username, "Ama (cache)");
        verifyNever(
          () => remoteDataSource.fetchTopPlayers(
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
        when(() => cache.readList(any())).thenReturn(null);

        final result = await repository.fetchTopPlayers();

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<NetworkFailure>());
      },
    );

    test(
      "retombe sur le cache (Right) si l'appel réseau échoue malgré une "
      "connectivité déclarée",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.fetchTopPlayers(
            limit: any(named: "limit"),
            offset: any(named: "offset"),
          ),
        ).thenThrow(Exception("boom"));
        when(() => cache.readList(any())).thenReturn(
          CachedList(items: cachedItems, cachedAt: DateTime(2026)),
        );

        final result = await repository.fetchTopPlayers();

        expect(result.isRight, isTrue);
        expect(result.rightOrNull?.single.username, "Ama (cache)");
      },
    );

    test(
      "retourne Left(ServerFailure) si l'appel réseau échoue et qu'aucun "
      "cache n'existe",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.fetchTopPlayers(
            limit: any(named: "limit"),
            offset: any(named: "offset"),
          ),
        ).thenThrow(Exception("boom"));
        when(() => cache.readList(any())).thenReturn(null);

        final result = await repository.fetchTopPlayers();

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<ServerFailure>());
      },
    );
  });

  group("fetchMyRank", () {
    test(
      "retourne Left(UserNotFoundFailure) si aucun utilisateur courant",
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => remoteDataSource.getCurrentUserId()).thenReturn(null);

        final result = await repository.fetchMyRank();

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<UserNotFoundFailure>());
      },
    );

    test("retourne Right avec le rang distant et le met en cache", () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getCurrentUserId()).thenReturn("u1");
      when(() => remoteDataSource.fetchMyRank(userId: "u1"))
          .thenAnswer((_) async => remoteEntries.first);
      when(() => cache.saveObject(any(), any())).thenAnswer((_) async {});

      final result = await repository.fetchMyRank();

      expect(result.isRight, isTrue);
      expect(result.rightOrNull?.userId, "u1");
      verify(() => cache.saveObject(any(), any())).called(1);
    });
  });
}
