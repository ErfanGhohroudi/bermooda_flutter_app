part of '../../data.dart';

class ProjectDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void create({
    required final int? avatarId,
    required final String title,
    required final List<UserReadDto> users,
    required final String? startDate,
    required final String? dueDate,
    required final String? budget,
    // required final CurrencyUnitReadDto? currency,
    required final Function(GenericResponse<ProjectReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ProjectManager/ProjectManager",
        data: {
          "workspace_id": core.currentWorkspace.value.id,
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "users": users.map((final e) {
            if (e.id != '') return e.id.toInt();
          }).toList(),
          "start_date": startDate,
          "due_date": dueDate,
          "cost": budget?.numericOnly().toInt() ?? 0,
          // "currency_slug": currency?.slug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectReadDto>.fromJson(response.data, fromMap: ProjectReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? id,
    required final int? avatarId,
    required final String title,
    required final List<UserReadDto> users,
    required final String? startDate,
    required final String? dueDate,
    required final String? budget,
    // required final CurrencyUnitReadDto? currency,
    required final Function(GenericResponse<ProjectReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ProjectManager/ProjectManager/$id",
        data: {
          "workspace_id": core.currentWorkspace.value.id,
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "users": users.map((final e) {
            if (e.id != '') return e.id.toInt();
          }).toList(),
          "start_date": startDate,
          "due_date": dueDate,
          "cost": budget?.numericOnly().toInt() ?? 0,
          // "currency_slug": currency?.slug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectReadDto>.fromJson(response.data, fromMap: ProjectReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void delete({
    required final String? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ProjectManager/ProjectManager/$id",
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

  void createSection({
    required final String? projectId,
    required final String title,
    required final String colorCode,
    required final int? iconId,
    required final Function(GenericResponse<ProjectSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ProjectManager/CategoryProjectManager",
        data: {
          "project_id": projectId,
          "title": title,
          "color_code": colorCode,
          if (iconId != null) "icon_id": iconId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectSectionReadDto>.fromJson(response.data, fromMap: ProjectSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void updateSection({
    required final int? id,
    required final String title,
    required final String colorCode,
    required final int? iconId,
    required final Function(GenericResponse<ProjectSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ProjectManager/CategoryProjectManager/$id",
        data: {
          "title": title,
          "color_code": colorCode,
          if (iconId != null) "icon_id": iconId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectSectionReadDto>.fromJson(response.data, fromMap: ProjectSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void deleteSection({
    required final int? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ProjectManager/CategoryProjectManager/$id",
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

  void getSections({
    required final String projectId,
    required final Function(GenericResponse<ProjectSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/CategoryProjectManager",
        queryParameters: {"project_id": projectId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectSectionReadDto>.fromJson(response.data, fromMap: ProjectSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAllProjects({
    required final int pageNumber,
    final String? query,
    required final Function(GenericResponse<ProjectReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final int perPageCount = 20,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/ProjectManager",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectReadDto>.fromJson(response.data, fromMap: ProjectReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAllBoardIcons({
    required final Function(GenericResponse<MainFileReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/GetCategoryIcon",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MainFileReadDto>.fromJson(response.data, fromMap: MainFileReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAllBoardSectionsAndTasks({
    required final String projectId,
    required final Function(GenericResponse<ProjectSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ProjectManager/GetBoardTask",
        queryParameters: {"project_id": projectId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectSectionReadDto>.fromJson(response.data, fromMap: ProjectSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateOrders({
    required final List<ProjectReadDto> projects,
    required final Function(GenericResponse<ProjectReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ProjectManager/UpdateProjectsOrder",
        data: {
          "ordered_project_ids": projects.map((final e) => e.id?.toInt()).whereType<int>().toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectReadDto>.fromJson(response.data, fromMap: ProjectReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
