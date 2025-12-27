part of '../data.dart';

class CalendarDatasource {
  final ApiClient _apiClient = Get.find();

  Future<void> getAllDays({
    required final int year, // Jalali
    required final int month, // Jalali
    required final Function(GenericResponse<CalendarReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CalenderManager/Calender",
        queryParameters: {
          "year": year,
          "month": month,
          "command": "get_all_days",
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CalendarReadDto>.fromJson(response.data, fromMap: CalendarReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  Future<void> getADay({
    required final String year, // DateTime().year
    required final String month, // DateTime().month
    required final String day, // DateTime().day
    required final Function(GenericResponse<EventsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CalenderManager/Calender",
        queryParameters: {
          "specific_date": "$year/$month/$day",
          "command": "get_a_day",
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<EventsReadDto>.fromJson(response.data, fromMap: EventsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
