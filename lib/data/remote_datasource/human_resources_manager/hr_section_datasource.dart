part of '../../data.dart';

class HrSectionDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String departmentSlug,
    required final String title,
    required final String colorCode,
    required final int? iconId,
    required final Function(GenericResponse<HRSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/FolderCategoryManager/",
        data: {
          "folder_slug": departmentSlug,
          "title": title,
          "color_code": colorCode,
          if (iconId != null) "icon_id": iconId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRSectionReadDto>.fromJson(response.data, fromMap: HRSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? slug,
    required final String title,
    required final String colorCode,
    required final int? iconId,
    required final Function(GenericResponse<HRSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/HumanResourcesManager/FolderCategoryManager/$slug/",
        data: {
          "title": title,
          "color_code": colorCode,
          if (iconId != null) "icon_id": iconId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRSectionReadDto>.fromJson(response.data, fromMap: HRSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void delete({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/HumanResourcesManager/FolderCategoryManager/$slug/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
