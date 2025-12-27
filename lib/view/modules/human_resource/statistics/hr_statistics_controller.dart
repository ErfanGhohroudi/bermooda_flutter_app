import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin HRStatisticsController {
  final HRStatisticsDatasource _datasource = Get.find<HRStatisticsDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.loading.obs;
  late final HRDepartmentReadDto _department;
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTop = false.obs;
  int _pageNumber = 1;
  bool _noMoreData = false;

  final Rx<StatisticsTimePeriodFilter> selectedTimePeriodFilter = StatisticsTimePeriodFilter.values.first.obs;
  final TextEditingController searchCtrl = TextEditingController();
  int usersCount = 0;
  final Rx<HrStatisticsSummary> totalStatistics = const HrStatisticsSummary(
    totalRequestCount: 0,
    pendingReviewCount: 0,
    closedRequestCount: 0,
    delayedRequestCount: 0,
    unassignedRequestsCount: 0,
  ).obs;
  final RxList<HRUserStatisticsSummary> userStatisticsSummaries = <HRUserStatisticsSummary>[].obs;

  bool get isAtEnd => _noMoreData;

  void initialController({required final HRDepartmentReadDto department}) {
    _department = department;
    scrollController.addListener(_scrollListener);
    _getAllData();
  }

  void disposeItems() {
    scrollController.removeListener(_scrollListener);
    refreshController.dispose();
    pageState.close();
    scrollController.dispose();
    showScrollToTop.close();
    selectedTimePeriodFilter.close();
    searchCtrl.dispose();
    totalStatistics.close();
    userStatisticsSummaries.close();
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void setFilter(final StatisticsTimePeriodFilter filter) {
    if (selectedTimePeriodFilter.value == filter) return;
    selectedTimePeriodFilter(filter);
    pageState.loading();
    reloadStatistics();
  }

  void reloadStatistics() {
    _pageNumber = 1;
    usersCount = 0;
    _noMoreData = false;
    _getAllData();
  }

  void onLoading() async {
    _pageNumber++;
    if (!_noMoreData) {
      try {
        final list = await _getUsersStatistics();
        userStatisticsSummaries(list);
      } catch (e) {}
    }
  }

  void onRetry() {
    pageState.loading();
    reloadStatistics();
  }

  void _getAllData() async {
    try {
      final results = await Future.wait([
        _getTotalStatistics(),
        _getUsersStatistics(),
      ]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('timed out'),
      );

      // if (totalStatistics.subject.isClosed) return;
      if (userStatisticsSummaries.subject.isClosed) return;
      totalStatistics(results[0] as HrStatisticsSummary);
      userStatisticsSummaries(results[1] as List<HRUserStatisticsSummary>);

      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
  }

  Future<HrStatisticsSummary> _getTotalStatistics() {
    final completer = Completer<HrStatisticsSummary>();
    _datasource.getOverallSummaries(
      slug: _department.slug ?? '',
      timePeriodFilter: selectedTimePeriodFilter.value,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError("null");
        completer.complete(response.result!);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  Future<List<HRUserStatisticsSummary>> _getUsersStatistics() {
    final completer = Completer<List<HRUserStatisticsSummary>>();
    _datasource.getUserSummaries(
      slug: _department.slug ?? '',
      pageNumber: _pageNumber,
      timePeriodFilter: selectedTimePeriodFilter.value,
      query: searchCtrl.text,
      onResponse: (final response) {
        usersCount = response.extra?.count ?? 0;
        List<HRUserStatisticsSummary> list = [];
        if (_pageNumber == 1) {
          list = response.resultList ?? [];
          refreshController.refreshCompleted();
        } else {
          list = [...userStatisticsSummaries];
          list.addAll(response.resultList ?? []);
        }

        if (response.extra?.next == null || (response.resultList?.isEmpty ?? true)) {
          refreshController.loadNoData();
          _noMoreData = true;
        } else {
          refreshController.loadComplete();
          _noMoreData = false;
        }

        completer.complete(list);
      },
      onError: (final errorResponse) {
        if (_pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }
}
