part of '../../data.dart';

class CustomerDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final CustomerParams dto,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = false,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/CustomerUserView",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    if (withLoading) AppLoading.dismissLoading();
  }

  void update({
    required final int? id,
    required final CustomerParams dto,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/CustomerUserView/$id",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void delete({
    required final int? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmManager/CustomerUserView/$id",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getCustomer({
    required final int? customerId,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/CustomerUserView/$customerId",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void changeCustomerSection({
    required final int? customerId,
    required final int? labelId,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/ChangeCustomerLabel/$customerId",
        data: {"label_id": labelId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void changeCustomerStatus({
    required final int? customerId,
    required final CustomerStatusParams dto,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/CustomerStatusManager/$customerId",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void changeCustomerStep({
    required final int? customerId,
    required final int? step,
    required final Function(GenericResponse<CustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/ChangeCustomerStep/$customerId",
        data: {"step": step},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CustomerReadDto>.fromJson(response.data, fromMap: CustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
