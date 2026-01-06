import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/loading/loading.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../data/data.dart';
import '../../create_update/models/daily_shift_repeat_pattern.dart';
import '../../sheets/daily_shift_repeat_pattern_sheet.dart';
import '../../utils/shift_overlap_checker.dart';
import '../workshift_detail_controller.dart';

class WorkshiftDaySheet extends StatefulWidget {
  const WorkshiftDaySheet({
    required this.controller,
    required this.day,
    required this.dayKey,
    super.key,
  });

  final WorkshiftDetailController controller;
  final Jalali day;
  final String dayKey;

  @override
  State<WorkshiftDaySheet> createState() => _WorkshiftDaySheetState();
}

class _WorkshiftDaySheetState extends State<WorkshiftDaySheet> {
  DailyShiftRepeatPattern? _lastPattern;

  WorkshiftDetailController get controller => widget.controller;

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        final selectedSlugs = controller.getDayAssignments(widget.dayKey).toList();
        selectedSlugs.sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('${s.day} ${widget.dayKey}').titleMedium().bold()),
                if (controller.haveAdminAccess)
                  UElevatedButton(
                    title: s.addText,
                    onTap: _addShiftTypeFlow,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (selectedSlugs.isEmpty)
              Center(child: Text(s.noData).bodyMedium(color: context.theme.hintColor)).pSymmetric(vertical: 24)
            else
              ...selectedSlugs.map((final slug) {
                final st = controller.shiftTypeRegistry[slug];
                if (st == null) return const SizedBox.shrink();
                return WCard(
                  showBorder: true,
                  horPadding: 12,
                  verPadding: 10,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(st.title).bodyMedium().bold(),
                            const SizedBox(height: 4),
                            Text('${st.startTime} - ${st.endTime}').bodySmall(color: context.theme.hintColor),
                          ],
                        ),
                      ),
                      if (controller.haveAdminAccess)
                        IconButton(
                          tooltip: s.delete,
                          onPressed: () {
                            final set = {...controller.getDayAssignments(widget.dayKey)};
                            set.remove(slug);
                            controller.setDayAssignments(widget.dayKey, set);
                          },
                          icon: const UImage(AppIcons.delete, color: Colors.red, size: 20),
                        ),
                    ],
                  ),
                ).marginOnly(bottom: 8);
              }),
          ],
        );
      },
    );
  }

  Future<void> _addShiftTypeFlow() async {
    final pattern = await bottomSheetWithNoScroll<DailyShiftRepeatPattern>(
      title: isPersianLang ? 'تنظیم شیفت' : 'Shift Setup',
      child: DailyShiftRepeatPatternSheet(
        initialPattern: _lastPattern,
        enableOnlyThisDayRepeatType: true,
      ),
    );

    // If user dismissed: keep previous behavior (create year + navigate).
    if (pattern == null) return;

    // Save pattern for potential retry
    _lastPattern = pattern;

    final yearShift = controller.selectedYearShift.value;
    if (yearShift == null) return;

    AppLoading.showLoading();
    try {
      // ابتدا روزهای تارگت را تولید می‌کنیم (بدون slug شیفت تایپ)
      final List<DailyShiftParams> targetDays = await _generateTargetDaysForOverlapCheck(
        pattern: pattern,
        yearShift: yearShift,
      );

      if (targetDays.isEmpty) {
        AppLoading.dismissLoading();
        return;
      }

      // ساخت Map شیفت‌های کل سال (remote + draft)
      final yearAssignments = ShiftOverlapChecker.buildYearAssignmentsMap(
        yearShift: yearShift,
        draftShifts: controller.draftShifts,
      );

      // بررسی تداخل با شیفت‌های موجود در کل سال
      final overlapResult = ShiftOverlapChecker.checkShiftOverlaps(
        targetDays: targetDays,
        newShiftStartTime: pattern.shiftTypeParams.startTime,
        newShiftEndTime: pattern.shiftTypeParams.endTime,
        isNightShift: pattern.shiftTypeParams.isNightShift,
        assignmentsByDate: yearAssignments,
        shiftTypeRegistry: controller.shiftTypeRegistry,
      );

      // اگر همه روزها تداخل دارند
      if (overlapResult.allDaysOverlap) {
        AppLoading.dismissLoading();
        ShiftOverlapChecker.showAllDaysOverlapError(newShiftTitle: pattern.shiftTypeParams.title);
        _addShiftTypeFlow();
        return;
      }

      // اگر برخی روزها تداخل دارند، گزارش را نمایش بده
      if (overlapResult.hasOverlap) {
        AppLoading.dismissLoading();
        await ShiftOverlapChecker.showOverlapReportDialog(
          result: overlapResult,
          newShiftTitle: pattern.shiftTypeParams.title,
        );
        AppLoading.showLoading();
      }

      // ایجاد شیفت تایپ فقط در صورت وجود روزهای معتبر
      final shiftType = await controller.createShiftTypeAsync(pattern.shiftTypeParams);

      // فقط روزهای بدون تداخل را اعمال کن
      final List<DailyShiftParams> validDaysWithSlug = overlapResult.validDays
          .map(
            (final day) => DailyShiftParams(
              dayDate: day.dayDate,
              isHoliday: day.isHoliday,
              isInMonth: day.isInMonth,
              shiftTypeSlugList: <String>[shiftType.slug],
            ),
          )
          .toList();

      controller.draftShifts.addAll(validDaysWithSlug);
      controller.draftShifts.refresh();

      // Clear last pattern on success
      _lastPattern = null;

      AppLoading.dismissLoading();
    } catch (e) {
      AppLoading.dismissLoading();
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: isPersianLang ? 'خطا در تنظیم تقویم' : 'Failed to apply setup',
      );
      // Retry with last pattern
      _addShiftTypeFlow();
    }
  }

  /// تولید لیست روزهای تارگت بدون slug شیفت تایپ (برای بررسی تداخل)
  Future<List<DailyShiftParams>> _generateTargetDaysForOverlapCheck({
    required final DailyShiftRepeatPattern pattern,
    required final YearShiftReadDto yearShift,
  }) async {
    final year = yearShift.year;
    final startDate = widget.day;
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
          shiftTypeSlugList: null, // بدون slug - فقط برای بررسی تداخل
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
            if (day > monthLength) continue;
            if (month == startDate.month && day < startDate.day) continue;
            addDay(Jalali(year, month, day));
          }
        }
        break;
    }

    return out;
  }
}
