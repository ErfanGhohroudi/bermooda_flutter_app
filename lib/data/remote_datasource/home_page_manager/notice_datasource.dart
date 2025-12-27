part of '../../data.dart';

class NoticeDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String title,
    required final String description,
    required final String date,
    required final Function(GenericResponse<NoticeReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HomePageManager/NoticeManager/",
        data: {
          "title": title,
          "description": description,
          "notif_date_jalali": date,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<NoticeReadDto>.fromJson(response.data, fromMap: NoticeReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void update({
    required final String slug,
    required final String title,
    required final String description,
    required final String date,
    required final Function(GenericResponse<NoticeReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/HomePageManager/NoticeManager/$slug/",
        data: {
          "title": title,
          "description": description,
          "notif_date_jalali": date,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<NoticeReadDto>.fromJson(response.data, fromMap: NoticeReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void delete({
    required final String slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/HomePageManager/NoticeManager/$slug/",
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
    AppLoading.dismissLoading();
  }

  void getNotices({
    required final Function(GenericResponse<NoticeReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HomePageManager/NoticeManager/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<NoticeReadDto>.fromJson(response.data, fromMap: NoticeReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
