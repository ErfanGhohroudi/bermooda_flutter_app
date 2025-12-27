part of '../data.dart';

class UpdateDatasource {
  final ApiClient _apiClient = Get.find();

  void getAppUpdate({
    required final Function(GenericResponse<AppUpdateReadDto> response) onResponse,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/Core/AppUpdateDetail",
        skipAuth: true,
      );

      if (response.isOk) {
        onResponse(GenericResponse<AppUpdateReadDto>.fromJson(response.data, fromMap: AppUpdateReadDto.fromMap));
      }
    } on dio.DioException catch(e) {
      return;
    }
  }
}
