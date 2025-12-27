part of '../../data.dart';

class CrmDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void create({
    required final int? avatarId,
    required final String title,
    required final List<UserReadDto> users,
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/GroupCrmManager",
        data: {
          "workspace_id": core.currentWorkspace.value.id,
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "members": users.map((final e) {
            if (e.id != '') return e.id.toInt();
          }).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void update({
    required final String? id,
    required final int? avatarId,
    required final String title,
    required final List<UserReadDto> users,
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/GroupCrmManager/$id",
        data: {
          "workspace_id": core.currentWorkspace.value.id,
          "title": title,
          if (avatarId != null) "avatar_id": avatarId,
          "members": users.map((final e) {
            if (e.id != '') return e.id.toInt();
          }).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void delete({
    required final String? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmManager/GroupCrmManager/$id",
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

  void getAllGroups({
    final int pageNumber = 1,
    final bool isPaginate = true,
    final String? query,
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GroupCrmManager",
        queryParameters: {
          "is_paginate": isPaginate,
          "page": pageNumber,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAllGroupsForRequests({
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GetGroupCrmRequests",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAllBoardSectionsAndCustomers({
    required final String crmCategoryId,
    required final Function(GenericResponse<CrmSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GetBoardCustomer",
        queryParameters: {"group_crm_id": crmCategoryId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmSectionReadDto>.fromJson(response.data, fromMap: CrmSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void updateOrders({
    required final List<CrmCategoryReadDto> categories,
    required final Function(GenericResponse<CrmCategoryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/UpdateGroupCrmOrder",
        data: {
          "ordered_group_ids": categories.map((final e) => e.id?.toInt()).whereType<int>().toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CrmCategoryReadDto>.fromJson(response.data, fromMap: CrmCategoryReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getAllCurrencies({
    required final Function(GenericResponse<CurrencyUnitReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/GetCurrencies",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CurrencyUnitReadDto>.fromJson(response.data, fromMap: CurrencyUnitReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
