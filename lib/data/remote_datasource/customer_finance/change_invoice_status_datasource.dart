part of '../../data.dart';

class ChangeInvoiceStatusDatasource {
  final ApiClient _apiClient = Get.find();

  /// Change invoice status
  void changeInvoiceStatus({
    required final int invoiceId,
    required final int statusId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CustomerFinance/ChangeInvoiceStatus/$invoiceId",
        data: {"status_id": statusId},
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
