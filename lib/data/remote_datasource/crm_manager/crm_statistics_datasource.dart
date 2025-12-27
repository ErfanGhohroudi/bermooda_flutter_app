part of '../../data.dart';

class CRMStatisticsDatasource {
  final ApiClient _apiClient = Get.find();

  void getUsersSummaries({
    required final String? categoryId,
    required final int pageNumber,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    final String? query,
    final int perPageCount = 20,
    required final Function(GenericResponse<CrmUserStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GetGroupCrmSummery/$categoryId",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          "time_period": timePeriodFilter.name,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmUserStatisticsSummary>.fromJson(response.data, fromMap: CrmUserStatisticsSummary.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getSummaries({
    required final String? categoryId,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    required final Function(GenericResponse<CrmStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GetGroupCrmTotalSummery/$categoryId",
        queryParameters: {"time_period": timePeriodFilter.name},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmStatisticsSummary>.fromJson(response.data, fromMap: CrmStatisticsSummary.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
