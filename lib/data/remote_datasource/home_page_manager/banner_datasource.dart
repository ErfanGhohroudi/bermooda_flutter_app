part of '../../data.dart';

class BannerDatasource {
  final ApiClient _apiClient = Get.find();

  void getBanners({
    required final Function(GenericResponse<BannerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HomePageManager/SliderManger/",
        skipRetry: !withRetry,
        skipAuth: true,
      );

      if (response.isOk) {
        onResponse(GenericResponse<BannerReadDto>.fromJson(response.data, fromMap: BannerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
