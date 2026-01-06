import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';

/// نتیجه بررسی تداخل یک شیفت
class ShiftOverlapInfo {
  const ShiftOverlapInfo({
    required this.dayKey,
    required this.conflictingShiftTitle,
    required this.conflictingTimeRange,
    required this.newShiftTimeRange,
  });

  /// کلید روز (yyyy-MM-dd شمسی)
  final String dayKey;

  /// عنوان شیفت متداخل
  final String conflictingShiftTitle;

  /// بازه زمانی شیفت متداخل (مثلا "08:00 - 17:00")
  final String conflictingTimeRange;

  /// بازه زمانی شیفت جدید
  final String newShiftTimeRange;
}

/// نتیجه کلی بررسی تداخل‌ها
class ShiftOverlapResult {
  const ShiftOverlapResult({
    required this.overlappingDays,
    required this.validDays,
    required this.overlapInfoList,
  });

  /// لیست روزهایی که تداخل دارند
  final List<DailyShiftParams> overlappingDays;

  /// لیست روزهایی که بدون تداخل هستند
  final List<DailyShiftParams> validDays;

  /// اطلاعات کامل تداخل‌ها
  final List<ShiftOverlapInfo> overlapInfoList;

  /// آیا تداخلی وجود دارد؟
  bool get hasOverlap => overlappingDays.isNotEmpty;

  /// آیا همه روزها تداخل دارند؟
  bool get allDaysOverlap => validDays.isEmpty && overlappingDays.isNotEmpty;

  /// تعداد روزهای متداخل
  int get overlapCount => overlappingDays.length;

  /// تعداد روزهای معتبر
  int get validCount => validDays.length;
}

abstract class ShiftOverlapChecker {
  /// ساخت Map شیفت‌های کل سال از YearShiftReadDto
  ///
  /// این تابع شیفت‌های remote از کل ماه‌های سال و همچنین draftShifts را
  /// در یک Map ترکیب می‌کند تا بتوان تداخل را برای کل سال بررسی کرد.
  static Map<String, Set<String>> buildYearAssignmentsMap({
    required final YearShiftReadDto yearShift,
    required final Set<DailyShiftParams> draftShifts,
  }) {
    final Map<String, Set<String>> result = {};

    // 1. از شیفت‌های remote (کل ماه‌های سال)
    for (final month in yearShift.months ?? <MonthShiftReadDto>[]) {
      for (final day in month.days ?? <DailyShiftReadDto>[]) {
        final dayKey = _normalizeDayKey(day.dayDate);
        result.putIfAbsent(dayKey, () => <String>{});
        result[dayKey]!.addAll(day.shiftTypes.map((final e) => e.slug));
      }
    }

    // 2. merge با draftShifts
    for (final draft in draftShifts) {
      final dayKey = _normalizeDayKey(draft.dayDate);
      result.putIfAbsent(dayKey, () => <String>{});
      result[dayKey]!.addAll(draft.shiftTypeSlugList ?? <String>[]);
    }

    return result;
  }

  /// بررسی تداخل شیفت جدید با شیفت‌های موجود
  ///
  /// [targetDays]: لیست روزهایی که شیفت جدید قرار است اعمال شود
  /// [newShiftStartTime]: زمان شروع شیفت جدید (HH:MM)
  /// [newShiftEndTime]: زمان پایان شیفت جدید (HH:MM)
  /// [isNightShift]: آیا شیفت شب است (پایان در روز بعد)
  /// [assignmentsByDate]: شیفت‌های موجود به تفکیک روز
  /// [shiftTypeRegistry]: رجیستری شیفت تایپ‌ها برای دسترسی به اطلاعات
  static ShiftOverlapResult checkShiftOverlaps({
    required final List<DailyShiftParams> targetDays,
    required final String newShiftStartTime,
    required final String newShiftEndTime,
    required final bool isNightShift,
    required final Map<String, Set<String>> assignmentsByDate,
    required final Map<String, ShiftTypeReadDto> shiftTypeRegistry,
  }) {
    final overlappingDays = <DailyShiftParams>[];
    final validDays = <DailyShiftParams>[];
    final overlapInfoList = <ShiftOverlapInfo>[];

    final newStartMinutes = _timeToMinutes(newShiftStartTime);
    final newEndMinutes = _timeToMinutes(newShiftEndTime);
    final newTimeRange = '$newShiftStartTime - $newShiftEndTime';

    for (final day in targetDays) {
      final dayKey = _normalizeDayKey(day.dayDate);
      final existingSlugs = assignmentsByDate[dayKey] ?? <String>{};

      bool hasOverlapForThisDay = false;

      for (final slug in existingSlugs) {
        final existingShift = shiftTypeRegistry[slug];
        if (existingShift == null) continue;

        final existingStartMinutes = _timeToMinutes(existingShift.startTime);
        final existingEndMinutes = _timeToMinutes(existingShift.endTime);
        final existingIsNightShift = existingShift.isNightShift || existingEndMinutes <= existingStartMinutes;

        if (_doTimeRangesOverlap(
          newStart: newStartMinutes,
          newEnd: newEndMinutes,
          newIsNight: isNightShift,
          existingStart: existingStartMinutes,
          existingEnd: existingEndMinutes,
          existingIsNight: existingIsNightShift,
        )) {
          hasOverlapForThisDay = true;
          overlapInfoList.add(
            ShiftOverlapInfo(
              dayKey: dayKey,
              conflictingShiftTitle: existingShift.title,
              conflictingTimeRange: '${existingShift.startTime} - ${existingShift.endTime}',
              newShiftTimeRange: newTimeRange,
            ),
          );
        }
      }

      // همچنین باید شیفت‌های روز قبل که شیفت شب هستند را بررسی کنیم
      final previousDayKey = _getPreviousDayKey(dayKey);
      final previousDaySlugs = assignmentsByDate[previousDayKey] ?? <String>{};

      for (final slug in previousDaySlugs) {
        final existingShift = shiftTypeRegistry[slug];
        if (existingShift == null) continue;

        final existingStartMinutes = _timeToMinutes(existingShift.startTime);
        final existingEndMinutes = _timeToMinutes(existingShift.endTime);
        final existingIsNightShift = existingShift.isNightShift || existingEndMinutes <= existingStartMinutes;

        // فقط شیفت‌های شب روز قبل را بررسی می‌کنیم
        if (!existingIsNightShift) continue;

        if (_doNightShiftOverlapWithNextDay(
          nightShiftEnd: existingEndMinutes,
          newStart: newStartMinutes,
          newEnd: newEndMinutes,
          newIsNight: isNightShift,
        )) {
          hasOverlapForThisDay = true;
          overlapInfoList.add(
            ShiftOverlapInfo(
              dayKey: dayKey,
              conflictingShiftTitle: '${existingShift.title} (${isPersianLang ? 'روز قبل' : 'previous day'})',
              conflictingTimeRange: '${existingShift.startTime} - ${existingShift.endTime}',
              newShiftTimeRange: newTimeRange,
            ),
          );
        }
      }

      if (hasOverlapForThisDay) {
        overlappingDays.add(day);
      } else {
        validDays.add(day);
      }
    }

    return ShiftOverlapResult(
      overlappingDays: overlappingDays,
      validDays: validDays,
      overlapInfoList: overlapInfoList,
    );
  }

  /// نمایش خطای تداخل کامل (وقتی همه روزها تداخل دارند)
  static void showAllDaysOverlapError({required final String newShiftTitle}) {
    AppNavigator.snackbarRed(
      title: s.error,
      subtitle: isPersianLang
          ? 'شیفت "$newShiftTitle" با تمام روزهای انتخابی تداخل دارد'
          : 'Shift "$newShiftTitle" conflicts with all selected days',
    );
  }

  /// نمایش دیالوگ گزارش تداخل‌ها
  ///
  /// این دیالوگ اطلاعات کاملی از تداخل‌ها را نمایش می‌دهد و سپس
  /// روزهای بدون تداخل به صورت خودکار اعمال می‌شوند
  static Future<void> showOverlapReportDialog({
    required final ShiftOverlapResult result,
    required final String newShiftTitle,
  }) async {
    // گروه‌بندی تداخل‌ها بر اساس شیفت متداخل
    final Map<String, List<ShiftOverlapInfo>> groupedByShift = {};
    for (final info in result.overlapInfoList) {
      final key = '${info.conflictingShiftTitle}|${info.conflictingTimeRange}';
      groupedByShift.putIfAbsent(key, () => []).add(info);
    }

    await showAppDialog<void>(
      barrierDismissible: false,
      Builder(
        builder: (final ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Row(
              spacing: 8,
              children: [
                const UImage(AppIcons.warningOutline, color: Colors.orange, size: 25),
                Expanded(
                  child: Text(
                    isPersianLang ? 'گزارش تداخل شیفت' : 'Shift Overlap Report',
                  ).titleMedium(),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // خلاصه
                      WCard(
                        color: AppColors.orange.withValues(alpha: 0.05),
                        showBorder: true,
                        borderColor: AppColors.orange.withValues(alpha: 0.2),
                        margin: EdgeInsets.zero,
                        child: SizedBox(
                          width: ctx.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                isPersianLang
                                    ? 'شیفت "$newShiftTitle" با ${result.overlapCount} روز تداخل دارد'
                                    : 'Shift "$newShiftTitle" conflicts with ${result.overlapCount} days',
                              ).bodyMedium().bold(),
                              Text(
                                isPersianLang
                                    ? '${result.validCount} روز بدون تداخل اعمال خواهد شد'
                                    : '${result.validCount} days without conflict will be applied',
                              ).bodyMedium(color: AppColors.green),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // جزئیات تداخل‌ها
                      Text('${s.details}:').bodyMedium().bold(),
                      const SizedBox(height: 8),

                      ...groupedByShift.entries.map((final entry) {
                        final parts = entry.key.split('|');
                        final shiftTitle = parts[0];
                        final timeRange = parts.length > 1 ? parts[1] : '';
                        final days = entry.value;

                        return WCard(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: 10,
                          showBorder: true,
                          borderWidth: 1,
                          borderColor: ctx.theme.dividerColor.withValues(alpha: 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  UImage(AppIcons.clockOutline, size: 20, color: ctx.theme.hintColor),
                                  Expanded(
                                    child: Text(shiftTitle).bodyMedium().bold(),
                                  ),
                                ],
                              ),
                              Text('${s.time}: $timeRange').bodySmall(color: ctx.theme.hintColor),
                              Text(
                                isPersianLang ? 'تعداد روزهای متداخل: ${days.length}' : 'Conflicting days: ${days.length}',
                              ).bodySmall(),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                UElevatedButton(
                  width: ctx.width,
                  title: s.ok,
                  onTap: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// تبدیل زمان HH:MM به دقیقه از ابتدای روز
int _timeToMinutes(final String time) {
  final parts = time.split(':');
  if (parts.length != 2) return 0;
  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;
  return hours * 60 + minutes;
}

/// بررسی تداخل دو بازه زمانی با در نظر گرفتن شیفت شب
bool _doTimeRangesOverlap({
  required final int newStart,
  required final int newEnd,
  required final bool newIsNight,
  required final int existingStart,
  required final int existingEnd,
  required final bool existingIsNight,
}) {
  // شیفت معمولی: start < end
  // شیفت شب: start > end (مثلا 22:00 تا 06:00)

  // اگر هیچکدام شیفت شب نیستند
  if (!newIsNight && !existingIsNight) {
    return _simpleOverlap(newStart, newEnd, existingStart, existingEnd);
  }

  // اگر شیفت جدید شب است
  if (newIsNight && !existingIsNight) {
    // بخش اول شیفت جدید: newStart تا 24:00
    if (_simpleOverlap(newStart, 24 * 60, existingStart, existingEnd)) {
      return true;
    }
    return false;
  }

  // اگر شیفت موجود شب است
  if (!newIsNight && existingIsNight) {
    // بخش اول شیفت موجود: existingStart تا 24:00
    if (_simpleOverlap(newStart, newEnd, existingStart, 24 * 60)) {
      return true;
    }
    return false;
  }

  // اگر هر دو شیفت شب هستند
  // بخش اول هر دو (تا 24:00) با هم تداخل دارند
  if (_simpleOverlap(newStart, 24 * 60, existingStart, 24 * 60)) {
    return true;
  }
  // بخش دوم هر دو (از 00:00) با هم تداخل دارند
  if (_simpleOverlap(0, newEnd, 0, existingEnd)) {
    return true;
  }
  return false;
}

/// بررسی تداخل بخش شب شیفت روز قبل با شیفت روز جاری
bool _doNightShiftOverlapWithNextDay({
  required final int nightShiftEnd,
  required final int newStart,
  required final int newEnd,
  required final bool newIsNight,
}) {
  // بخش دوم شیفت شب روز قبل: 00:00 تا nightShiftEnd
  if (newIsNight) {
    // اگر شیفت جدید هم شب است، بخش دوم آن با شیفت روز قبل تداخل دارد
    return _simpleOverlap(0, nightShiftEnd, 0, newEnd);
  } else {
    // شیفت جدید معمولی است
    return _simpleOverlap(0, nightShiftEnd, newStart, newEnd);
  }
}

/// بررسی تداخل ساده دو بازه
bool _simpleOverlap(final int start1, final int end1, final int start2, final int end2) {
  return start1 < end2 && start2 < end1;
}

/// نرمال‌سازی کلید روز (تبدیل میلادی به شمسی)
String _normalizeDayKey(final String raw) {
  final parts = raw.split('-');
  if (parts.length != 3) return raw;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return raw;

  // اگر سال بیشتر از 1500 باشد احتمالا شمسی است
  if (y > 1500) return raw;

  final dt = DateTime(y, m, d);
  final jalali = Jalali.fromDateTime(dt);
  return _dayKey(jalali);
}

/// ساخت کلید روز از تاریخ شمسی
String _dayKey(final Jalali date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// دریافت کلید روز قبل
String _getPreviousDayKey(final String dayKey) {
  final parts = dayKey.split('-');
  if (parts.length != 3) return dayKey;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return dayKey;

  final jalali = Jalali(y, m, d).addDays(-1);
  return _dayKey(jalali);
}
