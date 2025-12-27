part of '../../data.dart';

abstract class BaseLabelDatasource implements ILabelDatasource {
  final ApiClient _apiClient = Get.find();

  // ✅ متدهای getAllUrl و createUrl و createBody باید توسط کلاس‌های فرزند پیاده‌سازی شوند
  String getAllUrl({required final String? sourceId});

  String createUrl();

  String updateUrl({required final String? slug});

  String deleteUrl({required final String? slug});

  Map<String, dynamic> createUpdateBody({required final String? sourceId, required final String title, required final String? colorCode});

  @override
  Future<void> getLabels({
    required final String? sourceId,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        getAllUrl(sourceId: sourceId),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  @override
  Future<void> createLabel({
    required final String sourceId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        createUrl(),
        data: createUpdateBody(sourceId: sourceId, title: title, colorCode: colorCode),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  @override
  Future<void> updateLabel({
    required final String? slug,
    required final String sourceId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        updateUrl(slug: slug),
        data: createUpdateBody(sourceId: sourceId, title: title, colorCode: colorCode),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  @override
  Future<void> deleteLabel({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        deleteUrl(slug: slug),
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
