part of '../data.dart';

class WorkspaceDatasource {
  WorkspaceDatasource();

  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  Future<void> create({
    required final String title,
    required final Function(GenericResponse<WorkspaceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        '/v1/UserManager/CreateWorkSpace',
        data: {"title": title},
        skipRetry: !withRetry,
      );
      onResponse(GenericResponse<WorkspaceReadDto>.fromJson(response.data, fromMap: WorkspaceReadDto.fromMap));
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
  }

  Future<void> update({
    required final String id,
    required final WorkspaceInfoParams dto,
    required final Function(GenericResponse<WorkspaceInfoReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        '/v1/WorkSpace/WorkSpaceManager/$id',
        data: dto.toJson(),
        skipRetry: !withRetry,
      );
      onResponse(GenericResponse<WorkspaceInfoReadDto>.fromJson(response.data, fromMap: WorkspaceInfoReadDto.fromMap));
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
  }

  Future<void> updateRequiredInfo({
    required final String id,
    required final IWorkspaceRequiredInfoParams dto,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      await _apiClient.post(
        '/v1/WorkSpace/UpdateRequiredInfo/$id',
        data: dto.toJson(),
        skipRetry: !withRetry,
      );
      onResponse();
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
  }

  Future<void> getAllWorkspace({
    required final Function(GenericResponse<WorkspaceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = false,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        '/v1/UserManager/GetWorkSpaces',
        skipRetry: !withRetry,
      );
      onResponse(GenericResponse<WorkspaceReadDto>.fromJson(response.data, fromMap: WorkspaceReadDto.fromMap));
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
    if (withLoading) AppLoading.dismissLoading();
  }

  Future<void> getAllWorkspaceWithInfo({
    required final Function(List<WorkspaceInfoReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/WorkSpace/WorkSpaceManager',
        queryParameters: {"workspace_id": core.currentWorkspace.value.id},
        skipRetry: !withRetry,
      );
      onResponse(
        response.data == null
            ? []
            : List<WorkspaceInfoReadDto>.from(response.data!.map((final x) => WorkspaceInfoReadDto.fromMap(x))),
      );
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
  }

  Future<void> changeCurrentWorkspace({
    required final String id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      await _apiClient.put(
        '/v1/UserManager/ChangeCurrentWorkspace',
        data: {"workspace_id": id},
        skipRetry: !withRetry,
      );
      onResponse();
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
    AppLoading.dismissLoading();
  }

  Future<void> acceptWorkspaceInvitation({
    required final bool isAccepted,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      await _apiClient.post(
        '/v1/WorkSpace/AcceptWorkspaceInvitation',
        data: {
          "is_accepted": isAccepted,
          "workspace_id": core.currentWorkspace.value.id,
        },
        skipRetry: !withRetry,
      );
      onResponse();
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
    AppLoading.dismissLoading();
  }

  Future<void> getTextInvite({
    required final Function(String text) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/WorkSpace/GetTextInvite',
        skipRetry: !withRetry,
      );
      onResponse(response.data?["data"]?["text"] ?? '');
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
  }

  Future<void> delete({
    required final String id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      await _apiClient.delete(
        '/v1/WorkSpace/WorkSpaceManager/$id',
        skipRetry: !withRetry,
      );
      onResponse();
    } on dio.DioException catch (e) {
      onError(GenericResponse<dynamic>.fromJson(e.response?.data));
    }
    AppLoading.dismissLoading();
  }
}
