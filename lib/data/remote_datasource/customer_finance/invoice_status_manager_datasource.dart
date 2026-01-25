part of '../../data.dart';

class InvoiceStatusManagerDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get invoice statuses by group CRM ID
  void getStatusesByGroupCrm({
    required final int groupCrmId,
    required final Function(GenericResponse<InvoiceStatusReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InvoiceStatusManager",
        queryParameters: {"group_crm_id": groupCrmId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceStatusReadDto>.fromJson(response.data, fromMap: InvoiceStatusReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Get invoice status by ID
  void getStatusById({
    required final int statusId,
    required final Function(GenericResponse<InvoiceStatusReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InvoiceStatusManager/$statusId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceStatusReadDto>.fromJson(response.data, fromMap: InvoiceStatusReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Create new invoice status
  void createStatus({
    required final Map<String, dynamic> data,
    required final Function(GenericResponse<InvoiceStatusReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/InvoiceStatusManager",
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceStatusReadDto>.fromJson(response.data, fromMap: InvoiceStatusReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Update invoice status
  void updateStatus({
    required final int statusId,
    required final Map<String, dynamic> data,
    required final Function(GenericResponse<InvoiceStatusReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CustomerFinance/InvoiceStatusManager/$statusId",
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceStatusReadDto>.fromJson(response.data, fromMap: InvoiceStatusReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Delete invoice status
  void deleteStatus({
    required final int statusId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CustomerFinance/InvoiceStatusManager/$statusId",
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
    AppLoading.dismissLoading();
  }
}
