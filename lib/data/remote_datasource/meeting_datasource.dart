part of '../data.dart';

class MeetingDatasource {
  final ApiClient _apiClient = Get.find();

  void getAllLabels({
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = false,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        "/v1/CalenderManager/MeetingLabelManager",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    if (withLoading) AppLoading.dismissLoading();
  }

  void create({
    required final MeetingParams dto,
    required final Function(GenericResponse<MeetingReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/CalenderManager/Calender",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MeetingReadDto>.fromJson(response.data, fromMap: MeetingReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void update({
    required final int? id,
    required final MeetingParams dto,
    required final Function(GenericResponse<MeetingReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CalenderManager/Calender/$id",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<MeetingReadDto>.fromJson(response.data, fromMap: MeetingReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void delete({
    required final int? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CalenderManager/Calender/$id",
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
}
