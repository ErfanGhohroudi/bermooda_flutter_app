part of '../data.dart';

class DashboardDatasource {
  final ApiClient _apiClient = Get.find();

  Future<void> getAllProjectSummery({
    required final int memberId,
    required final Function(GenericResponse<ProjectSummeryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HomePageManager/WorkSpaceSummery/GetAllProjectSummery/",
        queryParameters: {"member_id": memberId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ProjectSummeryReadDto>.fromJson(response.data, fromMap: ProjectSummeryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  Future<void> getAllCrmSummery({
    required final int memberId,
    required final Function(GenericResponse<CrmSummeryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HomePageManager/WorkSpaceSummery/GetAllCrmSummery/",
        queryParameters: {
          "member_id": memberId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmSummeryReadDto>.fromJson(response.data, fromMap: CrmSummeryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  Future<void> getOnlineUsers({
    required final Function(GenericResponse<OnlineUsersSummeryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HomePageManager/WorkSpaceSummery/GetOnlineUsers/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<OnlineUsersSummeryReadDto>.fromJson(response.data, fromMap: OnlineUsersSummeryReadDto.fromMap),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
