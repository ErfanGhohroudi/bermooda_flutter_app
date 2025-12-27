import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../core/functions/user_functions.dart';
import '../../core/services/secure_storage_service.dart';
import '../data.dart';

/// For adding token to header and handle unauthorized error.
class AuthInterceptor extends dio.Interceptor {
  AccessTokenDatasource get _accessTokenDatasource => Get.find<AccessTokenDatasource>();

  @override
  void onRequest(final dio.RequestOptions options, final dio.RequestInterceptorHandler handler) async {
    // چک کردن skipAuth flag (از parameter یا options.extra)
    final skipAuth = options.extra['skipAuth'] == true;

    // افزودن توکن به header در صورت عدم وجود و عدم فعال بودن skipAuth
    if (!skipAuth && !options.headers.containsKey('Authorization')) {
      final token = await SecureStorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = token;
      }
    }
    handler.next(options);
  }

  @override
  void onError(final dio.DioException err, final dio.ErrorInterceptorHandler handler) async {
    final skipAuth = err.requestOptions.extra['skipAuth'] == true;

    if (!skipAuth && err.response?.statusCode == 401) {
      try {
        final success = await _accessTokenDatasource.buildNewToken();

        if (success == false) {
          logout();
          return;
        }

        // Retry the request with new token
        final opts = err.requestOptions;
        final token = await SecureStorageService.getAccessToken();

        if (token != null) {
          opts.headers['Authorization'] = token;

          try {
            final dioClient = dio.Dio();
            final response = await dioClient.fetch(opts);
            return handler.resolve(response);
          } on dio.DioException catch (e) {
            if (e.response?.statusCode == 401) {
              logout();
              return;
            }
            return super.onError(err, handler);
          }
        } else {
          logout();
          return;
        }
      } catch (e) {
        logout();
        return;
      }
    }
    super.onError(err, handler);
  }
}
