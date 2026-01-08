part of '../../../data.dart';

class ShiftTypeDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String departmentSlug,
    required final ShiftTypeParams dto,
    required final Function(GenericResponse<ShiftTypeReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/ShiftTypeManager/",
        data: {
          'folder_slug': departmentSlug,
          ...dto.toMap(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ShiftTypeReadDto>.fromJson(response.data, fromMap: ShiftTypeReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAll({
    required final String? folderSlug,
    required final int pageNumber,
    final int perPageCount = 20,
    required final Function(GenericResponse<ShiftTypeReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/ShiftTypeManager/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (folderSlug != null) "folder_slug": folderSlug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ShiftTypeReadDto>.fromJson(response.data, fromMap: ShiftTypeReadDto.fromMap));
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
        "/v1/HumanResourcesManager/ShiftTypeManager/$slug/",
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

  void deleteFromDays({
    required final String? slug,
    required final String workshiftSlug,
    required final Jalali startDate,
    required final Jalali endDate,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/HumanResourcesManager/ShiftTypeManager/$slug/BulkDelete/",
        data: {
          "workshift_slug": workshiftSlug,
          "start_date": startDate.toDateTime().toIso8601String(),
          "end_date": endDate.toDateTime().toIso8601String(),
        },
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
