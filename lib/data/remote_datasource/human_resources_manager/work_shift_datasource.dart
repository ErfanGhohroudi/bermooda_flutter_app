part of '../../data.dart';

class WorkShiftDatasource {
  final ApiClient _apiClient = Get.find();
  final Core core = Get.find();

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

  void getWorkShift({
    required final String? slug,
    required final Function(GenericResponse<WorkShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/WorkShiftMainManager/$slug/",
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

  void create({
    required final String title,
    required final String departmentSlug,
    final int? allowedOvertimeHoursNumber,
    final int? allowedLeaveHoursNumber,
    final int? allowedMissionHoursNumber,
    final int? allowedLeaveEarlyHoursNumber,
    final int? allowedOverdueHoursNumber,
    required final Function(GenericResponse<WorkShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/WorkShiftMainManager/",
        data: {
          "title": title,
          "folder_slug": departmentSlug,
          "creator_id": core.userReadDto.value.id,
          if (allowedOvertimeHoursNumber != null) "allowed_overtime_hours_number": allowedOvertimeHoursNumber,
          if (allowedLeaveHoursNumber != null) "allowed_leave_hours_number": allowedLeaveHoursNumber,
          if (allowedMissionHoursNumber != null) "allowed_mission_hours_number": allowedMissionHoursNumber,
          if (allowedLeaveEarlyHoursNumber != null) "allowed_leave_early_hours_number": allowedLeaveEarlyHoursNumber,
          if (allowedOverdueHoursNumber != null) "allowed_overdue_hours_number": allowedOverdueHoursNumber,
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

  void update({
    required final String? slug,
    required final String title,
    final int? allowedOvertimeHoursNumber,
    final int? allowedLeaveHoursNumber,
    final int? allowedMissionHoursNumber,
    final int? allowedLeaveEarlyHoursNumber,
    final int? allowedOverdueHoursNumber,
    required final Function(GenericResponse<WorkShiftReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/HumanResourcesManager/WorkShiftMainManager/$slug/",
        data: {
          "title": title,
          if (allowedOvertimeHoursNumber != null) "allowed_overtime_hours_number": allowedOvertimeHoursNumber,
          if (allowedLeaveHoursNumber != null) "allowed_leave_hours_number": allowedLeaveHoursNumber,
          if (allowedMissionHoursNumber != null) "allowed_mission_hours_number": allowedMissionHoursNumber,
          if (allowedLeaveEarlyHoursNumber != null) "allowed_leave_early_hours_number": allowedLeaveEarlyHoursNumber,
          if (allowedOverdueHoursNumber != null) "allowed_overdue_hours_number": allowedOverdueHoursNumber,
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

  void delete({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/HumanResourcesManager/WorkShiftMainManager/$slug/",
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
