import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../../../core/loading/loading.dart';
import '../../../../../../../data/api_client.dart';
import '../../../../../../../data/data.dart';
import '../../models/invoice.dart';
import '../../models/pay_invoice_params.dart';

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
    required final PayInvoiceParams data,
    required final Function( GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/Invoice/$invoiceMainId/customer-payment",
        data: data.toMap(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final res = GenericResponse<InvoiceReadDto>.fromJson(response.data, fromMap: InvoiceReadDto.fromMap);
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
    required final String? reason,
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
          if (reason != null && reason.isNotEmpty) "description": reason,
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
