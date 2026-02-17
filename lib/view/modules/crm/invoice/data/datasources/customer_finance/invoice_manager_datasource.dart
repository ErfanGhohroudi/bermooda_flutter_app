import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../../../core/loading/loading.dart';
import '../../../../../../../data/api_client.dart';
import '../../../../../../../data/data.dart';
import '../../models/invoice.dart';
import '../../models/invoice_buyer_seller_info.dart';
import '../../models/invoice_params.dart';

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

  /// Get invoice buyer and seller information
  void getInvoiceInfo({
    required final int customerId,
    required final Function(GenericResponse<InvoiceBuyerSellerInfo> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/GetInvoiceInfo/$customerId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceBuyerSellerInfo>.fromJson(response.data, fromMap: InvoiceBuyerSellerInfo.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Create new invoice
  void createInvoice({
    required final InvoiceParams params,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = true,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/InvoiceManager",
        data: params.toMap(),
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
