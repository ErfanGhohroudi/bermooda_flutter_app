part of '../../data.dart';

class LegalSectionDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final String departmentId,
    required final String title,
    required final String colorCode,
    required final int? iconId,
    required final List<String> stepList,
    required final Function(GenericResponse<LegalSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/kanban/column/",
        data: {
          "board_id": departmentId,
          "title": title,
          "color": colorCode,
          if (iconId != null) "icon_id": iconId,
          "step_list": stepList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalSectionReadDto>.fromJson(response.data, fromMap: LegalSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final int? id,
    required final String title,
    required final String colorCode,
    // required final int? iconId,
    required final List<String> stepList,
    required final Function(GenericResponse<LegalSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ContractBoard/kanban/column/$id/",
        data: {
          "title": title,
          "color": colorCode,
          // if (iconId != null) "icon_id": iconId,
          "step_list": stepList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalSectionReadDto>.fromJson(response.data, fromMap: LegalSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
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
        "/v1/ContractBoard/kanban/column/$id/",
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
}
