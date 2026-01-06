part of '../../../../data.dart';

class MonthShiftReadDto extends Equatable {
  final int? id;
  final String slug;
  final int monthNumber;
  final String? monthName;
  final String? yearShiftSlug;
  final String? leaveDuration; // ISO 8601 Duration (P30D)
  final String? activityDuration; // ISO 8601 Duration (P30D)
  final List<DailyShiftReadDto>? days;

  const MonthShiftReadDto({
    this.id,
    required this.slug,
    required this.monthNumber,
    this.monthName,
    this.yearShiftSlug,
    this.leaveDuration,
    this.activityDuration,
    this.days,
  });

  factory MonthShiftReadDto.fromJson(final String str) => MonthShiftReadDto.fromMap(json.decode(str));

  factory MonthShiftReadDto.fromMap(final Map<String, dynamic> json) {
    return MonthShiftReadDto(
      id: json["id"],
      slug: json["slug"] ?? '',
      monthNumber: json["month_number"] ?? 0,
      monthName: json["month_name"],
      yearShiftSlug: json["year_shift_slug"],
      leaveDuration: json["leave_duration"],
      activityDuration: json["activity_duration"],
      days: json["days"] == null
          ? null
          : List<DailyShiftReadDto>.from(json["days"]!.map((final x) => DailyShiftReadDto.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [id, slug, monthNumber, monthName, yearShiftSlug, leaveDuration, activityDuration, days];
}

