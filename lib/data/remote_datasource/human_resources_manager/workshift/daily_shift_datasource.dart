part of '../../../data.dart';

class DailyShiftDatasource {
  final ApiClient _apiClient = Get.find();

  void createBulk({
    required final String workshiftSlug,
    required final List<DailyShiftParams> days,

    /// Map<monthShiftSlug, List<DailyShiftReadDto>>
    required final Function(Map<String, List<DailyShiftReadDto>> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/DailyShiftMainManager/CreateOrUpdateMultipleMonths/",
        data: {
          "workshift_slug": workshiftSlug,
          "days": days.map((final day) => day.toMap()).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final Map<String, dynamic> rawData = response.data["data"];

        // Cleaner parsing using map.map
        final parsedMap = rawData.map(
          (final key, final list) => MapEntry(
            key,
            List<DailyShiftReadDto>.from(list?.map((final x) => DailyShiftReadDto.fromMap(x)) ?? []),
          ),
        );
        onResponse(parsedMap);
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  // void create({
  //   required final String dayDate, // YYYY-MM-DD
  //   required final String monthShiftSlug,
  //   final bool isHoliday = false,
  //   final bool isInMonth = true,
  //   final List<String>? shiftTypeSlugList,
  //   required final Function(GenericResponse<DailyShiftReadDto> response) onResponse,
  //   required final Function(GenericResponse<dynamic> errorResponse) onError,
  //   final bool withRetry = false,
  // }) async {
  //   try {
  //     final response = await _apiClient.post(
  //       "/v1/HumanResourcesManager/DailyShiftMainManager/",
  //       data: {
  //         "day_date": dayDate,
  //         "month_shift_slug": monthShiftSlug,
  //         "is_holiday": isHoliday,
  //         "is_in_month": isInMonth,
  //         if (shiftTypeSlugList != null) "shift_type_slug_list": shiftTypeSlugList,
  //       },
  //       skipRetry: !withRetry,
  //     );
  //
  //     if (response.isOk) {
  //       onResponse(GenericResponse<DailyShiftReadDto>.fromJson(response.data, fromMap: DailyShiftReadDto.fromMap));
  //     } else {
  //       onError(GenericResponse<dynamic>.fromJson(response.data));
  //     }
  //   } on dio.DioException {
  //     onError(GenericResponse());
  //   }
  // }

  // void getAll({
  //   required final String? monthShiftSlug,
  //   required final int pageNumber,
  //   final int perPageCount = 20,
  //   required final Function(GenericResponse<DailyShiftReadDto> response) onResponse,
  //   required final Function(GenericResponse<dynamic> errorResponse) onError,
  //   final bool withRetry = false,
  // }) async {
  //   try {
  //     final response = await _apiClient.get(
  //       "/v1/HumanResourcesManager/DailyShiftMainManager/",
  //       queryParameters: {
  //         "page_number": pageNumber,
  //         "per_page_count": perPageCount,
  //         if (monthShiftSlug != null) "month_shift_slug": monthShiftSlug,
  //       },
  //       skipRetry: !withRetry,
  //     );
  //
  //     if (response.isOk) {
  //       onResponse(GenericResponse<DailyShiftReadDto>.fromJson(response.data, fromMap: DailyShiftReadDto.fromMap));
  //     } else {
  //       onError(GenericResponse<dynamic>.fromJson(response.data));
  //     }
  //   } on dio.DioException {
  //     onError(GenericResponse());
  //   }
  // }

  // void update({
  //   required final String? slug,
  //   final String? dayDate,
  //   final bool? isHoliday,
  //   final bool? isInMonth,
  //   final List<String>? shiftTypeSlugList,
  //   required final Function(GenericResponse<DailyShiftReadDto> response) onResponse,
  //   required final Function(GenericResponse<dynamic> errorResponse) onError,
  //   final bool withRetry = false,
  // }) async {
  //   try {
  //     final response = await _apiClient.put(
  //       "/v1/HumanResourcesManager/DailyShiftMainManager/$slug/",
  //       data: {
  //         if (dayDate != null) "day_date": dayDate,
  //         if (isHoliday != null) "is_holiday": isHoliday,
  //         if (isInMonth != null) "is_in_month": isInMonth,
  //         if (shiftTypeSlugList != null) "shift_type_slug_list": shiftTypeSlugList,
  //       },
  //       skipRetry: !withRetry,
  //     );
  //
  //     if (response.isOk) {
  //       onResponse(GenericResponse<DailyShiftReadDto>.fromJson(response.data, fromMap: DailyShiftReadDto.fromMap));
  //     } else {
  //       onError(GenericResponse<dynamic>.fromJson(response.data));
  //     }
  //   } on dio.DioException {
  //     onError(GenericResponse());
  //   }
  // }
  //
  // void delete({
  //   required final String? slug,
  //   required final Function() onResponse,
  //   required final Function(GenericResponse<dynamic> errorResponse) onError,
  //   final bool withRetry = false,
  // }) async {
  //   AppLoading.showLoading();
  //   try {
  //     final response = await _apiClient.delete(
  //       "/v1/HumanResourcesManager/DailyShiftMainManager/$slug/",
  //       skipRetry: !withRetry,
  //     );
  //
  //     if (response.isOk) {
  //       onResponse();
  //     } else {
  //       onError(GenericResponse<dynamic>.fromJson(response.data));
  //     }
  //   } on dio.DioException {
  //     onError(GenericResponse());
  //   }
  //   AppLoading.dismissLoading();
  // }
}
