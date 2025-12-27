part of '../data.dart';

class UserDatasource {
  final ApiClient _apiClient = Get.find();

  void getUserData({
    required final Function(GenericResponse<UserReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = false,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        "/v1/UserManager/GetUserData",
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
    if (withLoading) AppLoading.dismissLoading();
  }

  Future<void> changeCurrentPassword({
    required final String currentPassword,
    required final String newPassword,
    required final String confirmNewPassword,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/UserManager/Change/UserProfilePassword",
        data: {
          "current_password": currentPassword,
          "password": newPassword,
          "confirm_password": confirmNewPassword,
        },
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
  }

  Future<void> changeFullNameAndAvatar({
    required final int? avatarId,
    required final String fullName,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/UserManager/Change/Username",
        data: {
          "fullname": fullName,
          if (avatarId != null) "avatar_id": avatarId,
        },
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
  }
}
