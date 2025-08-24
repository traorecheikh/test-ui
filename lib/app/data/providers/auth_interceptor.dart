
import 'package:dio/dio.dart';
import 'package:snt_ui_test/app/services/token_manager.dart';
import 'package:snt_ui_test/app/data/providers/api_client.dart';
import 'package:snt_ui_test/app/data/models/api_models.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await TokenManager.getAccessToken();
    if (accessToken != null && options.headers['Authorization'] == null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await TokenManager.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Create a new Dio instance for token refresh to avoid infinite loop
          final refreshDio = Dio();
          final apiClient = ApiClient(refreshDio);

          final tokenResponse = await apiClient.refreshAccessToken(RefreshTokenBody(refreshToken: refreshToken));
          final newAccessToken = tokenResponse.accessToken;
          final newRefreshToken = tokenResponse.refreshToken;

          await TokenManager.saveTokens(newAccessToken, newRefreshToken);

          // Retry the original request with the new access token
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          return handler.resolve(await _dio.fetch(err.requestOptions));
        } on DioException catch (e) {
          // If refresh token fails, clear tokens and redirect to login
          await TokenManager.deleteTokens();
          // TODO: Implement navigation to login screen
          return handler.next(e);
        }
      }
    }
    super.onError(err, handler);
  }
}
