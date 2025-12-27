part of '../data.dart';

class AccessTokenDatasource {
  final ApiClient _apiClient = Get.find();

  Future<bool> buildNewToken({
    final Function()? retryCallback,
  }) async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken() ?? '';

      final response = await _apiClient.post(
        '/api/token/refresh/',
        data: {
          "mode": "raw",
          "refresh": refreshToken,
        },
        skipAuth: true,
        skipRetry: true,
      );

      final String? newRefreshToken = response.data["refresh"] as String?;
      final String? accessToken = response.data["access"] as String?;

      /// save refresh token (this token use for refresh access token)
      if (newRefreshToken != null) {
        await SecureStorageService.saveRefreshToken(newRefreshToken);
      }

      /// save access token
      if (accessToken != null) {
        await SecureStorageService.saveAccessToken(accessToken);
      }

      return true;
    } on dio.DioException catch(e) {
      return false;
    }

    // final completer = Completer<bool>();
    //
    // httpRequest(
    //   httpMethod: EHttpMethod.post,
    //   clearHeader: true,
    //   url: "$baseUrl/api/token/refresh/",
    //   body: {
    //     "mode": "raw",
    //     "refresh": refreshToken,
    //   },
    //   encodeBody: false,
    //   action: (final response) async {
    //     final String? refreshToken = response.body["refresh"] as String?;
    //     final String? accessToken = response.body["access"] as String?;
    //
    //     /// save refresh token (this token use for refresh access token)
    //     if (refreshToken != null) {
    //       await SecureStorageService.saveRefreshToken(refreshToken);
    //     }
    //
    //     /// save access token
    //     if (accessToken != null) {
    //       await SecureStorageService.saveAccessToken(accessToken);
    //     }
    //
    //     return completer.complete(true);
    //   },
    //   error: (final Response<dynamic> response) {
    //     return completer.complete(false);
    //   },
    //   retryCallback: retryCallback,
    //   withLoading: false,
    // );
    //
    // return completer.future;
  }
}
