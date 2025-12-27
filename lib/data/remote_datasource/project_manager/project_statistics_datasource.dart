part of '../../data.dart';

class ProjectStatisticsDatasource {
  final ApiClient _apiClient = Get.find();

  void getUsersSummaries({
    required final String? projectId,
    required final int pageNumber,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    final String? query,
    final int perPageCount = 20,
    required final Function(GenericResponse<ProjectUserStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/ProjectSummery",
        queryParameters: {
          "project_id": projectId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          "time_period": timePeriodFilter.name,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<ProjectUserStatisticsSummary>.fromJson(response.data, fromMap: ProjectUserStatisticsSummary.fromMap),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getSummaries({
    required final String? projectId,
    required final StatisticsTimePeriodFilter timePeriodFilter,
    required final Function(GenericResponse<ProjectStatisticsSummary> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/ProjectSummery/$projectId",
        queryParameters: {"time_period": timePeriodFilter.name},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<ProjectStatisticsSummary>.fromJson(response.data, fromMap: ProjectStatisticsSummary.fromMap),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
