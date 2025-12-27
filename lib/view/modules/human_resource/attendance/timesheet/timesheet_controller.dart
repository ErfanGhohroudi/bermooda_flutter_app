import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';

mixin TimesheetController {
  Timer? timer;
  final AttendanceDatasource _attendanceDatasource = Get.find<AttendanceDatasource>();
  final Rx<Jalali> dateSelected = Jalali.now().obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  final RefreshController refreshController = RefreshController();
  TimesheetReadDto timesheet = TimesheetReadDto();

  bool get increaseMonthIsEnable =>
      !(dateSelected.value.year == Jalali.now().year && dateSelected.value.month == Jalali.now().month);

  bool get decreaseMonthIsEnable =>
      !(dateSelected.value.year == timesheet.membershipDate?.year && dateSelected.value.month == timesheet.membershipDate?.month);

  void disposeItem() {
    timer?.cancel();
    dateSelected.close();
    pageState.close();
    refreshController.dispose();
  }

  String formatSecondsToHoursMinutes(int? totalSeconds) {
    totalSeconds ??= 0;
    final duration = Duration(seconds: totalSeconds);
    final String hours = duration.inHours.toString().padLeft(2, '0');
    final String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  void increaseMonth() {
    if (increaseMonthIsEnable) {
      timer?.cancel();
      dateSelected(dateSelected.value.addMonths(1));
      timer = Timer(const Duration(milliseconds: 500), () {
        getTimesheet();
      });
    }
  }

  void decreaseMonth() {
    if (decreaseMonthIsEnable) {
      timer?.cancel();
      dateSelected(dateSelected.value.addMonths(-1));
      timer = Timer(const Duration(milliseconds: 500), () {
        getTimesheet();
      });
    }
  }

  void getTimesheet() {
    pageState.loading();
    _attendanceDatasource.getUserTimesheet(
      date: dateSelected.value,
      onResponse: (final response) {
        if (response.result != null) {
          timesheet = response.result!;
        }
        refreshController.refreshCompleted();
        pageState.loaded();
      },
      onError: (final errorResponse) {
        refreshController.refreshFailed();
        pageState.error();
      },
    );
  }
}
