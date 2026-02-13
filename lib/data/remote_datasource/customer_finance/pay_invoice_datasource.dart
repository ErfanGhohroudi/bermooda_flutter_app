part of '../../data.dart';

class PayInvoiceDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get payment information for invoice
  void getPaymentInfo({
    required final int invoiceId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/PayTheInvoiceManager/$invoiceId",
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

  /// Pay invoice (cash payment)
  void payInvoice({
    required final String invoiceMainId,
    required final Map<String, dynamic> data,
    required final Function( GenericResponse<PaymentRecord> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/Invoice/$invoiceMainId/customer-payment",
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final res = GenericResponse<PaymentRecord>.fromJson(response.data, fromMap: PaymentRecord.fromJson);
        onResponse(res);
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Suspend invoice
  void suspendInvoice({
    required final int invoiceId,
    required final String reason,
    required final int? documentId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CustomerFinance/Invoice/$invoiceId/suspend",
        data: {
          "reason": reason,
          if (documentId != null) "document_id": documentId,
        },
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
    AppLoading.dismissLoading();
  }

  /// Payment verification : if invoice is installments; [installmentId] is Required.
  void paymentVerification({
    required final int recordId,
    required final bool verify,
    required final String reason,
    required final int? installmentId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/UnifiedPaymentVerification",
        data: {
          "record_id": recordId,
          "action": verify ? 'verify' : 'reject',
          "description": reason,
          // اگه فاکتور به صورت قسطی باشه این اجباریه به غیر از این نیاز به ارسال نیست
          if (installmentId != null) "installment_id": installmentId,
        },
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
    AppLoading.dismissLoading();
  }
}
