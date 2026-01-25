part of '../../data.dart';

class WarehouseDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get list of warehouses
  void getWarehouses({
    required final int page,
    final String? search,
    required final Function(GenericResponse<WarehouseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/wareHouse/getWareHouse',
        queryParameters: {
          'page': page,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<WarehouseReadDto>.fromJson(response.data, fromMap: WarehouseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Get warehouse by ID
  void getWarehouseById({
    required final int warehouseId,
    required final Function(GenericResponse<WarehouseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/wareHouse/getWareHouseById/$warehouseId',
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<WarehouseReadDto>.fromJson(response.data, fromMap: WarehouseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Create new warehouse
  void createWarehouse({
    required final Map<String, dynamic> data,
    required final Function(GenericResponse<WarehouseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = true,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        '/v1/wareHouse/storeWareHouse',
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<WarehouseReadDto>.fromJson(response.data, fromMap: WarehouseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    if (withLoading) AppLoading.dismissLoading();
  }

  /// Update warehouse
  void updateWarehouse({
    required final int warehouseId,
    required final Map<String, dynamic> data,
    required final Function(GenericResponse<WarehouseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
    final bool withLoading = true,
  }) async {
    if (withLoading) AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        '/v1/wareHouse/updateWareHouse/$warehouseId',
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<WarehouseReadDto>.fromJson(response.data, fromMap: WarehouseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    if (withLoading) AppLoading.dismissLoading();
  }

  /// Delete warehouse
  void deleteWarehouse({
    required final int warehouseId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        '/v1/wareHouse/deleteWareHouse/$warehouseId',
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
    AppLoading.dismissLoading();
  }

  /// Update warehouse orders
  void updateOrders({
    required final List<int> warehouseIds,
    required final Function(GenericResponse<WarehouseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        '/v1/wareHouse/updateWareHouseOrder',
        data: {
          'ordered_warehouse_ids': warehouseIds,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<WarehouseReadDto>.fromJson(response.data, fromMap: WarehouseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
