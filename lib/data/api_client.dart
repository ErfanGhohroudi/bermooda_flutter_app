import 'package:dio/dio.dart' as dio;
import '../app_config.dart';
import 'interceptors/log_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// API Client جامع با پشتیبانی از تمام انواع HTTP requests و TokenInterceptor
class ApiClient {
  late final dio.Dio _dio;
  final String baseUrl;

  ApiClient({final String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.instance.baseUrl {
    _dio = dio.Dio();
    _dio.options.baseUrl = this.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    // _dio.options.sendTimeout = const Duration(hours: 1);

    // add token to header and handle unauthorized error.
    _dio.interceptors.add(AuthInterceptor());

    // اضافه کردن LogInterceptor برای pretty logging
    _dio.interceptors.add(LogInterceptor());

    // اضافه کردن RetryInterceptor برای نمایش retry dialog در صورت خطا
    _dio.interceptors.add(RetryInterceptor(_dio));
  }

  /// GET request
  Future<dio.Response<T>> get<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ProgressCallback? onReceiveProgress,
    final dio.ResponseType? responseType,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: opts,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST request
  Future<dio.Response<T>> post<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ProgressCallback? onSendProgress,
    final dio.ProgressCallback? onReceiveProgress,
    final dio.ResponseType? responseType,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: opts,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT request
  Future<dio.Response<T>> put<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ProgressCallback? onSendProgress,
    final dio.ProgressCallback? onReceiveProgress,
    final dio.ResponseType? responseType,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: opts,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PATCH request
  Future<dio.Response<T>> patch<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ProgressCallback? onSendProgress,
    final dio.ProgressCallback? onReceiveProgress,
    final dio.ResponseType? responseType,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: opts,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// DELETE request
  Future<dio.Response<T>> delete<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ResponseType? responseType,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: opts,
      cancelToken: cancelToken,
    );
  }

  /// Download file
  Future<dio.Response> download(
    final String urlPath,
    final String savePath, {
    final dio.ProgressCallback? onReceiveProgress,
    final Map<String, dynamic>? queryParameters,
    final dio.CancelToken? cancelToken,
    final bool deleteOnError = true,
    final String lengthHeader = dio.Headers.contentLengthHeader,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.ResponseType responseType = dio.ResponseType.stream,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      options: opts,
    );
  }

  /// Upload file with FormData
  Future<dio.Response<T>> uploadFile<T>(
    final String path,
    final dio.FormData formData, {
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ProgressCallback? onSendProgress,
    final dio.ProgressCallback? onReceiveProgress,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    // تنظیم sendTimeout به 1 ساعت برای آپلود فایل‌های بزرگ
    final uploadOptions = opts.copyWith(
      sendTimeout: opts.sendTimeout ?? const Duration(hours: 1),
    );
    return await _dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: uploadOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Request با متد دلخواه
  Future<dio.Response<T>> request<T>(
    final String path, {
    required final String method,
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Map<String, dynamic>? headers,
    final dio.Options? options,
    final dio.CancelToken? cancelToken,
    final dio.ProgressCallback? onSendProgress,
    final dio.ProgressCallback? onReceiveProgress,
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) async {
    final opts = _mergeOptions(options, headers, skipAuth: skipAuth, skipRetry: skipRetry);
    return await _dio.request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: opts.copyWith(method: method),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// ادغام options و headers
  dio.Options _mergeOptions(
    final dio.Options? options,
    final Map<String, dynamic>? headers, {
    final bool skipAuth = false,
    final bool skipRetry = false,
  }) {
    final mergedHeaders = <String, dynamic>{};

    if (options?.headers != null) {
      mergedHeaders.addAll(options!.headers!);
    }

    if (headers != null) {
      mergedHeaders.addAll(headers);
    }

    final mergedExtra = <String, dynamic>{};
    if (options?.extra != null) {
      mergedExtra.addAll(options!.extra!);
    }

    mergedExtra['skipAuth'] = skipAuth;
    mergedExtra['skipRetry'] = skipRetry;

    return (options ?? dio.Options()).copyWith(
      headers: mergedHeaders.isEmpty ? null : mergedHeaders,
      extra: mergedExtra.isEmpty ? null : mergedExtra,
    );
  }

  /// دریافت Dio instance (برای استفاده‌های پیشرفته)
  dio.Dio get dioInstance => _dio;

  /// تنظیم timeout
  void setTimeout({
    final Duration? connectTimeout,
    final Duration? receiveTimeout,
    final Duration? sendTimeout,
  }) {
    if (connectTimeout != null) {
      _dio.options.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      _dio.options.receiveTimeout = receiveTimeout;
    }
    if (sendTimeout != null) {
      _dio.options.sendTimeout = sendTimeout;
    }
  }

  /// تنظیم baseUrl
  void setBaseUrl(final String? newBaseUrl) {
    if (newBaseUrl != null) {
      _dio.options.baseUrl = newBaseUrl;
    }
  }

  /// اضافه کردن interceptor سفارشی
  void addInterceptor(final dio.Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// حذف interceptor
  void removeInterceptor(final dio.Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  /// پاک کردن تمام interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
    // اضافه کردن مجدد AuthInterceptor، LogInterceptor و RetryInterceptor
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(RetryInterceptor(_dio));
  }
}

extension ResponseExtensions on dio.Response? {
  bool get connectionError => this?.statusCode == null;

  bool get isBadRequest => this?.statusCode == 400;

  bool get isUnauthorized => this?.statusCode == 401;

  bool get isForbidden => this?.statusCode == 403;

  bool get isNotFound => this?.statusCode == 404;

  bool get isTooManyRequest => this?.statusCode == 429;

  bool get isServerError => between(500, 599);

  bool between(final int begin, final int end) {
    return !connectionError && this!.statusCode! >= begin && this!.statusCode! <= end;
  }

  bool get isOk => between(200, 299);
}
