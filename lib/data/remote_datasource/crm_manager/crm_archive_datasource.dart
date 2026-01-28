part of '../../data.dart';

class CrmArchiveDatasource {
  final ApiClient _apiClient = Get.find();

  void getAllCustomers({
    required final String categoryId,
    required final int pageNumber,
    required final bool isFollowed,
    final int perPageCount = 20,
    final String? query,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/CustomerUserView",
        queryParameters: {
          "group_crm_id": categoryId,
          "page_number": pageNumber,
          "is_followed": isFollowed,
          "per_age_count": perPageCount,
          "is_deleted": true,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void restoreCustomer({
    required final int id,
    required final String categoryId,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/CustomerArchive/$id",
        data: {"group_crm_id": categoryId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getArchivedCategories({
    final int pageNumber = 1,
    final bool isPaginate = true,
    final String? query,
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GroupCrmManager/Archives",
        queryParameters: {
          "is_paginate": isPaginate,
          "page": pageNumber,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void restoreCategory({
    required final String? categoryId,
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/GroupCrmManager/Restore/$categoryId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
