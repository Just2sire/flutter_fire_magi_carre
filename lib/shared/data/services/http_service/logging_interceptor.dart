import "package:dio/dio.dart";
import "package:flutter/foundation.dart";

import "../../../../core/configs/logger.dart";

/// Intercepteur de logs — actif uniquement en [kDebugMode].
///
/// Ne logue jamais le header `Authorization` ni le body de la requête.
/// Format : `→ POST /ocr` puis `← 200 /ocr (312ms)`.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(options);
    options.extra["_startMs"] = DateTime.now().millisecondsSinceEpoch;
    Log.d("→ ${options.method} ${options.uri.path}");
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!kDebugMode) return handler.next(response);
    final start = response.requestOptions.extra["_startMs"] as int?;
    final elapsed =
        start != null ? DateTime.now().millisecondsSinceEpoch - start : 0;
    final path = response.requestOptions.uri.path;
    Log.d("← ${response.statusCode} $path (${elapsed}ms)");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(err);
    final path = err.requestOptions.uri.path;
    final code = err.response?.statusCode ?? "?";
    Log.w("✗ $code $path — ${err.message}");
    handler.next(err);
  }
}
