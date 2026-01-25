part of '../../data.dart';

class InstallmentDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get installments by invoice ID
  void getInstallmentsByInvoice({
    required final int invoiceId,
    required final Function(GenericResponse<Installment> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InstallMentView",
        queryParameters: {"invoice_id": invoiceId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<Installment>.fromJson(response.data, fromMap: (final json) => Installment.fromJson(json as Map<String, dynamic>)));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Get installment by ID
  void getInstallmentById({
    required final int installmentId,
    required final Function(GenericResponse<Installment> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InstallMentView/$installmentId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<Installment>.fromJson(response.data, fromMap: (final json) => Installment.fromJson(json as Map<String, dynamic>)));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Pay installments
  void payInstallments({
    required final Map<String, dynamic> data,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/InstallMentView",
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<dynamic>.fromJson(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
