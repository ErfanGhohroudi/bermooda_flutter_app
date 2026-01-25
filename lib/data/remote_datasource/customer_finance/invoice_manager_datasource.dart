part of '../../data.dart';

class InvoiceManagerDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get list of invoices for a customer
  void getInvoicesByCustomer({
    required final int customerId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InvoiceManager",
        queryParameters: {"customer_id": customerId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceReadDto>.fromJson(response.data, fromMap: InvoiceReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Get invoice by ID
  void getInvoiceById({
    required final int invoiceId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InvoiceManager/$invoiceId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceReadDto>.fromJson(response.data, fromMap: InvoiceReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Create new invoice
  void createInvoice({
    required final Map<String, dynamic> data,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = true,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/InvoiceManager",
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceReadDto>.fromJson(response.data, fromMap: InvoiceReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    if (withLoading) AppLoading.dismissLoading();
  }
}
