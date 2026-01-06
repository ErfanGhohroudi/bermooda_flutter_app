part of '../../../data.dart';

class DailyShiftParams extends Equatable {
  const DailyShiftParams({
    required this.dayDate,
    this.isHoliday = false,
    this.isInMonth = true,
    this.shiftTypeSlugList,
  });

  final String dayDate; // YYYY-MM-DD
  final bool isHoliday;
  final bool isInMonth;
  final List<String>? shiftTypeSlugList;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'day_date': dayDate,
        'is_holiday': isHoliday,
        'is_in_month': isInMonth,
        if (shiftTypeSlugList != null) 'shift_type_slug_list': shiftTypeSlugList,
      };

  @override
  List<Object?> get props => [
    dayDate,
  ];
}

