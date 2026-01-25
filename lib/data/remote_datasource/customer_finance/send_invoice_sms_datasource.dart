part of '../../data.dart';

class SendInvoiceSmsDatasource {
  final ApiClient _apiClient = Get.find();

  /// Send invoice link via SMS
  void sendInvoiceSms({
    required final int invoiceId,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/SendInvoiceSms/$invoiceId",
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
