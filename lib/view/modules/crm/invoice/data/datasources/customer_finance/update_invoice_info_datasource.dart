import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../../../core/loading/loading.dart';
import '../../../../../../../data/api_client.dart';
import '../../../../../../../data/data.dart';
import '../../models/invoice_params.dart';

class UpdateInvoiceInfoDatasource {
  final ApiClient _apiClient = Get.find();

  /// Update invoice information for customer and workspace
  void updateInvoiceInfo({
    required final int customerId,
    required final UpdateInvoiceInfoParams params,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = true,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CustomerFinance/UpdateInvoiceInfo/$customerId",
        data: params.toMap(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    if (withLoading) AppLoading.dismissLoading();
  }
}
