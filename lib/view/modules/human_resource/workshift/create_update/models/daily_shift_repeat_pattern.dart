import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';

enum WorkshiftRepeatType {
  singleDay,
  weekly,
  monthly;

  String get title {
    //todo: دو زبانه بشه
    if (isPersianLang) {
      switch (this) {
        case WorkshiftRepeatType.singleDay:
          return 'فقط این روز';
        case WorkshiftRepeatType.weekly:
          return 'هفتگی';
        case WorkshiftRepeatType.monthly:
          return 'ماهانه';
      }
    }
    switch (this) {
      case WorkshiftRepeatType.singleDay:
        return 'Only this day';
      case WorkshiftRepeatType.weekly:
        return 'Weekly';
      case WorkshiftRepeatType.monthly:
        return 'Monthly';
    }
  }
}

class DailyShiftRepeatPattern {
  const DailyShiftRepeatPattern({
    required this.shiftTypeParams,
    required this.repeatType,
    required this.weeklySelectedWeekdays,
    required this.monthlySelectedDays,
  });

  /// ShiftType params to create.
  final ShiftTypeParams shiftTypeParams;

  final WorkshiftRepeatType repeatType;

  /// Jalali weekDay ints: 1..7 (Sat..Fri). Used when [repeatType] is weekly.
  final Set<int> weeklySelectedWeekdays;

  /// Days of month 1..31. Used when [repeatType] is monthly.
  final Set<int> monthlySelectedDays;
}
