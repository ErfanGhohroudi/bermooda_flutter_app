part of '../data.dart';

class AddFcmDatasource {
  final ApiClient _apiClient = Get.find();

  Future<void> addFcmToken({
    required final String fcmToken,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/UserManager/Add/FcmToken",
        data: {
          "token": fcmToken,
          "is_application": true,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
