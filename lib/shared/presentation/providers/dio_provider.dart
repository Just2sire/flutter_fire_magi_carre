import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/configs/app_config.dart";
import "../../data/services/http_service/dio_client.dart";

part "dio_provider.g.dart";

/// Client Dio configuré pour appeler l'API REST Supabase directement
/// (`AuthInterceptor` + `RefreshInterceptor` + `LoggingInterceptor`).
@Riverpod(keepAlive: true)
Dio supabaseRestDio(Ref ref) {
  return DioClient.createSupabaseRestDio(
    supabaseUrl: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  );
}
