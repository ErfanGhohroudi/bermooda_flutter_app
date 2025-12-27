part of '../../data.dart';

class HRStatisticsDatasource {
  final ApiClient _apiClient = Get.find();

  void getOverallSummaries({
    required final String slug,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    required final Function(GenericResponse<HrStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/FolderTotalSummery/$slug",
        queryParameters: {"time_period": timePeriodFilter.name},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HrStatisticsSummary>.fromJson(response.data, fromMap: HrStatisticsSummary.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getUserSummaries({
    required final String slug,
    required final int pageNumber,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    final String? query,
    final int perPageCount = 20,
    required final Function(GenericResponse<HRUserStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/FolderSummery/$slug",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          "time_period": timePeriodFilter.name,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRUserStatisticsSummary>.fromJson(response.data, fromMap: HRUserStatisticsSummary.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
