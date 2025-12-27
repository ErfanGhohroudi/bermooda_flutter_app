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
    } on dio.DioException catch(e) {
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
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
