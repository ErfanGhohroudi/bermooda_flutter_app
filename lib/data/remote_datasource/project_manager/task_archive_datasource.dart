part of '../../data.dart';

class TaskArchiveDatasource {
  final ApiClient _apiClient = Get.find();

  void getAllTasks({
    required final String projectId,
    required final int pageNumber,
    required final ProjectArchiveFilter filter,
    final int perPageCount = 20,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/TaskArchiveManager",
        queryParameters: {
          "page_number": pageNumber,
          "project_id": projectId,
          "per_page_count": perPageCount,
          "status": filter.name,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<TaskReadDto>.fromJson(response.data, fromMap: TaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getATask({
    required final int? taskId,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/TaskArchiveManager/$taskId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<TaskReadDto>.fromJson(response.data, fromMap: TaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void restoreATask({
    required final int? taskId,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ProjectManager/TaskArchiveManager/$taskId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<TaskReadDto>.fromJson(response.data, fromMap: TaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
