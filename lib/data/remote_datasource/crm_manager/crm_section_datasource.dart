part of '../../data.dart';

class CrmSectionDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String? categoryId,
    required final String title,
    required final String? colorCode,
    required final int? iconId,
    required final List<String> stepList,
    required final Function(GenericResponse<CrmSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/LabelMangaer",
        data: {
          "group_crm_id": categoryId,
          "title": title,
          if (iconId != null) "icon_id": iconId,
          "color": colorCode,
          "step_list": stepList,
        },
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

  void update({
    required final int? id,
    required final String? categoryId,
    required final String title,
    required final String? colorCode,
    required final int? iconId,
    required final List<String> stepList,
    required final Function(GenericResponse<CrmSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CrmManager/LabelMangaer/$id",
        data: {
          "group_crm_id": categoryId,
          "title": title,
          if (iconId != null) "icon_id": iconId,
          "color": colorCode,
          "step_list": stepList,
        },
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

  void delete({
    required final int? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmManager/LabelMangaer/$id",
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

  void getSections({
    required final String categoryId,
    required final Function(GenericResponse<CrmSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmManager/LabelMangaer",
        queryParameters: {"group_id": categoryId},
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
}
