import "package:dio/dio.dart";

import "../../repositories/storage_repository_impl.dart";

/// Injecte le token JWT dans le header `Authorization: Bearer <token>`.
///
/// Skip si `options.extra['skipAuth'] == true`
/// (cas Mistral où le token statique est déjà dans les `BaseOptions.headers`).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final StorageRepositoryImpl _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra["skipAuth"] == true) {
      return handler.next(options);
    }

    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }
}
