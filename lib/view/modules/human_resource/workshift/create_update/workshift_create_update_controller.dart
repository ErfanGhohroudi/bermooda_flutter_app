import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/loading/loading.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../detail/workshift_detail_page.dart';
import '../utils/generate_daily_shift_params.dart';
import '../workshift_list_controller.dart';
import 'enums/workshift_mode_status.dart';
import 'models/daily_shift_repeat_pattern.dart';
import '../sheets/daily_shift_repeat_pattern_sheet.dart';

mixin WorkshiftCreateUpdateController {
  WorkShiftReadDto? _workShift;
  late final String _departmentSlug;

  final Rx<WorkshiftModeStatus> _modeStatus = WorkshiftModeStatus.creating.obs;

  final WorkShiftDatasource _workShiftDatasource = Get.find();
  final YearShiftDatasource _yearShiftDatasource = Get.find();
  final ShiftTypeDatasource _shiftTypeDatasource = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;

  /// Draft days generated/returned during initial setup (for feeding month calendar if needed).
  final RxSet<DailyShiftParams> draftShifts = <DailyShiftParams>{}.obs;

  /// Last pattern entered by user (for retry on error).
  DailyShiftRepeatPattern? _lastPattern;

  final TextEditingController titleCtrl = TextEditingController();
  late final TextEditingController overtimeHoursCtrl;
  late final TextEditingController missionHoursCtrl;
  late final TextEditingController leaveHoursCtrl;
  late final TextEditingController leaveEarlyHoursCtrl;
  late final TextEditingController overdueHoursCtrl;

  void disposeItems() {
    _modeStatus.close();
    buttonState.close();
    titleCtrl.dispose();
    overtimeHoursCtrl.dispose();
    missionHoursCtrl.dispose();
    leaveHoursCtrl.dispose();
    leaveEarlyHoursCtrl.dispose();
    overdueHoursCtrl.dispose();
    draftShifts.close();
  }

  void initialController({
    required final WorkShiftReadDto? workShift,
    required final String departmentSlug,
  }) {
    _workShift = workShift;
    _departmentSlug = departmentSlug;

    // Default values
    overtimeHoursCtrl = TextEditingController(text: '104');
    missionHoursCtrl = TextEditingController(text: '100');
    leaveHoursCtrl = TextEditingController(text: '20');
    leaveEarlyHoursCtrl = TextEditingController(text: '2');
    overdueHoursCtrl = TextEditingController(text: '2');

    if (workShift == null) {
      _modeStatus.creating();
    } else {
      _modeStatus.updating();
      _setValues(workShift);
    }
  }

  bool get isChanged =>
      _workShift?.title.trim() != titleCtrl.text.trim() ||
      _workShift?.allowedOvertimeHoursNumber != _parseIntOrNull(overtimeHoursCtrl.text) ||
      _workShift?.allowedLeaveHoursNumber != _parseIntOrNull(leaveHoursCtrl.text) ||
      _workShift?.allowedMissionHoursNumber != _parseIntOrNull(missionHoursCtrl.text) ||
      _workShift?.allowedLeaveEarlyHoursNumber != _parseIntOrNull(leaveEarlyHoursCtrl.text) ||
      _workShift?.allowedOverdueHoursNumber != _parseIntOrNull(overdueHoursCtrl.text);

  void _setValues(final WorkShiftReadDto workShift) {
    titleCtrl.text = workShift.title;
    overtimeHoursCtrl.text = workShift.allowedOvertimeHoursNumber?.toString() ?? '';
    leaveHoursCtrl.text = workShift.allowedLeaveHoursNumber?.toString() ?? '';
    missionHoursCtrl.text = workShift.allowedMissionHoursNumber?.toString() ?? '';
    leaveEarlyHoursCtrl.text = workShift.allowedLeaveEarlyHoursNumber?.toString() ?? '';
    overdueHoursCtrl.text = workShift.allowedOverdueHoursNumber?.toString() ?? '';
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        switch (_modeStatus.value) {
          case WorkshiftModeStatus.creating:
            create();
            break;
          case WorkshiftModeStatus.updating:
            if (isChanged) {
              update();
            } else {
              _navigateToShiftDetails(initialSetup: false);
            }
            break;
          case WorkshiftModeStatus.created:
            _createYearShift();
            break;
          case WorkshiftModeStatus.updated:
            _navigateToShiftDetails(initialSetup: false);
            break;
        }
      },
    );
  }

  int? _parseIntOrNull(final String? value) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value);
  }

  void create() {
    buttonState.loading();
    _workShiftDatasource.create(
      title: titleCtrl.text.trim(),
      departmentSlug: _departmentSlug,
      allowedOvertimeHoursNumber: _parseIntOrNull(overtimeHoursCtrl.text),
      allowedLeaveHoursNumber: _parseIntOrNull(leaveHoursCtrl.text),
      allowedMissionHoursNumber: _parseIntOrNull(missionHoursCtrl.text),
      allowedLeaveEarlyHoursNumber: _parseIntOrNull(leaveEarlyHoursCtrl.text),
      allowedOverdueHoursNumber: _parseIntOrNull(overdueHoursCtrl.text),
      onResponse: (final response) {
        if (response.result == null) return;

        if (Get.isRegistered<WorkshiftListController>()) {
          Get.find<WorkshiftListController>().insertWorkShift(response.result!);
        }

        _workShift = response.result!;
        _modeStatus.created();
        buttonState.loaded();
        _postCreateFlow();
      },
      onError: (final errorResponse) {
        AppSnackBar.snackbarRed(title: s.error, subtitle: errorResponse.message);
        buttonState.loaded();
      },
    );
  }

  void update() {
    buttonState.loading();
    _workShiftDatasource.update(
      slug: _workShift?.slug,
      title: titleCtrl.text.trim(),
      allowedOvertimeHoursNumber: _parseIntOrNull(overtimeHoursCtrl.text),
      allowedLeaveHoursNumber: _parseIntOrNull(leaveHoursCtrl.text),
      allowedMissionHoursNumber: _parseIntOrNull(missionHoursCtrl.text),
      allowedLeaveEarlyHoursNumber: _parseIntOrNull(leaveEarlyHoursCtrl.text),
      allowedOverdueHoursNumber: _parseIntOrNull(overdueHoursCtrl.text),
      onResponse: (final response) {
        if (response.result == null) return;

        if (Get.isRegistered<WorkshiftListController>()) {
          Get.find<WorkshiftListController>().updateWorkShift(response.result!);
        }

        _workShift = response.result!;
        _modeStatus.updated();
        buttonState.loaded();
        _navigateToShiftDetails(initialSetup: false);
      },
      onError: (final errorResponse) {
        AppSnackBar.snackbarRed(title: s.error, subtitle: errorResponse.message);
        buttonState.loaded();
      },
    );
  }

  void _createYearShift() {
    if (_modeStatus.value.isCreated == false || _workShift == null) return;

    buttonState.loading();
    _yearShiftDatasource.create(
      year: Jalali.now().year,
      workshiftSlug: _workShift!.slug,
      isMonth: true,
      onResponse: (final response) {
        if (response.result == null) return;
        buttonState.loaded();
        _navigateToShiftDetails(initialSetup: false);
      },
      onError: (final errorResponse) {
        AppSnackBar.snackbarRed(title: s.error, subtitle: errorResponse.message);
        buttonState.loaded();
      },
    );
  }

  void _navigateToShiftDetails({required final bool initialSetup}) {
    if (_workShift?.slug == null) return;
    AppNavigator.off(
      WorkshiftDetailPage(
        workShiftSlug: _workShift!.slug,
        departmentSlug: _departmentSlug,
        initialSetup: initialSetup,
        draftShifts: draftShifts.isNotEmpty ? draftShifts : null,
      ),
    );
  }

  Future<void> _postCreateFlow() async {
    // Create-only: ask for initial pattern, then auto-populate the calendar.
    if (_workShift == null) return;

    final pattern = await bottomSheetWithNoScroll<DailyShiftRepeatPattern>(
      title: s.initialShiftSetup,
      child: DailyShiftRepeatPatternSheet(
        initialPattern: _lastPattern,
        isInitialSetup: true,
      ),
    );

    // If user dismissed: keep previous behavior (create year + navigate).
    if (pattern == null) return;

    // Save pattern for potential retry
    _lastPattern = pattern;

    buttonState.loading();
    AppLoading.showLoading();
    try {
      final yearShift = await _createYearShiftAsync();
      final shiftType = await _createShiftTypeAsync(pattern.shiftTypeParams);

      final List<DailyShiftParams> days = await generateDailyShiftParams(
        pattern: pattern,
        yearShift: yearShift,
        shiftType: shiftType,
      );

      draftShifts.assignAll(days);

      // Clear last pattern on success
      _lastPattern = null;

      AppLoading.dismissLoading();
      buttonState.loaded();
      _navigateToShiftDetails(initialSetup: true);
    } catch (e) {
      AppLoading.dismissLoading();
      buttonState.loaded();
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.failedToApplyShift);
      // Retry with last pattern
      _postCreateFlow();
    }
  }

  List<DailyShiftParams> getDraftShifts() => draftShifts.toList();

  Future<YearShiftReadDto> _createYearShiftAsync() async {
    final completer = Completer<YearShiftReadDto>();
    _yearShiftDatasource.create(
      year: Jalali.now().year,
      workshiftSlug: _workShift!.slug,
      isMonth: true,
      onResponse: (final response) {
        final y = response.result;
        if (y == null) {
          completer.completeError(StateError('Failed to create year shift'));
          return;
        }
        completer.complete(y);
      },
      onError: (final errorResponse) => completer.completeError(StateError(errorResponse.message)),
      withRetry: true,
    );
    return completer.future;
  }

  Future<ShiftTypeReadDto> _createShiftTypeAsync(final ShiftTypeParams shiftTypeParams) async {
    final completer = Completer<ShiftTypeReadDto>();
    _shiftTypeDatasource.create(
      departmentSlug: _departmentSlug,
      dto: shiftTypeParams,
      onResponse: (final response) {
        final st = response.result;
        if (st == null) {
          completer.completeError(StateError('Failed to create shift type'));
          return;
        }
        completer.complete(st);
      },
      onError: (final errorResponse) => completer.completeError(StateError(errorResponse.message)),
      withRetry: true,
    );
    return completer.future;
  }
}
