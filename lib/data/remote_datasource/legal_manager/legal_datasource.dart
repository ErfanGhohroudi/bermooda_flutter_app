part of '../../data.dart';

class LegalDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void create({
    required final int? avatarId,
    required final String title,
    required final List<int> memberIdList,
    required final Function(GenericResponse<LegalDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractBoard/",
        data: {
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "members": memberIdList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalDepartmentReadDto>.fromJson(response.data, fromMap: LegalDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? id,
    required final MainFileReadDto? avatar,
    required final String title,
    required final List<int> memberIdList,
    required final Function(GenericResponse<LegalDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      Map<String, dynamic>? avatarData() {
        if (avatar == null) {
          /// if don't have avatar
          return {'avatar_id': null};
        } else if (avatar.fileId != null) {
          /// if avatar changed
          return {'avatar_id': avatar.fileId};
        }

        /// if avatar not changed
        return null;
      }

      final response = await _apiClient.put(
        "/v1/ContractBoard/ContractBoard/$id/",
        data: {
          "workspace_id": core.currentWorkspace.value.id,
          "title": title,
          ...?avatarData(),
          "members": memberIdList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalDepartmentReadDto>.fromJson(response.data, fromMap: LegalDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
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
        "/v1/ContractBoard/ContractBoard/$id/",
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
    final int pageNumber = 1,
    final String? query,
    final int perPageCount = 20,
    required final Function(GenericResponse<LegalDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/ContractBoard/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalDepartmentReadDto>.fromJson(response.data, fromMap: LegalDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateOrders({
    required final List<LegalDepartmentReadDto> departments,
    required final Function(GenericResponse<LegalDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractBoard/Update/Order",
        data: {
          "ordered_bord_ids": departments.map((final e) => e.id?.toInt()).whereType<int>().toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalDepartmentReadDto>.fromJson(response.data, fromMap: LegalDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
