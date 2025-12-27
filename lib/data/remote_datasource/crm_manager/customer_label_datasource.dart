part of '../../data.dart';

class CustomerLabelDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String? crmCategoryId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/CategoryManager",
        data: {
          "title": title,
          "group_crm_id": crmCategoryId,
          "color_code": colorCode,
        },
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
  }

  void update({
    required final int? id,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/CategoryManager/$id",
        data: {
          "title": title,
          "color_code": colorCode,
        },
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
        "/v1/CrmManager/CategoryManager/$id",
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

  void getLabels({
    required final String? crmCategoryId,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/CategoryManager",
        queryParameters: {"group_crm_id": crmCategoryId},
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
  }
}
