import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../../../data/api_client.dart';
import '../../../../../../../data/data.dart';
import '../mappers/order_model_mapper.dart';
import '../models/order_interface.dart';

class CustomerOrderDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get list of invoices and contracts for a customer
  void getOrdersByCustomer({
    required final int customerId,
    required final Function(GenericResponse<IOrderModel> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManagerExtra/CustomerTransAction/$customerId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IOrderModel>.fromJson(response.data, fromMap: OrderModelMapper.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
