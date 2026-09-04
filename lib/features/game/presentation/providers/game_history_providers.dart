import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/supabase_provider.dart";
import "../../data/datasources/game_history_remote_datasource.dart";
import "../../data/repositories/game_history_repository_impl.dart";
import "../../domain/entities/game_history_entry.dart";
import "../../domain/repositories/i_game_history_repository.dart";
import "../../domain/usecases/get_game_history.dart";
import "../../domain/usecases/record_game_result.dart";

part "game_history_providers.g.dart";

@Riverpod(keepAlive: true)
GameHistoryRemoteDataSourceImpl gameHistoryRemoteDataSource(Ref ref) {
  return GameHistoryRemoteDataSourceImpl(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

@Riverpod(keepAlive: true)
IGameHistoryRepository gameHistoryRepository(Ref ref) {
  return GameHistoryRepositoryImpl(
    dataSource: ref.watch(gameHistoryRemoteDataSourceProvider),
  );
}

@riverpod
RecordGameResult recordGameResultUseCase(Ref ref) =>
    RecordGameResult(ref.watch(gameHistoryRepositoryProvider));

@riverpod
GetGameHistory getGameHistoryUseCase(Ref ref) =>
    GetGameHistory(ref.watch(gameHistoryRepositoryProvider));

/// Historique de parties d'un joueur, trié du plus récent au plus ancien.
@riverpod
Future<List<GameHistoryEntry>> playerHistory(
  Ref ref,
  String playerId,
) async {
  final result = await ref
      .read(getGameHistoryUseCaseProvider)
      .call(playerId: playerId);
  return result.fold((f) => throw f, (entries) => entries);
}
