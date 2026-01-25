import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/loading/loading.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';
import '../../create_update/models/daily_shift_repeat_pattern.dart';
import '../../enums/workshift_repeat_type.dart';
import '../../sheets/daily_shift_repeat_pattern_sheet.dart';
import '../../utils/shift_overlap_checker.dart';
import '../../widgets/shift_type_card.dart';
import '../widgets/night_shift_span.dart';
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

  /// Check if a shift type is a night shift (starts after end time, crosses midnight)
  bool _isNightShift(final ShiftTypeReadDto? st) {
    if (st == null) return false;
    final start = _parseHm(st.startTime);
    final end = _parseHm(st.endTime);
    if (start == null || end == null) return false;
    return start > end;
  }

  int? _parseHm(final String hm) {
    final parts = hm.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "add_shift_type_fab",
        onPressed: _addShiftTypeFlow,
        tooltip: s.addShift,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        child: Obx(
          () {
            // Today's shifts (including night shift starts)
            final todaySlugs = controller.getDayAssignments(widget.dayKey).toList();

            // Previous day's night shifts (that end today)
            final previousDay = widget.day.addDays(-1);
            final previousDayKey = controller.getDayKeyFromJalali(previousDay);
            final previousDaySlugs = controller.getDayAssignments(previousDayKey);
            final nightShiftEndsToday = previousDaySlugs
                .where((final slug) => _isNightShift(controller.shiftTypeRegistry[slug]))
                .toList();

            final hasAnyShift = todaySlugs.isNotEmpty || nightShiftEndsToday.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasAnyShift)
                  Center(child: Text(s.noData).bodyMedium(color: context.theme.hintColor)).pSymmetric(vertical: 24)
                else ...[
                  // Night shifts ending today (from previous day)
                  ...nightShiftEndsToday.map((final slug) {
                    final st = controller.shiftTypeRegistry[slug];
                    if (st == null) return const SizedBox.shrink();

                    return WShiftTypeCard(
                      controller: controller,
                      shiftType: st,
                      day: widget.day,
                      dayKey: widget.dayKey,
                      nightShiftSegment: NightShiftSegment.end,
                      onEdit: () => _editShiftTypeFlow(st.slug),
                    );
                  }),
                  // Today's shifts
                  ...todaySlugs.map((final slug) {
                    final st = controller.shiftTypeRegistry[slug];
                    if (st == null) return const SizedBox.shrink();

                    return WShiftTypeCard(
                      controller: controller,
                      shiftType: st,
                      day: widget.day,
                      dayKey: widget.dayKey,
                      nightShiftSegment: _isNightShift(st) ? NightShiftSegment.start : null,
                      onEdit: () => _editShiftTypeFlow(st.slug),
                    );
                  }),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _addShiftTypeFlow() async {
    final pattern = await bottomSheetWithNoScroll<DailyShiftRepeatPattern>(
      title: s.addShift,
      child: DailyShiftRepeatPatternSheet(
        initialPattern: _lastPattern,
        enableOnlyThisDayRepeatType: true,
      ),
    );

    // If user dismissed: keep previous behavior (create year + navigate).
    if (pattern == null) {
      _lastPattern = null;
      return;
    }

    // Save pattern for potential retry
    _lastPattern = pattern;

    AppLoading.showLoading();
    try {
      // ابتدا روزهای تارگت را تولید می‌کنیم (بدون slug شیفت تایپ)
      final List<DailyShiftParams> targetDays = await _generateTargetDaysForOverlapCheck(
        pattern: pattern,
      );

      if (targetDays.isEmpty) {
        AppLoading.dismissLoading();
        return;
      }

      final yearMonths = controller.selectedYearShift.value?.months;
      // ساخت Map شیفت‌های کل سال (remote + draft)
      final yearAssignments = ShiftOverlapChecker.buildYearAssignmentsMap(
        yearMonths: yearMonths,
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
      // Merge new shift with existing drafts for the same day
      for (final day in overlapResult.validDays) {
        final existingDraft = controller.draftShifts.firstWhereOrNull(
          (final d) => d.dayDate == day.dayDate,
        );

        if (existingDraft != null) {
          // Remove old entry and add merged one
          controller.draftShifts.remove(existingDraft);
          final mergedSlugs = <String>[
            ...?existingDraft.shiftTypeSlugList,
            shiftType.slug,
          ];
          controller.draftShifts.add(
            DailyShiftParams(
              dayDate: day.dayDate,
              isHoliday: day.isHoliday,
              isInMonth: day.isInMonth,
              shiftTypeSlugList: mergedSlugs,
            ),
          );
        } else {
          // No existing draft, add new one
          controller.draftShifts.add(
            DailyShiftParams(
              dayDate: day.dayDate,
              isHoliday: day.isHoliday,
              isInMonth: day.isInMonth,
              shiftTypeSlugList: <String>[shiftType.slug],
            ),
          );
        }
      }
      controller.draftShifts.refresh();

      // Clear last pattern on success
      _lastPattern = null;

      AppLoading.dismissLoading();
    } catch (e) {
      AppLoading.dismissLoading();
      AppNavigator.snackbarRed(title: s.error, subtitle: s.failedToApplyShift);
      // Retry with last pattern
      _addShiftTypeFlow();
    }
  }

  Future<void> _editShiftTypeFlow(final String targetSlug) async {
    final st = controller.shiftTypeRegistry[targetSlug];
    if (st == null) return;

    // Initial Form Pattern
    _lastPattern = DailyShiftRepeatPattern(
      shiftTypeParams: ShiftTypeParams(
        title: st.title,
        startTime: st.startTime,
        endTime: st.endTime,
        color: st.color,
        allowedCheckInMethodList: st.allowedCheckInMethodList,
        allowedCheckOutMethodList: st.allowedCheckOutMethodList,
        breakStartTime: st.breakStartTime,
        breakEndTime: st.breakEndTime,
        flexibleStartTime: st.flexibleStartTime,
        flexibleEndTime: st.flexibleEndTime,
      ),
      repeatType: WorkshiftRepeatType.singleDay,
      weeklySelectedWeekdays: <int>{},
      monthlySelectedDays: <int>{},
    );

    final pattern = await bottomSheetWithNoScroll<DailyShiftRepeatPattern>(
      title: s.addShift,
      child: DailyShiftRepeatPatternSheet(
        initialPattern: _lastPattern,
        enableOnlyThisDayRepeatType: true,
      ),
    );

    // If user dismissed: keep previous behavior (create year + navigate).
    if (pattern == null) {
      _lastPattern = null;
      return;
    }

    // Save pattern for potential retry
    _lastPattern = pattern;

    AppLoading.showLoading();
    try {
      // ابتدا روزهای تارگت را تولید می‌کنیم (بدون slug شیفت تایپ)
      final List<DailyShiftParams> targetDays = await _generateTargetDaysForOverlapCheck(
        pattern: pattern,
      );

      if (targetDays.isEmpty) {
        AppLoading.dismissLoading();
        return;
      }

      final yearMonths = controller.selectedYearShift.value?.months;
      // ساخت Map شیفت‌های کل سال (remote + draft)
      final yearAssignments = ShiftOverlapChecker.buildYearAssignmentsMap(
        yearMonths: yearMonths,
        draftShifts: controller.draftShifts,
      );

      // todo: بررسی تداخل زمانی بدون در نظر گرفتن شیفت تایپ تارگت
      // بررسی تداخل با شیفت‌های موجود در کل سال
      final overlapResult = ShiftOverlapChecker.checkShiftOverlaps(
        targetDays: targetDays,
        // targetSlug: targetSlug,
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
        _editShiftTypeFlow(targetSlug);
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

      final validDays = overlapResult.validDays;
      final anyDraft = validDays.any(
        (final d) => controller.isShiftTypeInDraftOnly(
          targetSlug,
          controller.getDayKeyFromDayDate(d.dayDate),
        ),
      );

      if (anyDraft) {
        for (final day in validDays) {
          final dayKey = controller.getDayKeyFromDayDate(day.dayDate);
          if (!controller.isShiftTypeInDraftOnly(targetSlug, dayKey)) continue;
          final existingDraft = controller.draftShifts.firstWhereOrNull(
            (final d) => d.dayDate == day.dayDate,
          );
          if (existingDraft == null) continue;
          controller.draftShifts.remove(existingDraft);
          final slugs = <String>[...?existingDraft.shiftTypeSlugList];
          slugs.remove(targetSlug);
          slugs.add(shiftType.slug);
          controller.draftShifts.add(
            DailyShiftParams(
              dayDate: day.dayDate,
              isHoliday: day.isHoliday,
              isInMonth: day.isInMonth,
              shiftTypeSlugList: slugs,
            ),
          );
        }
        controller.draftShifts.refresh();
      } else {
        final daysDatesJalali = validDays.map((final d) => d.dayDate).toList(); // [yyyy-mm-dd] Jalali
        final success = await controller.replaceShiftTypeForDays(
          oldShiftTypeSlug: targetSlug,
          newShiftTypeSlug: shiftType.slug,
          daysDates: daysDatesJalali,
          newShiftType: shiftType,
        );

        if (success == false) {
          AppLoading.dismissLoading();
          AppNavigator.snackbarRed(title: s.error, subtitle: s.failedToApplyShift);
          // Retry with last pattern
          _editShiftTypeFlow(targetSlug);
        }
      }

      // Clear last pattern on success
      _lastPattern = null;

      AppLoading.dismissLoading();
    } catch (e) {
      AppLoading.dismissLoading();
      AppNavigator.snackbarRed(title: s.error, subtitle: s.failedToApplyShift);
      // Retry with last pattern
      _editShiftTypeFlow(targetSlug);
    }
  }

  /// تولید لیست روزهای تارگت بدون slug شیفت تایپ (برای بررسی تداخل)
  Future<List<DailyShiftParams>> _generateTargetDaysForOverlapCheck({
    required final DailyShiftRepeatPattern pattern,
  }) async {
    final year = controller.selectedJalaliMonth.value.year;
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
