part of '../../data.dart';

class CustomerExelImportDatasource {
  final ApiClient _apiClient = Get.find();

  void confirmMapping({
    required final String? tempFileId,
    required final List<ExelColumn> exelColumns,
    required final Function(GenericResponse<ExelMappingResultReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/import/confirm-mapping/",
        data: {
          "temp_file_id": tempFileId,
          "column_mappings": exelColumns.map((final e) => e.toMap()).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ExelMappingResultReadDto>.fromJson(response.data, fromMap: ExelMappingResultReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void executeImport({
    required final String? tempFileId,
    required final String? categoryId,
    required final List<ExelColumn> exelColumns,
    required final Function(GenericResponse<ExelResultReadDto> response) onResponse,
    required final Function(dio.Response<dynamic> response, GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmManager/import/execute/",
        data: {
          "temp_file_id": tempFileId,
          "group_crm_id": categoryId,
          "deduplication_strategy": "skip",
          "import_to_customers": false,
          "column_mappings": exelColumns.map((final e) => e.toMap()).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<ExelResultReadDto>.fromJson(response.data, fromMap: ExelResultReadDto.fromMap));
      } else {
        onError(response, GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch (e) {
      if (e.response != null) {
        onError(e.response!, GenericResponse<dynamic>.fromJson(e.response!.data));
      }
    }
    AppLoading.dismissLoading();
  }
}
