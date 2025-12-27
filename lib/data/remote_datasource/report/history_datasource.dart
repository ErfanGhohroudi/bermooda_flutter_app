part of '../../data.dart';

abstract class BaseHistoryDatasource implements IReportDatasource {
  final ApiClient _apiClient = Get.find();

  // ✅ متدهای getAllUrl و createUrl و createBody باید توسط کلاس‌های فرزند پیاده‌سازی شوند
  String getAllUrl({required final int? id, required final int pageNumber, required final ReportType filter, final int perPageCount = 20});

  String createUrl({required final IReportParams params});

  Map<String, dynamic> createBody({required final int? id, required final IReportParams params});

  @override
  Future<void> getAllReports({
    required final int? sourceId,
    required final int pageNumber,
    required final ReportType filter,
    required final Function(GenericResponse<IReportReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        getAllUrl(id: sourceId, pageNumber: pageNumber, filter: filter),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IReportReadDto>.fromJson(response.data, fromMap: IReportReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  @override
  Future<void> create({
    required final int? sourceId,
    required final IReportParams params,
    required final Function(GenericResponse<IReportReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        createUrl(params: params),
        data: createBody(id: sourceId, params: params),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IReportReadDto>.fromJson(response.data, fromMap: IReportReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
