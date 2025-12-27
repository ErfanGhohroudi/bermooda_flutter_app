part of '../../data.dart';

class TaskDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final TaskParams dto,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withLoading = false,
    final bool withRetry = false,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ProjectManager/MainTaskManager",
        data: dto.toJson(),
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
    if (withLoading) AppLoading.dismissLoading();
  }

  void update({
    required final int? taskId,
    required final TaskParams dto,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ProjectManager/MainTaskManager/$taskId",
        data: dto.toJson(),
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

  void delete({
    required final int? taskId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ProjectManager/MainTaskManager/$taskId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getATask({
    required final int? taskId,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/MainTaskManager/$taskId",
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

  void changeTaskProject({
    required final int? taskId,
    required final String projectId,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ProjectManager/TaskSettingViewSet/$taskId/ChangeTaskProject/",
        data: {"target_project_id": projectId},
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
    AppLoading.dismissLoading();
  }

  void changeTaskStatusToDone({
    required final int? taskId,
    required final Function(GenericResponse<TaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ProjectManagerExtra/CheckATask/$taskId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<TaskReadDto>.fromJson(response.data, fromMap: TaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
