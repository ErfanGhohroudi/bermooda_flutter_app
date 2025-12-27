import 'package:dio/dio.dart' as dio;
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Interceptor برای pretty logging درخواست‌ها و پاسخ‌ها
class LogInterceptor extends dio.Interceptor {
  @override
  void onResponse(final dio.Response response, final dio.ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final method = response.requestOptions.method.toUpperCase();
      final url = '${response.requestOptions.baseUrl}${response.requestOptions.path}';
      final queryParams = response.requestOptions.queryParameters;
      final bodyParams = response.requestOptions.data;
      final statusCode = response.statusCode ?? 0;
      final statusMessage = response.statusMessage ?? '';

      final headers = response.headers.map.toString();

      String body = '';
      if (response.data != null) {
        if (response.data is Map || response.data is List) {
          try {
            body = response.data.toString();
          } catch (e) {
            body = '[Unable to stringify response]';
          }
        } else {
          body = response.data.toString();
        }
      }

      final statusEmoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';

      developer.log(
        '═══════════════════════════════════════════════════════════\n'
        '📥 RESPONSE $statusEmoji\n'
        '═══════════════════════════════════════════════════════════\n'
        '$method $url\n'
        'QUERY PARAMS: $queryParams\n'
        'BODY PARAMS: $bodyParams\n'
        'STATUS: $statusCode $statusMessage\n'
        'HEADERS:\n$headers\n'
        '${body.isNotEmpty ? "BODY:\n$body\n" : ""}'
        '═══════════════════════════════════════════════════════════',
      );
    }
    handler.resolve(response);
  }

  @override
  void onError(final dio.DioException err, final dio.ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final method = err.requestOptions.method.toUpperCase();
      final url = '${err.requestOptions.baseUrl}${err.requestOptions.path}';
      final queryParams = err.requestOptions.queryParameters;
      final bodyParams = err.requestOptions.data;
      final statusCode = err.response?.statusCode ?? 0;
      final statusMessage = err.response?.statusMessage ?? err.message ?? '';
      final headers = err.response?.headers.map.toString();

      String errorBody = '';
      if (err.response?.data != null) {
        if (err.response!.data is Map || err.response!.data is List) {
          try {
            errorBody = err.response!.data.toString();
          } catch (e) {
            errorBody = '[Unable to stringify error response]';
          }
        } else {
          errorBody = err.response!.data.toString();
        }
      }

      developer.log(
        '═══════════════════════════════════════════════════════════\n'
        '⚠️ ERROR\n'
        '═══════════════════════════════════════════════════════════\n'
        '$method $url\n'
        'QUERY PARAMS: $queryParams\n'
        'BODY PARAMS: $bodyParams\n'
        'STATUS: $statusCode $statusMessage\n'
        'HEADERS:\n$headers\n'
        'ERROR TYPE: ${err.type}\n'
        '${errorBody.isNotEmpty ? "ERROR BODY:\n$errorBody\n" : ""}'
        'STACK TRACE:\n${err.stackTrace}\n'
        '═══════════════════════════════════════════════════════════',
      );
    }
    handler.next(err);
  }
}
