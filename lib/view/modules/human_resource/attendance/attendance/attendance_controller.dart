import 'package:action_slider/action_slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/loading/loading.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../../../../core/core.dart';
import 'barcode_scanner/screen/barcode_scanner_screen_page.dart';
import 'helpers/location_helper.dart';

mixin AttendanceController {
  final core = Get.find<Core>();
  late final LocationHelper _locationHelper;
  final AttendanceDatasource _attendanceDatasource = Get.find<AttendanceDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;

  final ActionSliderController actionSliderController = ActionSliderController();

  ShiftStatusReadDto shiftStatus = NoData(message: null, uuid: '');

  bool get isCheckIn => shiftStatus.isCheckIn;

  bool get isCheckOut => shiftStatus.isCheckOut;

  bool get isCheckInORCheckOut => shiftStatus.isCheckInOrCheckOut;

  void disposeItems() {
    refreshController.dispose();
    pageState.close();
    actionSliderController.dispose();
  }

  void initialController() {
    _locationHelper = LocationHelper(actionSliderController);
    onRefreshWithLoading();
  }

  void onRefreshWithLoading() {
    pageState.initial();
    onRefresh();
  }

  Future<void> onRefresh() async {
    try {
      final result = await Future.wait([_checkShiftStatus()]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('timed out'),
      );

      if (pageState.subject.isClosed) return;

      shiftStatus = result[0];

      refreshController.refreshCompleted();
      actionSliderController.reset();
      pageState.loaded();
      pageState.refresh();
    } catch (e) {
      if (pageState.isInitial() || pageState.isLoading()) {
        pageState.error();
        pageState.refresh();
        return;
      }

      refreshController.refreshFailed();
      actionSliderController.reset();
    }
  }

  void attendanceRegistration(final BuildContext context) {
    _locationHelper.getLocationPermission(action: () {
      _registration(context);
    });
  }

  void _registration(final BuildContext context) async {
    if (shiftStatus.isCheckInOrCheckOut == false) return;

    final selectedMethod = shiftStatus.allowedMethods.firstOrNull;

    if (selectedMethod == null) {
      actionSliderController.reset();
      return;
    }

    final actionType = shiftStatus.modalType!;

    switch (selectedMethod) {
      case AttendanceMethod.manual:
        return _changeActivityStatus(actionType: actionType, method: AttendanceMethod.manual, uuid: shiftStatus.uuid);
      case AttendanceMethod.qr_code:
        return _pushToScannerScreen(actionType);
    }
  }

  /// Register Attendance by qr_code
  void _pushToScannerScreen(final AttendanceModalType actionType) {
    UNavigator.push(BarcodeScannerScreen(
      action: (final uuid) => _changeActivityStatus(
        actionType: actionType,
        method: AttendanceMethod.qr_code,
        uuid: uuid,
      ),
      onPopScope: () => actionSliderController.reset(),
    ));
  }

  void _changeActivityStatus({
    required final AttendanceModalType actionType,
    required final AttendanceMethod method,
    required final String uuid,
  }) async {
    actionSliderController.loading();
    AppLoading.showLoading();

    final currentLocation = await _getCurrentLocation();

    if (currentLocation == null) {
      AppLoading.dismissLoading();
      actionSliderController.failure();
      await Future.delayed(const Duration(seconds: 2));
      actionSliderController.reset();
      return;
    }

    _attendanceDatasource.checkInOut(
      dto: CheckInOutParams(
        type: actionType,
        method: method,
        lat: currentLocation.latitude,
        long: currentLocation.longitude,
        uuid: uuid,
      ),
      onResponse: (final response) async {
        UNavigator.back();
        delay(50, () {
          AppNavigator.snackbarGreen(title: s.done, subtitle: response.message);
        });
      },
      onError: (final errorResponse) async {
        onRefreshWithLoading();
        actionSliderController.failure();
        // await Future.delayed(const Duration(seconds: 2));
        // actionSliderController.reset();
      },
    );
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: 10.seconds,
      ));

      return position;
    } on TimeoutException {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.locationTimeLimit,
      );
      return null;
    } catch (e) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.locationFailedError,
      );
      return null;
    }
  }

  Future<ShiftStatusReadDto> _checkShiftStatus() async {
    final completer = Completer<ShiftStatusReadDto>();
    _attendanceDatasource.checkShiftStatus(
      onResponse: (final ShiftStatusReadDto response) {
        completer.complete(response);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  /// Helper Functions

  String get shiftWorkTime {
    String? startTime;
    String? endTime;
    if (shiftStatus is CheckInModal) {
      final shift = shiftStatus as CheckInModal;
      startTime = shift.shiftInfo?.startTime;
      endTime = shift.shiftInfo?.endTime;
    } else if (shiftStatus is CheckOutModal) {
      final shift = shiftStatus as CheckOutModal;
      startTime = shift.shiftInfo?.startTime;
      endTime = shift.shiftInfo?.endTime;
    }
    if (startTime == null || endTime == null) {
      return '';
    }
    return '${s.from} $startTime ${s.to} $endTime';
  }

  AttendanceTimeStatus? get timeStatus {
    if (shiftStatus is CheckInModal) {
      final shift = shiftStatus as CheckInModal;
      return shift.timeStatus;
    }

    return null;
  }

  int get minutesDifference {
    if (shiftStatus is CheckInModal) {
      final shift = shiftStatus as CheckInModal;
      return shift.minutesDifference ?? 0;
    }

    return 0;
  }

  String get minutesDifferenceFormatted {
    final d = Duration(minutes: minutesDifference);
    final h = d.inHours;
    final m = (d.inMinutes % 60);

    final hours = "$h ${h <= 1 && isPersianLang == false ? s.hours.removeLast().toLowerCase() : s.hours.toLowerCase()}";
    final minutes = "$m ${m <= 1 && isPersianLang == false ? s.minutes.removeLast().toLowerCase() : s.minutes.toLowerCase()}";

    if (h == 0) {
      return minutes;
    }
    if (m == 0) {
      return hours;
    }

    return "$hours $minutes";
  }
}
