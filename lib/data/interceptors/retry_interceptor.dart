import 'package:bermooda_business/core/loading/loading.dart';
import 'package:bermooda_business/data/api_client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../core/core.dart';
import '../../core/navigator/navigator.dart';
import '../retry_dialog_service.dart';

/// Interceptor برای نمایش retry dialog در صورت خطا
class RetryInterceptor extends dio.Interceptor {
  final dio.Dio dioInstance;

  RetryInterceptor(this.dioInstance);

  @override
  void onError(final dio.DioException err, final dio.ErrorInterceptorHandler handler) async {
    // چک کردن skipRetry flag
    final skipRetry = err.requestOptions.extra['skipRetry'] == true;

    // برای خطاهای (200 - 400 - 403 - 429)، retry dialog نمایش داده نمی‌شود
    if (err.response.isBadRequest || err.response.isOk || err.response.isForbidden || err.response.isTooManyRequest) {
      if (AppLoading.isLoadingShow()) {
        AppLoading.dismissLoading();
      }
      AppNavigator.snackbarRed(title: s.error, subtitle: err.response!.data["message"].toString());
      handler.next(err);
      return;
    }

    // اگر skipRetry فعال باشد یا response 400 یا 200 باشد، retry dialog نمایش داده نمی‌شود
    if (skipRetry) {
      handler.next(err);
      return;
    }

    if (AppLoading.isLoadingShow()) {
      AppLoading.dismissLoading();
    }

    // تشخیص نوع خطا
    final isTimeOut = err.type == dio.DioExceptionType.connectionTimeout ||
        err.type == dio.DioExceptionType.receiveTimeout ||
        err.type == dio.DioExceptionType.sendTimeout ||
        err.type == dio.DioExceptionType.connectionError;

    // ساخت retry callback که request را دوباره اجرا می‌کند
    Future<void> retryCallback() async {
      try {
        // اجرای مجدد request با همان options
        final response = await dioInstance.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        // اگر retry هم خطا داد، خطا را به handler پاس می‌دهیم
        if (e is dio.DioException) {
          handler.next(e);
        } else {
          handler.next(err);
        }
      }
    }

    // نمایش retry dialog
    RetryDialogService().show(
      retryCallback: retryCallback,
      isTimeOut: isTimeOut,
      response: err.response,
    );

    // خطا را به handler پاس نمی‌دهیم چون منتظر retry هستیم
    // handler.next(err);
  }
}

