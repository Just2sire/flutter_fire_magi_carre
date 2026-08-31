import "dart:async";

import "package:dio/dio.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "../../../../core/configs/logger.dart";
import "../../repositories/storage_repository_impl.dart";

/// Refresh JWT automatique sur 401 et rejeu de la requête.
///
/// Étend [QueuedInterceptor] pour sérialiser les refreshes concurrents :
/// si N requêtes échouent en 401 simultanément, une seule déclenche le
/// refresh ; les autres attendent la résolution.
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({
    required this.dio,
    required this.secureStorage,
    required this.sessionExpiredSink,
  });

  final Dio dio;
  final StorageRepositoryImpl secureStorage;
  final Sink<void> sessionExpiredSink;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra["retried"] == true;

    if (statusCode != 401 || alreadyRetried) {
      return handler.next(err);
    }

    try {
      final result = await Supabase.instance.client.auth.refreshSession();
      final session = result.session;
      if (session == null) {
        throw const AuthException("No session after refresh");
      }

      await secureStorage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken ?? "",
      );

      final retryOptions = err.requestOptions;
      retryOptions.extra["retried"] = true;
      retryOptions.headers["Authorization"] = "Bearer ${session.accessToken}";

      final retryResponse = await dio.fetch<dynamic>(retryOptions);
      return handler.resolve(retryResponse);
    } catch (e) {
      Log.w("RefreshInterceptor: refresh échoué, session expirée. Cause: $e");
      await secureStorage.clearTokens();
      sessionExpiredSink.add(null);
      return handler.reject(err);
    }
  }
}
