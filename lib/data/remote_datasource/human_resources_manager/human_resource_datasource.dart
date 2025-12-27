part of '../../data.dart';

class HumanResourceDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String title,
    required final int? avatarId,
    required final List<int> memberIdList,
    required final Function(GenericResponse<HRDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/FolderManager",
        data: {
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "member_id_list": memberIdList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRDepartmentReadDto>.fromJson(response.data, fromMap: HRDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? slug,
    required final String title,
    required final int? avatarId,
    required final List<int> memberIdList,
    required final Function(GenericResponse<HRDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/HumanResourcesManager/FolderManager/$slug",
        data: {
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "member_id_list": memberIdList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRDepartmentReadDto>.fromJson(response.data, fromMap: HRDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void delete({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/HumanResourcesManager/FolderManager/$slug",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getAllDepartments({
    required final int pageNumber,
    final String? query,
    required final Function(GenericResponse<HRDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/FolderManager",
        queryParameters: {
          "page_number": pageNumber,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRDepartmentReadDto>.fromJson(response.data, fromMap: HRDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAllDepartmentsForDropdown({
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/FolderViewSet",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateOrders({
    required final List<HRDepartmentReadDto> departments,
    required final Function(GenericResponse<HRDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/UpdateFolderOrder",
        data: {
          "ordered_folder_ids": departments.map((final e) => e.id?.toInt()).whereType<int>().toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<HRDepartmentReadDto>.fromJson(response.data, fromMap: HRDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
