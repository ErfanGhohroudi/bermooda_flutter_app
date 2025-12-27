part of '../../data.dart';

class CustomerStatusReasonDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String? crmCategoryId,
    required final String title,
    required final CustomerStatus type,
    required final LabelColors color,
    required final Function(GenericResponse<StatusReasonReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/StatusCategoryManager/",
        data: {
          "title": title,
          "group_crm_id": crmCategoryId,
          "category_type": type.name,
          "color_code": color.colorCode,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<StatusReasonReadDto>.fromJson(response.data, fromMap: StatusReasonReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void update({
    required final String? slug,
    required final String title,
    required final LabelColors color,
    required final Function(GenericResponse<StatusReasonReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/StatusCategoryManager/$slug/",
        data: {
          "title": title,
          "color_code": color.colorCode,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<StatusReasonReadDto>.fromJson(response.data, fromMap: StatusReasonReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
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
        "/v1/CrmManager/StatusCategoryManager/$slug/",
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

  void getAllReasons({
    required final String? crmCategoryId,
    required final CustomerStatus type,
    required final Function(GenericResponse<StatusReasonReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/StatusCategoryManager",
        queryParameters: {
          "group_crm_id": crmCategoryId,
          "category_type": type.name,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<StatusReasonReadDto>.fromJson(response.data, fromMap: StatusReasonReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
