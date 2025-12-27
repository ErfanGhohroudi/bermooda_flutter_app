part of '../data.dart';

class DropdownDatasource {
  final ApiClient _apiClient = Get.find();

  void getIndustrials({
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/WorkSpace/GetIndustrialActivity",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getStudyCategories({
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/WorkSpace/GetStudyCategory",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAllCountry({
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/UserManager/get_all_country",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAllState({
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/UserManager/get_all_state",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getCitiesByStateId({
    required final int? stateId,
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/UserManager/get_all_city_per_state/$stateId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
