part of '../../data.dart';

enum MemberSourceType { project, crmCategory, legalDepartment }

class MemberDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void create({
    required final CreateMemberParams dto,
    required final Function(GenericResponse<MemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/WorkSpace/WorkSpaceMemberManger",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MemberReadDto>.fromJson(response.data, fromMap: MemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final int id,
    required final CreateMemberParams dto,
    required final Function(GenericResponse<MemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/WorkSpace/WorkSpaceMemberManger/$id",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MemberReadDto>.fromJson(response.data, fromMap: MemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void delete({
    required final int id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/WorkSpace/WorkSpaceMemberManger/$id",
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

  void getHrDepartmentMembers({
    required final String departmentSlug,
    required final int pageNumber,
    final int perPageCount = 20,
    final bool justDepartmentMembers = true,
    required final Function(GenericResponse<MemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/WorkSpace/WorkSpaceMemberManger",
        queryParameters: {
          "page_number": pageNumber,
          if (justDepartmentMembers) "folder_slug": departmentSlug,
          "per_page_count": perPageCount,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MemberReadDto>.fromJson(response.data, fromMap: MemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// ```dart
  /// if (departmentSlug != null)
  ///   "will get department removed members"
  /// else
  ///   "will get workspace removed members"
  /// ```
  void getAllWorkspaceRemovedMembers({
    required final int pageNumber,
    final int perPageCount = 20,
    final String? departmentSlug,
    final String? query,
    required final Function(GenericResponse<MemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/WorkSpace/WorkSpaceMemberArchive",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (departmentSlug != null) "folder_slug": departmentSlug,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MemberReadDto>.fromJson(response.data, fromMap: MemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAMember({
    required final int memberId,
    required final Function(GenericResponse<MemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        "/v1/WorkSpace/WorkSpaceMemberManger/$memberId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MemberReadDto>.fromJson(response.data, fromMap: MemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void restoreAMember({
    required final int? memberId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/WorkSpace/WorkSpaceMemberArchive/$memberId",
        data: {"member_id": memberId},
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

  void transferMember({
    required final int? memberId,
    required final String? departmentSlug,
    required final String? workShiftSlug,
    required final Function(GenericResponse<MemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/TransferMember/$memberId",
        data: {
          "dest_folder_slug": departmentSlug,
          if (workShiftSlug != null) "dest_workshift_slug": workShiftSlug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MemberReadDto>.fromJson(response.data, fromMap: MemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAllMembers({
    required final Function(GenericResponse<UserReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final PermissionName? perName,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/UserManager/GetUserInfo",
        queryParameters: perName != null ? {"permission_name": perName.value} : null,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<UserReadDto>.fromJson(response.data, fromMap: UserReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getSourceMembers({
    required final MemberSourceType sourceType,

    /// projectId , crmCategoryId or legalDepartmentId
    required final String? sourceId,
    required final Function(GenericResponse<UserReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final String mainUrl = switch (sourceType) {
        MemberSourceType.project => "/v1/ProjectManager/GetProjectUser/$sourceId",
        MemberSourceType.crmCategory => "/v1/CrmManager/GroupCrmMembers/$sourceId",
        MemberSourceType.legalDepartment => "/v1/ContractBoard/contract/board/$sourceId/users",
      };

      final response = await _apiClient.get(
        mainUrl,
        queryParameters: {"workspace_id": core.currentWorkspace.value.id},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<UserReadDto>.fromJson(response.data, fromMap: UserReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
