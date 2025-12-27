part of '../../../data.dart';

class WorkShiftReadDto extends Equatable {
  final String slug;
  final String title;
  final List<YearDto> years;

  const WorkShiftReadDto({
    required this.slug,
    required this.title,
    required this.years,
  });

  factory WorkShiftReadDto.fromJson(final String str) => WorkShiftReadDto.fromMap(json.decode(str));

  factory WorkShiftReadDto.fromMap(final Map<String, dynamic> json) {
    return WorkShiftReadDto(
      slug: json["slug"] ?? '',
      title: json["title"] ?? '',
      years: json["years"] == null ? [] : List<YearDto>.from(json["years"]!.map((final x) => YearDto.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [slug, title, years];
}

//==============================================================================
// کلاس مربوط به هر سال (YearDto)
//==============================================================================
class YearDto extends Equatable {
  final String slug;
  final int year;
  final List<MonthDto> months;

  const YearDto({
    required this.slug,
    required this.year,
    required this.months,
  });

  factory YearDto.fromJson(final String str) => YearDto.fromMap(json.decode(str));

  factory YearDto.fromMap(final Map<String, dynamic> json) {
    return YearDto(
      slug: json["slug"] ?? '',
      year: json["year"] ?? 0,
      months: json["months"] == null ? [] : List<MonthDto>.from(json["months"]!.map((final x) => MonthDto.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [slug, year, months];
}

//==============================================================================
// کلاس مربوط به هر ماه (MonthDto)
//==============================================================================
class MonthDto extends Equatable {
  final String slug;
  final int monthNumber;
  final String monthName;
  final String leaveDuration; // HH:MM
  final String activityDuration; // HH:MM
  final List<DayDto> days;

  const MonthDto({
    required this.slug,
    required this.monthNumber,
    required this.monthName,
    required this.leaveDuration,
    required this.activityDuration,
    required this.days,
  });

  factory MonthDto.fromJson(final String str) => MonthDto.fromMap(json.decode(str));

  factory MonthDto.fromMap(final Map<String, dynamic> json) {
    return MonthDto(
      slug: json["slug"] ?? '',
      monthNumber: json["month_number"] ?? 0,
      monthName: json["month_name"] ?? '',
      leaveDuration: (json["leave_duration"] ?? '00:00:00').substring(0, 5),
      activityDuration: (json["activity_duration"] ?? '00:00:00').substring(0, 5),
      days: json["days"] == null ? [] : List<DayDto>.from(json["days"]!.map((final x) => DayDto.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [slug, monthNumber, monthName, leaveDuration, activityDuration, days];
}

//==============================================================================
// کلاس مربوط به هر روز (DayDto)
//==============================================================================
class DayDto extends Equatable {
  final String slug;
  final bool isInMonth;
  final bool isHoliday;
  final String timeToStartJalali; // HH:MM
  final String timeToEndJalali; // HH:MM
  final String restTimeToStartJalali; // HH:MM
  final String restTimeToEndJalali; // HH:MM
  final String flexibleDuration; // HH:MM
  final String overtimeDuration; // HH:MM

  const DayDto({
    required this.slug,
    required this.isInMonth,
    required this.isHoliday,
    required this.timeToStartJalali,
    required this.timeToEndJalali,
    required this.restTimeToStartJalali,
    required this.restTimeToEndJalali,
    required this.flexibleDuration,
    required this.overtimeDuration,
  });

  factory DayDto.fromJson(final String str) => DayDto.fromMap(json.decode(str));

  factory DayDto.fromMap(final Map<String, dynamic> json) {
    return DayDto(
      slug: json["slug"] ?? '',
      isInMonth: json["is_in_month"] ?? false,
      isHoliday: json["is_holiday"] ?? false,
      timeToStartJalali: (json["time_to_start_jalali"] ?? '00:00:00').substring(0, 5),
      timeToEndJalali: (json["time_to_end_jalali"] ?? '00:00:00').substring(0, 5),
      restTimeToStartJalali: (json["rest_time_to_start_jalali"] ?? '00:00:00').substring(0, 5),
      restTimeToEndJalali: (json["rest_time_to_end_jalali"] ?? '00:00:00').substring(0, 5),
      flexibleDuration: (json["flexible_duration"] ?? '00:00:00').substring(0, 5),
      overtimeDuration: (json["overtime_duration"] ?? '00:00:00').substring(0, 5),
    );
  }

  @override
  List<Object?> get props => [
    slug,
    isInMonth,
    isHoliday,
    timeToStartJalali,
    timeToEndJalali,
    restTimeToStartJalali,
    restTimeToEndJalali,
    flexibleDuration,
    overtimeDuration,
  ];
}
