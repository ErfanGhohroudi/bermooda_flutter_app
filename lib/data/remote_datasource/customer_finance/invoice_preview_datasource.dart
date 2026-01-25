part of '../../data.dart';

class InvoicePreviewDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get invoice preview by main ID (public link)
  void getInvoicePreview({
    required final String mainId,
    required final Function(GenericResponse<InvoiceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/InvoicePreview/$mainId",
        skipRetry: !withRetry,
        skipAuth: true, // Public endpoint
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
}
