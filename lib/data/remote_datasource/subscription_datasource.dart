part of '../data.dart';

class SubscriptionDatasource {
  final ApiClient _apiClient = Get.find();

  /// Get available modules
  void getAvailableModules({
    required final String workspaceId,
    required final Function(GenericResponse<ModuleReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/PayManager/ModulePlanManager/",
        queryParameters: {
          "workspace_id": workspaceId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ModuleReadDto>.fromJson(response.data, fromMap: ModuleReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Calculate subscription price for Payment
  void calculateSubscriptionPrice({
    required final String workspaceId,
    required final SubscriptionPeriod? period,
    required final List<ModuleReadDto> modules,
    required final int usersCount,
    required final int storage,
    required final int? maxContractCount,
    final String discountCode = '',
    final bool goToBank = false,
    required final Function(GenericResponse<SubscriptionPriceReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/PayManager/SubPaymentManager/PrepareSubInvoice/",
        data: {
          "workspace_id": workspaceId,
          "module_slug_list": modules.map((final e) => e.slug).toList(),
          "max_member": usersCount, // count
          "max_volume": storage, // GB
          if (maxContractCount != null) "max_contract_count": maxContractCount, // count
          if (goToBank) "request_type": "go_to_bank",
          "period": period?.days,
          if (discountCode.trim() != '') "discount_code": discountCode,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubscriptionPriceReadDto>.fromJson(response.data, fromMap: SubscriptionPriceReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  // Get subscription information for a workspace
  void getCurrentSubscription({
    required final String workspaceId,
    required final Function(GenericResponse<SubscriptionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/PayManager/SubPaymentManager/GetCurrentSub/",
        queryParameters: {"workspace_id": workspaceId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubscriptionReadDto>.fromJson(response.data, fromMap: SubscriptionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Get Bermooda Bank info
  void getBankInfo({
    required final Function(GenericResponse<BankAccountInfoReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/PayManager/GetPriceConfig",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<BankAccountInfoReadDto>.fromJson(response.data, fromMap: BankAccountInfoReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Renew subscription
  // void renewSubscription({
  //   required final String workspaceId,
  //   required final String period,
  //   required final Function(GenericResponse<SubscriptionReadDto> response) onResponse,
  //   required final Function(GenericResponse<dynamic> errorResponse) onError,
  //   final bool withRetry = false,
  // }) async {
  //   try {
  //     final response = await _apiClient.post(
  //       "/api/workspace/$workspaceId/subscription/renew/",
  //       data: {'period': period},
  //       skipRetry: !withRetry,
  //     );
  //
  //     if (response.isOk) {
  //       onResponse(GenericResponse<SubscriptionReadDto>.fromJson(response.data, fromMap: SubscriptionReadDto.fromMap));
  //     } else {
  //       onError(GenericResponse<dynamic>.fromJson(response.data));
  //     }
  //   } on dio.DioException catch(e) {
  //     onError(GenericResponse());
  //   }
  // }
}
