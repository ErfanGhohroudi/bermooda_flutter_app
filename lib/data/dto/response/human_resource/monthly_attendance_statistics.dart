part of '../../../data.dart';

class AttendanceStatisticsSummaryReadDto extends Equatable {
  const AttendanceStatisticsSummaryReadDto({
    this.totalMembersCount,
    this.presentCount,
    this.absentCount,
    this.missionsCount,
    this.totalMembersPercentage,
    this.presentPercentage,
    this.absentPercentage,
    this.missionsPercentage,
  });

  final int? totalMembersCount;
  final int? presentCount;
  final int? absentCount;
  final int? missionsCount;
  final double? totalMembersPercentage;
  final double? presentPercentage;
  final double? absentPercentage;
  final double? missionsPercentage;

  factory AttendanceStatisticsSummaryReadDto.fromJson(final String str) => AttendanceStatisticsSummaryReadDto.fromMap(jsonDecode(str));

  factory AttendanceStatisticsSummaryReadDto.fromMap(final Map<String, dynamic> json) => AttendanceStatisticsSummaryReadDto(
        totalMembersCount: json["total_members_count"],
        presentCount: json["present_count"],
        absentCount: json["absent_count"],
        missionsCount: json["missions_count"],
        totalMembersPercentage: (json["total_members_percentage"] as num?)?.toDouble(),
        presentPercentage: (json["present_percentage"] as num?)?.toDouble(),
        absentPercentage: (json["absent_percentage"] as num?)?.toDouble(),
        missionsPercentage: (json["missions_percentage"] as num?)?.toDouble(),
      );

  @override
  List<Object?> get props => [
        totalMembersCount,
        presentCount,
        absentCount,
        missionsCount,
        totalMembersPercentage,
        presentPercentage,
        absentPercentage,
        missionsPercentage,
      ];
}

class MemberAttendanceSummaryReadDto extends Equatable {
  const MemberAttendanceSummaryReadDto({
    this.id,
    this.fullname,
    this.firstName,
    this.lastName,
    this.avatar,
    this.attendanceData,
    this.workPerformanceSummary,
  });

  final int? id;
  final String? fullname;
  final String? firstName;
  final String? lastName;
  final MainFileReadDto? avatar;
  final List<DayAttendanceDataDto>? attendanceData;
  final WorkPerformanceSummary? workPerformanceSummary;

  factory MemberAttendanceSummaryReadDto.fromJson(final String str) => MemberAttendanceSummaryReadDto.fromMap(jsonDecode(str));

  factory MemberAttendanceSummaryReadDto.fromMap(final Map<String, dynamic> json) => MemberAttendanceSummaryReadDto(
      id: json["id"],
      fullname: json["fullname"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      avatar: json["avatar"] == null ? null : MainFileReadDto.fromMap(json["avatar"]),
      attendanceData: json["attendance_data"]?["daily_breakdown"] == null
          ? null
          : List<DayAttendanceDataDto>.from(
              json["attendance_data"]["daily_breakdown"].map((final x) => DayAttendanceDataDto.fromMap(x)),
            ),
      workPerformanceSummary:
          json["attendance_data"]?["work_performance_summary"] == null ? null : WorkPerformanceSummary.fromMap(json["attendance_data"]["work_performance_summary"]));

  @override
  List<Object?> get props => [id, fullname, firstName, lastName, avatar, attendanceData];
}

class DayAttendanceDataDto extends Equatable {
  const DayAttendanceDataDto({
    this.gregorianDate,
    this.jalaliDate,
    this.attendances,
    this.attendanceReports,
    this.requests,
    this.isAbsent,
  });

  final String? gregorianDate;
  final String? jalaliDate;
  final List<AttendanceDto>? attendances;
  final List<AttendanceReportDto>? attendanceReports;
  final List<IRequestReadDto>? requests;
  final bool? isAbsent;

  factory DayAttendanceDataDto.fromJson(final String str) => DayAttendanceDataDto.fromMap(jsonDecode(str));

  factory DayAttendanceDataDto.fromMap(final Map<String, dynamic> json) => DayAttendanceDataDto(
        gregorianDate: json["gregorian_date"],
        jalaliDate: json["jalali_date"],
        attendances: json["attendances"] == null ? null : List<AttendanceDto>.from(json["attendances"].map((final x) => AttendanceDto.fromMap(x))),
        attendanceReports: json["attendance_reports"] == null
            ? null
            : List<AttendanceReportDto>.from(
                json["attendance_reports"].map((final x) => AttendanceReportDto.fromMap(x)),
              ),
        requests: json["requests"] == null ? null : RequestEntityFactory.createResponseListFromMaps(json["requests"]),
        isAbsent: json["is_absent"],
      );

  @override
  List<Object?> get props => [gregorianDate, jalaliDate, attendances, attendanceReports, requests, isAbsent];
}

class WorkPerformanceSummary extends Equatable {
  const WorkPerformanceSummary({
    this.totalHours = 0,
    this.workedHours = 0,
    this.overtimeHours = 0,
    this.attendanceRate = "0",
  });

  final double totalHours;
  final double workedHours;
  final double overtimeHours;
  final String attendanceRate;

  factory WorkPerformanceSummary.fromJson(final String str) => WorkPerformanceSummary.fromMap(jsonDecode(str));

  factory WorkPerformanceSummary.fromMap(final Map<String, dynamic> json) {
    final double attendanceRate = json["attendance_rate"]?.toDouble() ?? 0;
    final String attendanceRatePercentageFormatted = attendanceRate.percentageFormatted;

    return WorkPerformanceSummary(
      totalHours: json["total_hours"] ?? 0,
      workedHours: json["worked_hours"] ?? 0,
      overtimeHours: json["overtime_hours"] ?? 0,
      attendanceRate: attendanceRatePercentageFormatted,
    );
  }

  @override
  List<Object?> get props => [totalHours, workedHours, overtimeHours, attendanceRate];
}

class AttendanceDto extends Equatable {
  const AttendanceDto({
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.isDone,
    this.overdue,
    this.overtime,
    this.slug,
    this.status,
  });

  final DateTime? startDate;
  final String? startTime;
  final DateTime? endDate;
  final String? endTime;
  final bool? isDone;
  final String? overdue;
  final String? overtime;
  final String? slug;
  final String? status;

  factory AttendanceDto.fromJson(final String str) => AttendanceDto.fromMap(jsonDecode(str));

  factory AttendanceDto.fromMap(final Map<String, dynamic> json) => AttendanceDto(
        startDate: json["start_date"] == null ? null : DateTime.tryParse(json["start_date"]),
        startTime: json["start_time"],
        endDate: json["end_date"] == null ? null : DateTime.tryParse(json["end_date"]),
        endTime: json["end_time"],
        isDone: json["is_done"],
        overdue: json["overdue"],
        overtime: json["overtime"],
        slug: json["slug"],
        status: json["status"],
      );

  @override
  List<Object?> get props => [startDate?.toCompactIso8601, startTime, endDate?.toCompactIso8601, endTime, isDone, overdue, overtime, slug, status];
}

class AttendanceReportDto extends Equatable {
  const AttendanceReportDto({
    this.slug,
    this.actionType,
    this.actionDatetime,
    this.message,
    this.relatedObject,
  });

  final String? slug;
  final AttendanceReportType? actionType;
  final DateTime? actionDatetime;
  final String? message;
  final IRequestReadDto? relatedObject;

  factory AttendanceReportDto.fromJson(final String str) => AttendanceReportDto.fromMap(jsonDecode(str));

  factory AttendanceReportDto.fromMap(final Map<String, dynamic> json) => AttendanceReportDto(
        slug: json["slug"],
        actionType: json["action_type"] == null ? null : AttendanceReportType.values.firstWhereOrNull((final e) => e.name == json["action_type"]),
        actionDatetime: json["action_datetime"] == null ? null : DateTime.tryParse(json["action_datetime"]),
        message: json["message"],
        relatedObject: json["related_object"] == null ? null : RequestEntityFactory.createResponseFromMap(json["related_object"]),
      );

  @override
  List<Object?> get props => [slug, actionType, actionDatetime, message, relatedObject?.slug];
}
