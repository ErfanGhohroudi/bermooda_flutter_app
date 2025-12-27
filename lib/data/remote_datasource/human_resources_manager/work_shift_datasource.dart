part of '../../data.dart';

class WorkShiftDatasource {
  final ApiClient _apiClient = Get.find();

  void getAllWorkShifts({
    required final String? slug,
    required final int pageNumber,
    final int perPageCount = 20,
    required final Function(GenericResponse<WorkShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/WorkShiftMainManager/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          "folder_slug": slug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<WorkShiftReadDto>.fromJson(response.data, fromMap: WorkShiftReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getAllWorkShiftsForDropdown({
    required final String? slug,
    required final Function(GenericResponse<DropdownItemReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/GetWorkShiftSmall",
        queryParameters: {"folder_slug": slug},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<DropdownItemReadDto>.fromJson(response.data, fromMap: DropdownItemReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
