part of '../../../data.dart';

class MonthShiftParams {
  MonthShiftParams({
    required this.monthNumber,
    required this.yearShiftSlug,
    this.leaveDuration,
    this.activityDuration,
    this.dayList,
  });

  final int monthNumber;
  final String yearShiftSlug;
  final String? leaveDuration; // ISO 8601 Duration (P30D)
  final String? activityDuration; // ISO 8601 Duration (P30D)
  final List<Map<String, dynamic>>? dayList;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'month_number': monthNumber,
        'year_shift_slug': yearShiftSlug,
        if (leaveDuration != null) 'leave_duration': leaveDuration,
        if (activityDuration != null) 'activity_duration': activityDuration,
        if (dayList != null) 'day_list': dayList,
      };
}

