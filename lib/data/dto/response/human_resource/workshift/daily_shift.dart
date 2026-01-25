part of '../../../../data.dart';

class DailyShiftReadDto extends Equatable {
  final int? id;
  final String slug;
  final String dayDate; // YYYY-MM-DD (میلادی)
  final String? monthShiftSlug;
  final bool isHoliday;
  final bool isInMonth;

  // final List<String>? shiftTypeSlugList;
  final List<ShiftTypeReadDto> shiftTypes;

  const DailyShiftReadDto({
    this.id,
    required this.slug,
    required this.dayDate,
    this.monthShiftSlug,
    this.isHoliday = false,
    this.isInMonth = true,
    // this.shiftTypeSlugList,
    this.shiftTypes = const [],
  });

  factory DailyShiftReadDto.fromJson(final String str) => DailyShiftReadDto.fromMap(json.decode(str));

  factory DailyShiftReadDto.fromMap(final Map<String, dynamic> json) {
    return DailyShiftReadDto(
      id: json["id"],
      slug: json["slug"] ?? '',
      dayDate: json["day_date"] ?? '',
      monthShiftSlug: json["month_shift_slug"],
      isHoliday: json["is_holiday"] ?? false,
      isInMonth: json["is_in_month"] ?? true,
      // shiftTypeSlugList: json["shift_type_slug_list"] == null
      //     ? null
      //     : List<String>.from(json["shift_type_slug_list"]),
      shiftTypes: json["shift_types"] != null || json["shift_type"] != null
          ? List<ShiftTypeReadDto>.from(
              (json["shift_types"] ?? json["shift_type"])!.map((final x) => ShiftTypeReadDto.fromMap(x)),
            )
          : [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    slug,
    dayDate,
    monthShiftSlug,
    isHoliday,
    isInMonth,
    // shiftTypeSlugList,
    shiftTypes,
  ];
}
