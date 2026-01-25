part of '../../../data.dart';

class ShiftTypeParams {
  ShiftTypeParams({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.color,
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

  final String title;
  final String startTime; // HH:MM
  final String endTime; // HH:MM
  final LabelColors color;
  final String? breakStartTime; // HH:MM
  final String? breakEndTime; // HH:MM
  final ShiftFlexibleTimeDuration? flexibleStartTime;
  final ShiftFlexibleTimeDuration? flexibleEndTime;
  final String? dailyOvertimeHours; // HH:MM:SS
  final bool isHoliday;
  final bool hasOffShiftAccess;
  final List<AttendanceMethod> allowedCheckInMethodList;
  final List<AttendanceMethod> allowedCheckOutMethodList;

  bool get isNightShift => endTime.numericOnly().toInt() <= startTime.numericOnly().toInt();

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'start_time': startTime,
    'end_time': endTime,
    'color_code': color.colorCode,
    if (breakStartTime != null) 'break_start_time': breakStartTime,
    if (breakEndTime != null) 'break_end_time': breakEndTime,
    if (flexibleStartTime != null) 'flexible_start_time': flexibleStartTime!.value,
    if (flexibleEndTime != null) 'flexible_end_time': flexibleEndTime!.value,
    if (dailyOvertimeHours != null) 'daily_overtime_hours': dailyOvertimeHours,
    'is_holiday': isHoliday,
    'has_off_shift_access': hasOffShiftAccess,
    'allowed_check_in_method_list': allowedCheckInMethodList.map((final e) => e.name).toList(),
    'allowed_check_out_method_list': allowedCheckOutMethodList.map((final e) => e.name).toList(),
  };
}
