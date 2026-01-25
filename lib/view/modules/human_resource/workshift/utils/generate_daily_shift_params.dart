import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../data/data.dart';
import '../create_update/models/daily_shift_repeat_pattern.dart';
import '../enums/workshift_repeat_type.dart';

Future<List<DailyShiftParams>> generateDailyShiftParams({
  required final DailyShiftRepeatPattern pattern,
  required final YearShiftReadDto yearShift,
  required final ShiftTypeReadDto shiftType,
  final Jalali? initialStartDate,
}) async {
  final year = yearShift.year;
  final now = Jalali.now();
  final startDate = initialStartDate ?? (now.year == year ? now : Jalali(year, 1, 1));
  final endOfYear = Jalali(year, 12, Jalali(year, 12, 1).monthLength);

  final used = <String>{};
  final out = <DailyShiftParams>[];

  void addDay(final Jalali j) {
    final greg = j.toDateTime().toCompactIso8601;
    if (greg == null) return;
    if (!used.add(greg)) return;
    out.add(
      DailyShiftParams(
        dayDate: greg,
        isHoliday: false,
        isInMonth: true,
        shiftTypeSlugList: <String>[shiftType.slug],
      ),
    );
  }

  switch (pattern.repeatType) {
    case WorkshiftRepeatType.singleDay:
      addDay(startDate);
      break;
    case WorkshiftRepeatType.weekly:
      final weekdays = pattern.weeklySelectedWeekdays;
      for (var d = startDate; d.compareTo(endOfYear) <= 0; d = d.addDays(1)) {
        if (weekdays.contains(d.weekDay)) {
          addDay(d);
        }
      }
      break;
    case WorkshiftRepeatType.monthly:
      final days = pattern.monthlySelectedDays.toList()..sort();
      for (var month = startDate.month; month <= 12; month++) {
        final monthLength = Jalali(year, month, 1).monthLength;
        for (final day in days) {
          if (day < 1) continue;
          if (day > monthLength) continue; // invalid for this month
          if (month == startDate.month && day < startDate.day) continue; // only remaining days
          addDay(Jalali(year, month, day));
        }
      }
      break;
  }

  return out;
}
