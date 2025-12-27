import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';

mixin MemberMonthlyAttendanceStatsController {
  Timer? timer;
  final AttendanceDatasource _attendanceDatasource = Get.find<AttendanceDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<Jalali> dateSelected = Jalali.now().withDay(1).obs;
  final Rx<MemberAttendanceSummaryReadDto?> member = Rxn<MemberAttendanceSummaryReadDto>();

  int? get memberId;

  bool get isCurrentMonth => dateSelected.value.year == Jalali.now().year && dateSelected.value.month == Jalali.now().month;

  bool get increaseMonthIsEnable => isCurrentMonth == false;

  void disposeItems() {
    timer?.cancel();
    refreshController.dispose();
    pageState.close();
    dateSelected.close();
    member.close();
  }

  void initialController() {
    onRefreshWithLoading();
  }

  void onRefreshWithLoading() {
    pageState.initial();
    member.value = null;
    onRefresh();
  }

  Future<void> onRefresh() async {
    try {
      if (memberId == null) {
        pageState.error();
        pageState.refresh();
        return;
      }

      final result = await _getMemberMonthlyStatistics();

      if (pageState.subject.isClosed) return;

      member.value = result;
      refreshController.refreshCompleted();
      pageState.loaded();
      pageState.refresh();
    } catch (e) {
      if (pageState.isInitial() || pageState.isLoading()) {
        pageState.error();
        pageState.refresh();
        return;
      }
      refreshController.refreshFailed();
    }
  }

  void increaseMonth() {
    if (pageState.isLoading()) return;
    if (increaseMonthIsEnable) {
      timer?.cancel();
      dateSelected(dateSelected.value.addMonths(1).withDay(1));
      timer = Timer(const Duration(milliseconds: 500), () {
        onRefreshWithLoading();
      });
    }
  }

  void decreaseMonth() {
    if (pageState.isLoading()) return;
    timer?.cancel();
    dateSelected(dateSelected.value.addMonths(-1).withDay(1));
    timer = Timer(const Duration(milliseconds: 500), () {
      onRefreshWithLoading();
    });
  }

  Future<MemberAttendanceSummaryReadDto?> _getMemberMonthlyStatistics() async {
    final completer = Completer<MemberAttendanceSummaryReadDto?>();
    _attendanceDatasource.getMemberMonthlyAttendanceStats(
      memberId: memberId,
      month: dateSelected.value,
      onResponse: (final response) => completer.complete(response.result),
      onError: (final errorResponse) => completer.completeError(errorResponse),
    );
    return completer.future;
  }
}
