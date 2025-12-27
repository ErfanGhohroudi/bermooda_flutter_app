import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';

mixin MonthlyAttendanceStatsController {
  Timer? timer;
  final AttendanceDatasource _attendanceDatasource = Get.find<AttendanceDatasource>();
  final RefreshController refreshController = RefreshController();
  final ScrollController horizontalScrollController = ScrollController();
  final List<ScrollController> employeeRowScrollControllers = [];
  bool _isScrolling = false;
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<Jalali> dateSelected = Jalali.now().withDay(1).obs;
  final RxList<MemberAttendanceSummaryReadDto> members = <MemberAttendanceSummaryReadDto>[].obs;
  final Rx<AttendanceStatisticsSummaryReadDto?> statisticsSummary = Rxn<AttendanceStatisticsSummaryReadDto>();

  String get departmentSlug;

  bool get isCurrentMonth => dateSelected.value.year == Jalali.now().year && dateSelected.value.month == Jalali.now().month;

  bool get increaseMonthIsEnable => isCurrentMonth == false;

  void disposeItems() {
    timer?.cancel();
    refreshController.dispose();
    _clearEmployeeRowScrollControllers();
    horizontalScrollController.removeListener(_onHeaderScroll);
    horizontalScrollController.dispose();
    pageState.close();
    dateSelected.close();
    members.close();
    statisticsSummary.close();
  }

  void initialController() {
    _setupScrollSync();
    onRefreshWithLoading();
  }

  void _setupScrollSync() {
    horizontalScrollController.addListener(_onHeaderScroll);
  }

  void _onHeaderScroll() {
    if (_isScrolling) return;
    _isScrolling = true;
    final offset = horizontalScrollController.offset;
    for (final controller in employeeRowScrollControllers) {
      if (controller.hasClients && controller.offset != offset) {
        controller.jumpTo(offset);
      }
    }
    _isScrolling = false;
  }

  void _onEmployeeRowScroll(final ScrollController controller) {
    if (_isScrolling) return;
    _isScrolling = true;
    final offset = controller.offset;
    if (horizontalScrollController.hasClients && horizontalScrollController.offset != offset) {
      horizontalScrollController.jumpTo(offset);
    }
    for (final otherController in employeeRowScrollControllers) {
      if (otherController != controller && otherController.hasClients && otherController.offset != offset) {
        otherController.jumpTo(offset);
      }
    }
    _isScrolling = false;
  }

  ScrollController createEmployeeRowScrollController() {
    final controller = ScrollController();
    controller.addListener(() => _onEmployeeRowScroll(controller));
    employeeRowScrollControllers.add(controller);
    return controller;
  }

  void onRefreshWithLoading() {
    pageState.initial();
    members.clear();
    statisticsSummary.value = null;
    _clearEmployeeRowScrollControllers();
    onRefresh();
  }

  void _clearEmployeeRowScrollControllers() {
    for (final controller in employeeRowScrollControllers) {
      controller.dispose();
    }
    employeeRowScrollControllers.clear();
  }

  Future<void> onRefresh() async {
    try {
      final results = await Future.wait([
        _getMonthlyStatistics(),
        _getStatisticsSummary(),
      ]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('timed out'),
      );

      if (pageState.subject.isClosed) return;

      members.value = results[0] as List<MemberAttendanceSummaryReadDto>;
      statisticsSummary.value = results[1] as AttendanceStatisticsSummaryReadDto?;
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

  Future<List<MemberAttendanceSummaryReadDto>> _getMonthlyStatistics() async {
    final completer = Completer<List<MemberAttendanceSummaryReadDto>>();
    _attendanceDatasource.getMonthlyAttendanceStats(
      departmentSlug: departmentSlug,
      month: dateSelected.value,
      onResponse: (final response) => completer.complete(response.resultList ?? []),
      onError: (final errorResponse) => completer.completeError(errorResponse),
    );
    return completer.future;
  }

  Future<AttendanceStatisticsSummaryReadDto?> _getStatisticsSummary() async {
    final completer = Completer<AttendanceStatisticsSummaryReadDto?>();
    _attendanceDatasource.getOverallAttendanceStatsSummary(
      departmentSlug: departmentSlug,
      month: dateSelected.value,
      onResponse: (final response) => completer.complete(null),
      onError: (final errorResponse) {
        // اگر endpoint آمار موجود نبود، null برمی‌گردانیم
        completer.complete(null);
      },
    );
    return completer.future;
  }
}
