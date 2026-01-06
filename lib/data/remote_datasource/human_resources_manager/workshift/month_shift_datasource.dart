part of '../../../data.dart';

class MonthShiftDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final int monthNumber,
    required final String yearShiftSlug,
    final String? leaveDuration,
    final String? activityDuration,
    final List<Map<String, dynamic>>? dayList,
    required final Function(GenericResponse<MonthShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/MonthShiftMainManager/",
        data: {
          "month_number": monthNumber,
          "year_shift_slug": yearShiftSlug,
          if (leaveDuration != null) "leave_duration": leaveDuration,
          if (activityDuration != null) "activity_duration": activityDuration,
          if (dayList != null) "day_list": dayList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MonthShiftReadDto>.fromJson(response.data, fromMap: MonthShiftReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAll({
    required final String? yearShiftSlug,
    required final int pageNumber,
    final int perPageCount = 20,
    required final Function(GenericResponse<MonthShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/MonthShiftMainManager/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (yearShiftSlug != null) "year_shift_slug": yearShiftSlug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MonthShiftReadDto>.fromJson(response.data, fromMap: MonthShiftReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? slug,
    final int? monthNumber,
    final String? leaveDuration,
    final String? activityDuration,
    required final Function(GenericResponse<MonthShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/HumanResourcesManager/MonthShiftMainManager/$slug/",
        data: {
          if (monthNumber != null) "month_number": monthNumber,
          if (leaveDuration != null) "leave_duration": leaveDuration,
          if (activityDuration != null) "activity_duration": activityDuration,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MonthShiftReadDto>.fromJson(response.data, fromMap: MonthShiftReadDto.fromMap));
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
        "/v1/HumanResourcesManager/MonthShiftMainManager/$slug/",
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

