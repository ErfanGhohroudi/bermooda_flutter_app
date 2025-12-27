part of '../../data.dart';

class AttendanceDatasource {
  final ApiClient _apiClient = Get.find();

  void checkInOut({
    required final CheckInOutParams dto,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      String getMethod() {
        switch (dto.type) {
          case AttendanceModalType.check_in:
            return "CheckIn";
          case AttendanceModalType.check_out:
            return "CheckOut";
        }
      }

      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/SmartAttendance/${getMethod()}",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<dynamic>.fromJson(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getAttendances({
    required final int? memberId,
    required final Jalali date,
    required final Function(GenericResponse<MemberAttendanceSummaryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final dateDateTime = date.toDateTime().toCompactIso8601 ?? '';

      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/SmartAttendance/MemberSummery",
        queryParameters: {
          "member_id": memberId,
          "start_date": dateDateTime,
          "end_date": dateDateTime,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<MemberAttendanceSummaryReadDto>.fromJson(
            response.data,
            fromMap: MemberAttendanceSummaryReadDto.fromMap,
          ),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getUserTimesheet({
    required final Jalali date,
    required final Function(GenericResponse<TimesheetReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/MemberSummaryOverView/GetAMemberActivity/",
        queryParameters: {
          "year": date.year,
          "month": date.month,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<TimesheetReadDto>.fromJson(response.data, fromMap: TimesheetReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void checkShiftStatus({
    required final Function(ShiftStatusReadDto response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/SmartAttendance/CheckShiftStatus",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(ShiftStatusReadDto.fromMap(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getMemberMonthlyAttendanceStats({
    required final int? memberId,
    required final Jalali month,
    required final Function(GenericResponse<MemberAttendanceSummaryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final dateRange = _getMonthDateRange(month);

      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/SmartAttendance/MemberSummery",
        queryParameters: {
          "member_id": memberId,
          "start_date": dateRange.startDate,
          "end_date": dateRange.endDate,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<MemberAttendanceSummaryReadDto>.fromJson(
            response.data,
            fromMap: MemberAttendanceSummaryReadDto.fromMap,
          ),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getMonthlyAttendanceStats({
    required final String departmentSlug,
    required final Jalali month,
    required final Function(GenericResponse<MemberAttendanceSummaryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final dateRange = _getMonthDateRange(month);

      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/SmartAttendance/FolderSummery",
        queryParameters: {
          "folder_slug": departmentSlug,
          "start_date": dateRange.startDate,
          "end_date": dateRange.endDate,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<MemberAttendanceSummaryReadDto>.fromJson(
            response.data,
            fromMap: MemberAttendanceSummaryReadDto.fromMap,
          ),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getOverallAttendanceStatsSummary({
    required final String departmentSlug,
    required final Jalali month,
    required final Function(GenericResponse<AttendanceStatisticsSummaryReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final dateRange = _getMonthDateRange(month);

      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/AttendanceStatisticsSummary",
        queryParameters: {
          "folder_slug": departmentSlug,
          "start_date": dateRange.startDate,
          "end_date": dateRange.endDate,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<AttendanceStatisticsSummaryReadDto>.fromJson(
            response.data,
            fromMap: AttendanceStatisticsSummaryReadDto.fromMap,
          ),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  _MonthDateRange _getMonthDateRange(final Jalali month) {
    final firstDay = month.withDay(1);
    final lastDay = month.withDay(month.monthLength);

    final startDateTime = firstDay.toDateTime();
    final endDateTime = lastDay.toDateTime();

    return _MonthDateRange(
      startDate: startDateTime.toCompactIso8601 ?? '',
      endDate: endDateTime.toCompactIso8601 ?? '',
    );
  }
}

class _MonthDateRange {
  _MonthDateRange({
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;
}
