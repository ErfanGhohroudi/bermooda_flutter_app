import 'package:u/utilities.dart';

import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/time_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../data/data.dart';
import 'sheets/workshift_day_sheet.dart';

class WorkshiftDetailController extends GetxController {
  final String workShiftSlug;
  final String departmentSlug;
  final bool initialSetup;
  final RxSet<DailyShiftParams> draftShifts;

  WorkshiftDetailController({
    required this.workShiftSlug,
    required this.departmentSlug,
    this.initialSetup = false,
    final Set<DailyShiftParams>? draftShifts,
  }) : draftShifts = draftShifts != null ? draftShifts.obs : <DailyShiftParams>{}.obs;

  late WorkShiftReadDto workShift;
  late Worker _draftShiftsWorker;
  final WorkShiftDatasource _workShiftDatasource = Get.find<WorkShiftDatasource>();
  final DailyShiftDatasource _dailyShiftDatasource = Get.find<DailyShiftDatasource>();
  final ShiftTypeDatasource shiftTypeDatasource = Get.find<ShiftTypeDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> saveButtonState = PageState.loaded.obs;

  final Rx<YearShiftReadDto?> selectedYearShift = Rx<YearShiftReadDto?>(null);

  /// Jalali month (always day=1) used for rendering the calendar grid.
  final Rx<Jalali> selectedJalaliMonth = Jalali.now().withDay(1).obs;

  /// Source shift types for the folder (remote).
  final RxList<ShiftTypeReadDto> sourceShiftTypes = <ShiftTypeReadDto>[].obs;
  final RxMap<String, ShiftTypeReadDto> shiftTypeRegistry = <String, ShiftTypeReadDto>{}.obs;

  /// Remote daily shifts for the selected month, indexed by normalized day key.
  final RxMap<String, DailyShiftReadDto> remoteDailyByDate = <String, DailyShiftReadDto>{}.obs;

  /// Local UI assignments for the selected month, indexed by normalized day key.
  /// Values are the final set of shiftType slugs for that day (remote + edits).
  final RxMap<String, Set<String>> assignmentsByDate = <String, Set<String>>{}.obs;

  final bool haveAdminAccess = Get.find<PermissionService>().haveHRAdminAccess;

  @override
  void onInit() {
    _draftShiftsWorker = ever(draftShifts, (final _) => _rebuildAssignmentsForMonth());
    _bootstrap();
    if (initialSetup) {
      // Keep it simple: one-time info toast on entry after initial auto-populate.
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        AppNavigator.snackbarGreen(title: s.done, subtitle: s.initialSetupAppliedSuccessfully);
      });
    }
    super.onInit();
  }

  @override
  void onClose() {
    _draftShiftsWorker.dispose();
    saveButtonState.close();
    selectedYearShift.close();
    selectedJalaliMonth.close();
    sourceShiftTypes.close();
    shiftTypeRegistry.close();
    remoteDailyByDate.close();
    assignmentsByDate.close();
    super.onClose();
  }

  void onRefresh() {
    _bootstrap();
  }

  void _bootstrap() {
    pageState.loading();
    remoteDailyByDate.clear();
    assignmentsByDate.clear();
    _loadShiftTypes();
    _loadWorkShift();
  }

  void _loadShiftTypes() {
    shiftTypeDatasource.getAll(
      folderSlug: departmentSlug,
      pageNumber: 1,
      perPageCount: 200,
      onResponse: (final response) {
        sourceShiftTypes(response.resultList ?? <ShiftTypeReadDto>[]);
        shiftTypeRegistry.clear();
        for (final st in sourceShiftTypes) {
          shiftTypeRegistry[st.slug] = st;
        }
        shiftTypeRegistry.refresh();
      },
      onError: (final errorResponse) {},
    );
  }

  void _loadWorkShift() {
    _workShiftDatasource.getWorkShift(
      slug: workShiftSlug,
      onResponse: (final response) {
        final workShift = response.result;
        if (workShift == null) {
          pageState.error();
          return;
        }
        this.workShift = workShift;
        _loadYearShiftsFromModel();
      },
      onError: (final errorResponse) => pageState.error(),
    );
  }

  /// Load years directly from the workShift model (no API call).
  void _loadYearShiftsFromModel() {
    pageState.loaded();
    onYearSelected(selectedJalaliMonth.value.year);
  }

  void onYearSelected(final int year) {
    final years = workShift.years.toList();
    final yearShift = years.firstWhereOrNull((final y) => y.year == year);

    selectedJalaliMonth(selectedJalaliMonth.value.withYear(year));
    remoteDailyByDate.clear();
    assignmentsByDate.clear();

    selectedYearShift.value = yearShift;
    onMonthSelected(selectedJalaliMonth.value.month);
  }

  void onMonthSelected(final int month) {
    selectedJalaliMonth(selectedJalaliMonth.value.withMonth(month));

    final months = selectedYearShift.value?.months?.toList() ?? <MonthShiftReadDto>[];
    final monthShift = months.firstWhereOrNull(
      (final m) => m.monthNumber == month,
    );

    remoteDailyByDate.clear();
    if (monthShift != null) {
      _loadDailyShiftsFromModel(monthShift);
    } else {
      _rebuildAssignmentsForMonth();
    }
  }

  /// Load daily shifts directly from the MonthShiftReadDto model (no API call).
  void _loadDailyShiftsFromModel(final MonthShiftReadDto monthShift) {
    final days = monthShift.days ?? <DailyShiftReadDto>[];
    remoteDailyByDate.clear();
    for (final d in days) {
      remoteDailyByDate[_normalizeDayKey(d.dayDate)] = d;
    }
    remoteDailyByDate.refresh();
    _rebuildAssignmentsForMonth();
  }

  void _rebuildAssignmentsForMonth() {
    assignmentsByDate.clear();
    final month = selectedJalaliMonth.value;

    // 1. Build from remote data
    for (var day = 1; day <= month.monthLength; day++) {
      final key = _dayKey(month.withDay(day));
      final DailyShiftReadDto? remote = remoteDailyByDate[key];
      final set = <String>{...?(remote?.shiftTypes.map((final e) => e.slug).toList())};
      assignmentsByDate[key] = set;
    }

    // 2. Merge draft shifts for this month
    for (final draft in draftShifts) {
      final jalaliKey = _normalizeDayKey(draft.dayDate);
      // Check if this draft belongs to current month
      if (assignmentsByDate.containsKey(jalaliKey)) {
        final existing = assignmentsByDate[jalaliKey]!;
        existing.addAll(draft.shiftTypeSlugList ?? <String>[]);
      }
    }

    assignmentsByDate.refresh();
  }

  // convert gregorian dayDate to normalized day key (yyyy-MM-dd) Jalali
  String _normalizeDayKey(final String raw) {
    // Server `day_date` is Gregorian ISO yyyy-MM-dd. UI keys are Jalali yyyy-MM-dd.
    final parts = raw.split('-');
    if (parts.length != 3) return raw;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return raw;
    final dt = DateTime(y, m, d);
    return _dayKey(Jalali.fromDateTime(dt));
  }

  String _dayKey(final Jalali date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Public method to get day key from Jalali date.
  String getDayKeyFromJalali(final Jalali date) => _dayKey(date);

  /// Normalized day key (Jalali yyyy-MM-dd) from Gregorian dayDate.
  String getDayKeyFromDayDate(final String dayDate) => _normalizeDayKey(dayDate);

  // ---------------------------------------------------------------------------
  // Day interactions
  // ---------------------------------------------------------------------------

  void onDayTap(final Jalali day) {
    final key = _dayKey(day);
    bottomSheetWithNoScroll<void>(
      title: day.formatToDDmNYYYY,
      child: WorkshiftDaySheet(
        controller: this,
        day: day,
        dayKey: key,
      ),
    );
  }

  Set<String> getDayAssignments(final String dayKey) => assignmentsByDate[dayKey] ?? <String>{};

  void setDayAssignments(final String dayKey, final Set<String> newValue) {
    assignmentsByDate[dayKey] = newValue;
    assignmentsByDate.refresh();
  }

  // ---------------------------------------------------------------------------
  // ShiftType Draft Helpers
  // ---------------------------------------------------------------------------

  /// Checks if a shift type is in draft only (not yet saved) for a specific day.
  /// Returns true if the shift exists in draftShifts but NOT in remoteDailyByDate.
  bool isShiftTypeInDraftOnly(final String shiftTypeSlug, final String dayKey) {
    final remote = remoteDailyByDate[dayKey];
    if (remote != null && remote.shiftTypes.any((final st) => st.slug == shiftTypeSlug)) {
      return false; // It's from remote
    }
    return draftShifts.any((final draft) {
      final key = _normalizeDayKey(draft.dayDate);
      return key == dayKey && (draft.shiftTypeSlugList?.contains(shiftTypeSlug) ?? false);
    });
  }

  /// Checks if ALL days in the given range are draft only for the shift type.
  /// Returns true if the shift type does NOT exist in remote for any day in the range.
  bool areAllDaysInDraftOnly(final String shiftTypeSlug, final Jalali startDate, final Jalali endDate) {
    for (var day = startDate; day.compareTo(endDate) <= 0; day = day.addDays(1)) {
      final key = _dayKey(day);
      // If shift exists in remote for this day, not all days are draft only
      final remote = remoteDailyByDate[key];
      if (remote != null && remote.shiftTypes.any((final st) => st.slug == shiftTypeSlug)) {
        return false;
      }
    }
    return true;
  }

  /// Finds the first and last day (Jalali) where a shift type exists.
  /// Returns null if the shift type is not found in any day.
  (Jalali, Jalali)? getShiftTypeDateRange(final String shiftTypeSlug) {
    Jalali? minDate;
    Jalali? maxDate;

    // Check remoteDailyByDate
    for (final entry in remoteDailyByDate.entries) {
      final remote = entry.value;
      if (remote.shiftTypes.any((final st) => st.slug == shiftTypeSlug)) {
        final jalali = _parseJalaliFromKey(entry.key);
        if (jalali != null) {
          if (minDate == null || jalali.compareTo(minDate) < 0) minDate = jalali;
          if (maxDate == null || jalali.compareTo(maxDate) > 0) maxDate = jalali;
        }
      }
    }

    // Check draftShifts
    for (final draft in draftShifts) {
      if (draft.shiftTypeSlugList?.contains(shiftTypeSlug) ?? false) {
        final key = _normalizeDayKey(draft.dayDate);
        final jalali = _parseJalaliFromKey(key);
        if (jalali != null) {
          if (minDate == null || jalali.compareTo(minDate) < 0) minDate = jalali;
          if (maxDate == null || jalali.compareTo(maxDate) > 0) maxDate = jalali;
        }
      }
    }

    if (minDate == null || maxDate == null) return null;
    return (minDate, maxDate);
  }

  /// Parses a Jalali date from a day key (yyyy-MM-dd format).
  Jalali? _parseJalaliFromKey(final String key) {
    final parts = key.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return Jalali(y, m, d);
  }

  /// Removes a shift type from draft for a specific date range (local only).
  void removeShiftTypeFromDraftLocal(
    final String shiftTypeSlug,
    final Jalali startDate,
    final Jalali endDate, {
    required final bool isAllDays,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: isAllDays ? s.deleteShiftFromAllDaysQuestion : s.deleteShiftQuestion,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();

        final keysToRemove = <String>{};
        for (var day = startDate; day.compareTo(endDate) <= 0; day = day.addDays(1)) {
          keysToRemove.add(_dayKey(day));
        }

        final toRemove = <DailyShiftParams>[];
        final toAdd = <DailyShiftParams>[];

        for (final draft in draftShifts) {
          final key = _normalizeDayKey(draft.dayDate);
          if (keysToRemove.contains(key) && (draft.shiftTypeSlugList?.contains(shiftTypeSlug) ?? false)) {
            toRemove.add(draft);

            // If draft has other slugs, create new entry without the deleted slug
            final remainingSlugs = draft.shiftTypeSlugList?.where((final slug) => slug != shiftTypeSlug).toList();
            if (remainingSlugs != null && remainingSlugs.isNotEmpty) {
              toAdd.add(
                DailyShiftParams(
                  dayDate: draft.dayDate,
                  isHoliday: draft.isHoliday,
                  isInMonth: draft.isInMonth,
                  shiftTypeSlugList: remainingSlugs,
                ),
              );
            }
          }
        }

        for (final draft in toRemove) {
          draftShifts.remove(draft);
        }
        draftShifts.addAll(toAdd);
        draftShifts.refresh();

        // Also update assignmentsByDate for immediate UI update
        for (final key in keysToRemove) {
          assignmentsByDate[key]?.remove(shiftTypeSlug);
        }
        assignmentsByDate.refresh();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ShiftType CRUD (immediate remote)
  // ---------------------------------------------------------------------------

  Future<ShiftTypeReadDto> createShiftTypeAsync(final ShiftTypeParams shiftTypeParams) async {
    final completer = Completer<ShiftTypeReadDto>();
    shiftTypeDatasource.create(
      departmentSlug: departmentSlug,
      dto: shiftTypeParams,
      onResponse: (final response) {
        final ShiftTypeReadDto? st = response.result;
        if (st == null) {
          completer.completeError(StateError('Failed to create shift type'));
          return;
        }
        _insertShiftType(st);
        completer.complete(st);
      },
      onError: (final errorResponse) => completer.completeError(StateError(errorResponse.message)),
    );
    return completer.future;
  }

  Future<bool> replaceShiftTypeForDays({
    required final String oldShiftTypeSlug,
    required final ShiftTypeParams newShiftTypeParams,
    required final List<String> daysDates,
  }) async {
    final completer = Completer<bool>();
    shiftTypeDatasource.replaceInDays(
      departmentSlug: departmentSlug,
      oldSlug: oldShiftTypeSlug,
      newShiftTypeParams: newShiftTypeParams,
      workshiftSlug: workShiftSlug,
      daysDates: daysDates,
      onResponse: (final String? newShiftTypeSlug, final List<String> replacedDays) {
        final newShiftType = ShiftTypeReadDto(
          slug: newShiftTypeSlug ?? '',
          title: newShiftTypeParams.title,
          color: newShiftTypeParams.color,
          startTime: newShiftTypeParams.startTime,
          endTime: newShiftTypeParams.endTime,
          breakStartTime: newShiftTypeParams.breakStartTime,
          breakEndTime: newShiftTypeParams.breakEndTime,
          flexibleStartTime: newShiftTypeParams.flexibleStartTime,
          flexibleEndTime: newShiftTypeParams.flexibleEndTime,
          dailyOvertimeHours: newShiftTypeParams.dailyOvertimeHours,
          isHoliday: newShiftTypeParams.isHoliday,
          hasOffShiftAccess: newShiftTypeParams.hasOffShiftAccess,
          allowedCheckInMethodList: newShiftTypeParams.allowedCheckInMethodList,
          allowedCheckOutMethodList: newShiftTypeParams.allowedCheckOutMethodList,
          folderSlug: departmentSlug,
        );
        _insertShiftType(newShiftType);

        for (final dayDate in replacedDays) {
          final key = _normalizeDayKey(dayDate);
          final remote = remoteDailyByDate[key];
          if (remote != null) {
            final i = remote.shiftTypes.indexWhere((final st) => st.slug == oldShiftTypeSlug);
            if (i >= 0) {
              remote.shiftTypes[i] = newShiftType;
            }
          }
        }
        remoteDailyByDate.refresh();
        _rebuildAssignmentsForMonth();
        completer.complete(true);
      },
      onError: (final errorResponse) => completer.complete(false),
    );
    return completer.future;
  }

  void deleteShiftTypeFromDays(
    final ShiftTypeReadDto shiftType, {
    required final Jalali startDate,
    required final Jalali endDate,
    required final bool isAllDays,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: isAllDays ? s.deleteShiftFromAllDaysQuestion : s.deleteShiftQuestion,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        shiftTypeDatasource.deleteFromDays(
          slug: shiftType.slug,
          workshiftSlug: workShiftSlug,
          startDate: startDate,
          endDate: endDate,
          onResponse: () {
            _removeShiftTypeFromDays(
              shiftType,
              startDate: startDate,
              endDate: endDate,
              isAllDays: isAllDays,
            );
            AppNavigator.snackbarGreen(title: s.done, subtitle: s.changesSaved);
          },
          onError: (final errorResponse) {},
          withRetry: true,
        );
      },
    );
  }

  void _insertShiftType(final ShiftTypeReadDto st) {
    sourceShiftTypes.insert(0, st);
    shiftTypeRegistry[st.slug] = st;
    shiftTypeRegistry.refresh();
    sourceShiftTypes.refresh();
  }

  void _removeShiftTypeFromDays(
    final ShiftTypeReadDto st, {
    required final Jalali startDate,
    required final Jalali endDate,
    required final bool isAllDays,
  }) {
    // 1. Remove st from shiftTypeRegistry if isAllDays == true
    if (isAllDays) {
      sourceShiftTypes.removeWhere((final s) => s.slug == st.slug);
      shiftTypeRegistry.remove(st.slug);
      shiftTypeRegistry.refresh();
      sourceShiftTypes.refresh();
    }

    // Build set of day keys for the date range
    final keysInRange = <String>{};
    for (var day = startDate; day.compareTo(endDate) <= 0; day = day.addDays(1)) {
      keysInRange.add(_dayKey(day));
    }

    // 2. Remove st from draftShifts from startDate to endDate days
    final draftsToRemove = <DailyShiftParams>[];
    final draftsToAdd = <DailyShiftParams>[];
    for (final draft in draftShifts) {
      final key = _normalizeDayKey(draft.dayDate);
      if (keysInRange.contains(key) && (draft.shiftTypeSlugList?.contains(st.slug) ?? false)) {
        draftsToRemove.add(draft);

        // If draft has other slugs, create new entry without the deleted slug
        final remainingSlugs = draft.shiftTypeSlugList?.where((final slug) => slug != st.slug).toList();
        if (remainingSlugs != null && remainingSlugs.isNotEmpty) {
          draftsToAdd.add(
            DailyShiftParams(
              dayDate: draft.dayDate,
              isHoliday: draft.isHoliday,
              isInMonth: draft.isInMonth,
              shiftTypeSlugList: remainingSlugs,
            ),
          );
        }
      }
    }
    for (final draft in draftsToRemove) {
      draftShifts.remove(draft);
    }
    draftShifts.addAll(draftsToAdd);
    draftShifts.refresh();

    // 3. Remove st from remoteDailyByDate from startDate to endDate days
    for (final key in keysInRange) {
      final remote = remoteDailyByDate[key];
      if (remote != null) {
        remote.shiftTypes.removeWhere((final s) => s.slug == st.slug);
      }
    }
    remoteDailyByDate.refresh();

    // 4. Remove st from assignmentsByDate from startDate to endDate days
    for (final key in keysInRange) {
      assignmentsByDate[key]?.remove(st.slug);
    }

    assignmentsByDate.refresh();
  }

  void onSave() {
    if (draftShifts.isNotEmpty) {
      saveButtonState.loading();
      _dailyShiftDatasource.createBulk(
        workshiftSlug: workShiftSlug,
        days: draftShifts.toList(),
        onResponse: (final response) {
          saveButtonState.loaded();
          UNavigator.back();
        },
        onError: (final errorResponse) => saveButtonState.loaded(),
      );
    }
  }
}
