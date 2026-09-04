import "package:supabase_flutter/supabase_flutter.dart" as sb;

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
}
