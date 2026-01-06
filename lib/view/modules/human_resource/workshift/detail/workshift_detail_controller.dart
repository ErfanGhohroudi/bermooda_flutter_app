import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/loading/loading.dart';
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

  final RxList<YearShiftReadDto> yearShifts = <YearShiftReadDto>[].obs;
  final Rx<YearShiftReadDto?> selectedYearShift = Rx<YearShiftReadDto?>(null);

  final RxList<MonthShiftReadDto> monthShifts = <MonthShiftReadDto>[].obs;
  final Rx<MonthShiftReadDto?> selectedMonthShift = Rx<MonthShiftReadDto?>(null);

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
        AppNavigator.snackbarGreen(
          title: s.done,
          subtitle: isPersianLang ? 'تنظیم اولیه با موفقیت اعمال شد' : 'Initial setup applied successfully',
        );
      });
    }
    super.onInit();
  }

  @override
  void onClose() {
    _draftShiftsWorker.dispose();
    saveButtonState.close();
    selectedYearShift.close();
    selectedMonthShift.close();
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
      withRetry: false,
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
    final years = workShift.years.toList()..sort((final a, final b) => b.year.compareTo(a.year));
    yearShifts(years);
    pageState.loaded();

    if (yearShifts.isEmpty) return;

    final nowYear = Jalali.now().year;
    final initial = yearShifts.firstWhereOrNull((final y) => y.year == nowYear) ?? yearShifts.last;
    onYearSelected(initial);
  }

  void onYearSelected(final YearShiftReadDto? year) {
    if (year == null) return;
    if (selectedYearShift.value?.slug == year.slug) return;

    selectedYearShift(year);
    monthShifts.clear();
    selectedMonthShift(null);
    remoteDailyByDate.clear();
    assignmentsByDate.clear();

    _loadMonthShiftsFromModel(year);
  }

  /// Load months directly from the YearShiftReadDto model (no API call).
  void _loadMonthShiftsFromModel(final YearShiftReadDto year) {
    final months = year.months?.toList() ?? <MonthShiftReadDto>[];
    months.sort((final a, final b) => a.monthNumber.compareTo(b.monthNumber));
    monthShifts(months);

    if (monthShifts.isEmpty) return;

    final now = Jalali.now();
    final date = year.year == now.year ? now : Jalali(year.year, 1, 1);
    final initial =
        monthShifts.firstWhereOrNull(
          (final m) => m.monthNumber == date.month && (selectedYearShift.value?.year == date.year),
        ) ??
        monthShifts.first;
    onMonthSelected(initial);
  }

  void onMonthSelected(final MonthShiftReadDto? monthShift) {
    if (monthShift == null) return;
    if (selectedMonthShift.value?.slug == monthShift.slug) return;

    selectedMonthShift(monthShift);
    remoteDailyByDate.clear();
    assignmentsByDate.clear();

    final year = selectedYearShift.value?.year ?? Jalali.now().year;
    selectedJalaliMonth(Jalali(year, monthShift.monthNumber, 1));

    _loadDailyShiftsFromModel(monthShift);
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

  // ---------------------------------------------------------------------------
  // Day interactions
  // ---------------------------------------------------------------------------

  void onDayTap(final Jalali day) {
    final key = _dayKey(day);
    bottomSheetWithNoScroll<void>(
      title: s.details,
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
  // ShiftType CRUD (immediate remote)
  // ---------------------------------------------------------------------------

  Future<ShiftTypeReadDto> createShiftTypeAsync(final ShiftTypeParams shiftTypeParams) async {
    final completer = Completer<ShiftTypeReadDto>();
    shiftTypeDatasource.create(
      departmentSlug: departmentSlug,
      dto: shiftTypeParams,
      onResponse: (final response) {
        final st = response.result;
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

  Future<ShiftTypeReadDto> updateShiftTypeAsync({
    required final String slug,
    required final ShiftTypeParams params,
  }) async {
    final completer = Completer<ShiftTypeReadDto>();
    shiftTypeDatasource.update(
      slug: slug,
      dto: params,
      onResponse: (final response) {
        final st = response.result;
        if (st == null) {
          AppNavigator.snackbarRed(title: s.error, subtitle: 'Failed to update shift type');
          return;
        }
        final idx = sourceShiftTypes.indexWhere((final x) => x.slug == slug);
        if (idx != -1) {
          sourceShiftTypes[idx] = st;
          sourceShiftTypes.refresh();
        }
        shiftTypeRegistry[slug] = st;
        shiftTypeRegistry.refresh();
        completer.complete(st);
      },
      onError: (final errorResponse) => completer.completeError(StateError(errorResponse.message)),
    );
    return completer.future;
  }

  void deleteShiftTypeFromServer(final ShiftTypeReadDto shiftType) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: Colors.red,
      onYesButtonTap: () {
        UNavigator.back();
        shiftTypeDatasource.delete(
          slug: shiftType.slug,
          onResponse: () {
            _removeShiftType(shiftType);
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

  void _removeShiftType(final ShiftTypeReadDto st) {
    AppLoading.showLoading();

    // if draftShifts contains this shift type, remove it from draftShifts
    if (draftShifts.any((final d) => d.shiftTypeSlugList?.contains(st.slug) ?? false)) {
      Set<DailyShiftParams> drafts = Set.of(draftShifts);
      for (final d in drafts) {
        if (d.shiftTypeSlugList?.contains(st.slug) ?? false) {
          d.shiftTypeSlugList?.removeWhere((final s) => s == st.slug);
        }
      }
      draftShifts(drafts);
    }

    sourceShiftTypes.removeWhere((final x) => x.slug == st.slug);
    shiftTypeRegistry.remove(st.slug);
    shiftTypeRegistry.refresh();
    sourceShiftTypes.refresh();

    // Keep UI consistent for currently loaded days.
    for (final entry in assignmentsByDate.entries) {
      if (entry.value.contains(st.slug)) {
        entry.value.remove(st.slug);
      }
    }
    AppLoading.dismissLoading();
    assignmentsByDate.refresh();
  }

  void onSave() {
    if (draftShifts.isNotEmpty) {
      _dailyShiftDatasource.createBulk(
        workshiftSlug: workShiftSlug,
        days: draftShifts.toList(),
        onResponse: (final response) => UNavigator.back(),
        onError: (final errorResponse) {},
      );
    }
  }
}
