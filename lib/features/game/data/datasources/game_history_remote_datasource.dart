import "package:supabase_flutter/supabase_flutter.dart" as sb;

import "../../domain/entities/game_history_entry.dart";
import "../models/game_history_entry_model.dart";

/// Abstract contract for the game history remote data source.
abstract interface class GameHistoryRemoteDataSource {
  Future<void> recordGameResult({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    required int durationSeconds,
  });

  Future<List<GameHistoryEntry>> getGameHistory({
    required String playerId,
    int limit = 30,
    int offset = 0,
  });
}

/// Supabase implementation — calls the `record_game_result` RPC.
class GameHistoryRemoteDataSourceImpl implements GameHistoryRemoteDataSource {
  const GameHistoryRemoteDataSourceImpl({
    required sb.SupabaseClient supabaseClient,
  }) : _supabase = supabaseClient;

  final sb.SupabaseClient _supabase;

  @override
  Future<void> recordGameResult({
    required String playerId,
    required String opponentType,
    required String result,
    required int boardSize,
    required int moveCount,
    required int durationSeconds,
  }) async {
    await _supabase.rpc<void>(
      "record_game_result",
      params: {
        "p_player_id": playerId,
        "p_opponent_type": opponentType,
        "p_result": result,
        "p_board_size": boardSize,
        "p_move_count": moveCount,
        "p_duration_seconds": durationSeconds,
      },
    );
  }

  @override
  Future<List<GameHistoryEntry>> getGameHistory({
    required String playerId,
    int limit = 30,
    int offset = 0,
  }) async {
    final rows = await _supabase
        .from("game_history")
        .select()
        .eq("player_id", playerId)
        .order("created_at", ascending: false)
        .range(offset, offset + limit - 1);
    return [for (final row in rows) GameHistoryEntryModel.fromJson(row)];
  }
}
