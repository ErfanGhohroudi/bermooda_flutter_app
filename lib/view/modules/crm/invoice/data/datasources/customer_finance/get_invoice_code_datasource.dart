import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../../../data/api_client.dart';
import '../../../../../../../data/data.dart';

class GetInvoiceCodeDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get suggested invoice code
  void getInvoiceCode({
    required final Function(String? response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CustomerFinance/GetInvoiceCode",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final data = response.data["data"];
        final String? invoiceCode = data?["invoice_code"];
        onResponse(invoiceCode);
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
