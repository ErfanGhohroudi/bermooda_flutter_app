part of '../../data.dart';

class LegalStatisticsDatasource {
  final ApiClient _apiClient = Get.find();

  void getSummary({
    required final String boardId,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    required final Function(GenericResponse<LegalStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/statistics/$boardId/summary/",
        queryParameters: {
          "time_period": timePeriodFilter.name,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalStatisticsSummary>.fromJson(
          response.data,
          fromMap: LegalStatisticsSummary.fromMap,
        ));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getUsersStatistics({
    required final String boardId,
    required final int pageNumber,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    final String? query,
    final int perPageCount = 20,
    required final Function(GenericResponse<LegalUserStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/statistics/$boardId/users/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          "time_period": timePeriodFilter.name,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalUserStatisticsSummary>.fromJson(
          response.data,
          fromMap: LegalUserStatisticsSummary.fromMap,
        ));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}

