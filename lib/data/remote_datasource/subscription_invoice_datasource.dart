part of '../data.dart';

class SubscriptionInvoiceDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get Payment Invoice Details
  void getPaymentInvoiceDetails({
    required final String invoiceCode,
    required final Function(GenericResponse<SubscriptionInvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        "/v1/PayManager/PaymentInvoiceDetail",
        queryParameters: {"invoice_code": invoiceCode},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubscriptionInvoiceReadDto>.fromJson(response.data, fromMap: SubscriptionInvoiceReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Get All Payment Invoices
  void getAllInvoices({
    required final String workspaceId,
    required final int pageNumber,
    final int perPageCount = 20,
    required final Function(GenericResponse<SubscriptionInvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final Function()? retryCallback,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/PayManager/InvoicePaymentManager/",
        queryParameters: {
          "workspace_id": workspaceId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubscriptionInvoiceReadDto>.fromJson(response.data, fromMap: SubscriptionInvoiceReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
