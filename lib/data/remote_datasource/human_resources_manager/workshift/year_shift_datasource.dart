part of '../../../data.dart';

class YearShiftDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final int year,
    required final String workshiftSlug,
    final Map<String, dynamic>? customData,
    final bool isMonth = false,
    final List<Map<String, dynamic>>? monthList,
    required final Function(GenericResponse<YearShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/YearShiftMainManager/",
        data: {
          "year": year,
          "workshift_slug": workshiftSlug,
          if (customData != null) "custom_data": customData,
          if (isMonth) "is_month": isMonth,
          if (monthList != null) "month_list": monthList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<YearShiftReadDto>.fromJson(response.data, fromMap: YearShiftReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAll({
    required final String? workshiftSlug,
    required final int pageNumber,
    final int perPageCount = 20,
    required final Function(GenericResponse<YearShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/YearShiftMainManager/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (workshiftSlug != null) "workshift_slug": workshiftSlug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<YearShiftReadDto>.fromJson(response.data, fromMap: YearShiftReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? slug,
    final int? year,
    final Map<String, dynamic>? customData,
    required final Function(GenericResponse<YearShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/HumanResourcesManager/YearShiftMainManager/$slug/",
        data: {
          if (year != null) "year": year,
          if (customData != null) "custom_data": customData,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<YearShiftReadDto>.fromJson(response.data, fromMap: YearShiftReadDto.fromMap));
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
        "/v1/HumanResourcesManager/YearShiftMainManager/$slug/",
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

