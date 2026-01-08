import '../../../../../../data/data.dart';
import '../../enums/workshift_repeat_type.dart';

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
