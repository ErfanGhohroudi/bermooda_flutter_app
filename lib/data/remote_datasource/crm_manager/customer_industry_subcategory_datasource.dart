part of '../../data.dart';

class CustomerIndustrySubCategoryDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String? crmCategoryId,
    required final String title,
    required final int? industryId,
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/IndustrialSubCategoryManager/",
        data: {
          "title": title,
          "group_crm_id": crmCategoryId,
          "industrial_activity_id": industryId,
        },
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

  void update({
    required final int? id,
    required final String title,
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/IndustrialSubCategoryManager/$id/",
        data: {"title": title},
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

  void delete({
    required final int? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmManager/IndustrialSubCategoryManager/$id/",
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

  void getCategories({
    required final String? crmCategoryId,
    required final int? industryId,
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/IndustrialSubCategoryManager/",
        queryParameters: {
          "group_crm_id": crmCategoryId,
          "industrial_activity_id": industryId,
        },
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
