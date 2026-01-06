part of '../../../../data.dart';

class ShiftTypeReadDto extends Equatable {
  final int? id;
  final String slug;
  final String title;
  final String? folderSlug;
  final LabelColors? color;
  final String startTime; // HH:MM
  final String endTime; // HH:MM
  final String? breakStartTime; // HH:MM
  final String? breakEndTime; // HH:MM
  final ShiftFlexibleTimeDuration? flexibleStartTime;
  final ShiftFlexibleTimeDuration? flexibleEndTime;
  final String? dailyOvertimeHours; // ISO 8601 Duration (PT2H)
  final bool isHoliday;
  final bool hasOffShiftAccess;
  final List<AttendanceMethod> allowedCheckInMethodList;
  final List<AttendanceMethod> allowedCheckOutMethodList;

  bool get isNightShift => endTime.numericOnly().toInt() <= startTime.numericOnly().toInt();

  const ShiftTypeReadDto({
    this.id,
    required this.slug,
    required this.title,
    this.folderSlug,
    this.color,
    required this.startTime,
    required this.endTime,
    this.breakStartTime,
    this.breakEndTime,
    this.flexibleStartTime,
    this.flexibleEndTime,
    this.dailyOvertimeHours,
    this.isHoliday = false,
    this.hasOffShiftAccess = true,
    this.allowedCheckInMethodList = const [],
    this.allowedCheckOutMethodList = const [],
  });

  factory ShiftTypeReadDto.fromJson(final String str) => ShiftTypeReadDto.fromMap(json.decode(str));

  factory ShiftTypeReadDto.fromMap(final Map<String, dynamic> json) {
    return ShiftTypeReadDto(
      id: json["id"],
      slug: json["slug"] ?? '',
      title: json["title"] ?? '',
      folderSlug: json["folder_slug"],
      color: LabelColors.fromColorCode(json["color_code"]),
      startTime: json["start_time"] ?? '08:00',
      endTime: json["end_time"] ?? '17:00',
      breakStartTime: json["break_start_time"],
      breakEndTime: json["break_end_time"],
      flexibleStartTime: ShiftFlexibleTimeDuration.fromString(json["flexible_start_time"]) ,
      flexibleEndTime: ShiftFlexibleTimeDuration.fromString(json["flexible_end_time"]),
      dailyOvertimeHours: json["daily_overtime_hours"],
      isHoliday: json["is_holiday"] ?? false,
      hasOffShiftAccess: json["has_off_shift_access"] ?? true,
      allowedCheckInMethodList: json["allowed_check_in_method_list"] == null
          ? []
          : json["allowed_check_in_method_list"]!
                .map((final e) => AttendanceMethod.values.firstWhereOrNull((final e2) => e2.name == e))
                .whereType<AttendanceMethod>()
                .toList(),
      allowedCheckOutMethodList: json["allowed_check_out_method_list"] == null
          ? []
          : json["allowed_check_out_method_list"]!
                .map((final e) => AttendanceMethod.values.firstWhereOrNull((final e2) => e2.name == e))
                .whereType<AttendanceMethod>()
                .toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    slug,
    title,
    folderSlug,
    color,
    startTime,
    endTime,
    breakStartTime,
    breakEndTime,
    flexibleStartTime?.name,
    flexibleEndTime?.name,
    dailyOvertimeHours,
    isHoliday,
    hasOffShiftAccess,
    allowedCheckInMethodList.toString(),
    allowedCheckOutMethodList.toString(),
  ];
}
