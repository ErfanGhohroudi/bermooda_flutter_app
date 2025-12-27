part of '../../data.dart';

class CustomersBankDatasource {
  final ApiClient _apiClient = Get.find();

  void delete({
    required final int? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmManager/CustomerDocumentManager/$id",
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

  void deleteImportedCustomers({
    required final List<int> selectedCustomerIds,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmManager/CustomerBankManager/400/",
        data: {"customer_ids": selectedCustomerIds},
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

  void sendToBoard({
    required final String categoryId,
    required final List<int> selectedCustomerIds,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/SendCustomerToTheBoard",
        data: {
          "group_crm_id": categoryId,
          "customer_bank_id_list": selectedCustomerIds,
        },
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

  void getAllDocuments({
    required final String categoryId,
    // required final int pageNumber,
    // final int perPageCount = 20,
    // final String? query,
    required final Function(GenericResponse<CustomersBankDocument> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/CustomerDocumentManager",
        queryParameters: {
          "group_crm_id": categoryId,
          // "page_number": pageNumber,
          // "per_page_count": perPageCount,
          // if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomersBankDocument>.fromJson(response.data, fromMap: CustomersBankDocument.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAllDocumentCustomers({
    required final String categoryId,
    required final int? documentId,
    required final int pageNumber,
    final int perPageCount = 20,
    final String? query,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/CustomerBankManager/",
        queryParameters: {
          "group_crm_id": categoryId,
          "document_id": documentId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
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
}
