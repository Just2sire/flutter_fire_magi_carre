import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/supabase_provider.dart";
import "../../data/datasources/leaderboard_remote_datasource_impl.dart";
import "../../data/repositories/leaderboard_repository_impl.dart";
import "../../domain/entities/leaderboard_entry.dart";
import "../../domain/repositories/leaderboard_repository.dart";
import "../../domain/usecases/get_leaderboard_usecase.dart";
import "../../domain/usecases/get_my_rank_usecase.dart";

part "leaderboard_providers.g.dart";

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

/// Datasource Supabase du classement.
@Riverpod(keepAlive: true)
LeaderboardRemoteDataSourceImpl leaderboardRemoteDataSource(Ref ref) {
  return LeaderboardRemoteDataSourceImpl(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

/// Implémentation [LeaderboardRepository] branchée sur Supabase.
@Riverpod(keepAlive: true)
LeaderboardRepository leaderboardRepository(Ref ref) {
  return LeaderboardRepositoryImpl(
    remoteDataSource: ref.watch(leaderboardRemoteDataSourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Usecases
// ---------------------------------------------------------------------------

@riverpod
GetLeaderboardUseCase getLeaderboardUseCase(Ref ref) =>
    GetLeaderboardUseCase(ref.watch(leaderboardRepositoryProvider));

@riverpod
GetMyRankUseCase getMyRankUseCase(Ref ref) =>
    GetMyRankUseCase(ref.watch(leaderboardRepositoryProvider));

// ---------------------------------------------------------------------------
// Données exposées à l'UI
// ---------------------------------------------------------------------------

/// Page du classement global, triée par rating décroissant.
@riverpod
Future<List<LeaderboardEntry>> topPlayers(
  Ref ref, {
  int limit = 50,
  int offset = 0,
}) async {
  final result = await ref
      .watch(getLeaderboardUseCaseProvider)
      .call(limit: limit, offset: offset);
  return result.fold((failure) => throw failure, (entries) => entries);
}

/// Rang de l'utilisateur courant dans le classement global.
@riverpod
Future<LeaderboardEntry> myRank(Ref ref) async {
  final result = await ref.watch(getMyRankUseCaseProvider).call();
  return result.fold((failure) => throw failure, (entry) => entry);
}
