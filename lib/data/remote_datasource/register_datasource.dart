part of '../data.dart';

class RegisterDataSource {
  final ApiClient _apiClient = Get.find();

  void sendCode({
    required final String phoneNumber,
    required final Function(GenericResponse<dynamic> errorResponse) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/UserManager/SendOtpCode",
        data: {"phone_number": phoneNumber},
        skipRetry: !withRetry,
        skipAuth: true,
      );

      if (response.isOk) {
        onResponse(GenericResponse<dynamic>.fromJson(response.data));
      } else {
        if (response.statusCode == 429) {
          AppNavigator.snackbarRed(title: s.error, subtitle: response.data["message"] ?? '');
        }
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 429) {
        AppNavigator.snackbarRed(title: s.error, subtitle: e.response?.data["message"] ?? '');
      }
      onError(GenericResponse());
    }
  }

  void verifyPhoneNumber({
    required final String phoneNumber,
    required final String code,
    required final Function(GenericResponse<OTPReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/UserManager/VerifyOtpCode",
        data: {
          "phone_number": phoneNumber,
          "otp": code,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<OTPReadDto>.fromJson(response.data, fromMap: OTPReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void createUsernamePasswords({
    required final String accessToken,
    required final String fullName,
    required final String password,
    required final String confirmPassword,
    required final int? avatarId,
    required final Function(GenericResponse<LoginReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/UserManager/CreateUserDetail",
        data: {
          // "slug": accessToken,
          "fullname": fullName,
          "password": password,
          "confirm_password": confirmPassword,
          if (avatarId != null) "avatar_id": avatarId,
        },
        headers: {'Authorization': 'Bearer $accessToken'},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LoginReadDto>.fromJson(response.data, fromMap: LoginReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
