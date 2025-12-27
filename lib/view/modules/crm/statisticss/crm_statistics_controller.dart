import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/loading/loading.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin CrmStatisticsController {
  final CRMStatisticsDatasource _datasource = Get.find<CRMStatisticsDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.loading.obs;
  late final CrmCategoryReadDto _category;
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTop = false.obs;
  int _pageNumber = 1;
  bool _noMoreData = false;

  final Rx<StatisticsTimePeriodFilter> selectedTimePeriodFilter = StatisticsTimePeriodFilter.values.first.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<CrmUserStatisticsSummary> userStatisticsSummaries = <CrmUserStatisticsSummary>[].obs;
  final Rx<CrmStatisticsSummary> totalStatistics = const CrmStatisticsSummary(
    totalFollowUpsCount: 0,
    followingUpsCount: 0,
    successfulSaleCount: 0,
    delayedFollowUpsCount: 0,
    totalSeconds: "00:00:00",
  ).obs;

  bool get isAtEnd => _noMoreData;

  void initialController({required final CrmCategoryReadDto category}) {
    _category = category;
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
    userStatisticsSummaries.close();
    totalStatistics.close();
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
    AppLoading.showLoading();
    reloadStatistics();
  }

  void reloadStatistics() {
    _pageNumber = 1;
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

      if (totalStatistics.subject.isClosed) return;
      if (userStatisticsSummaries.subject.isClosed) return;
      totalStatistics(results[0] as CrmStatisticsSummary);
      userStatisticsSummaries(results[1] as List<CrmUserStatisticsSummary>);

      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
    AppLoading.dismissLoading();
  }

  Future<CrmStatisticsSummary> _getTotalStatistics() {
    final completer = Completer<CrmStatisticsSummary>();
    _datasource.getSummaries(
      categoryId: _category.id ?? '',
      timePeriodFilter: selectedTimePeriodFilter.value,
      onResponse: (final response) {
        CrmStatisticsSummary model = response.result ?? totalStatistics.value;
        completer.complete(model);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  Future<List<CrmUserStatisticsSummary>> _getUsersStatistics() {
    final completer = Completer<List<CrmUserStatisticsSummary>>();
    _datasource.getUsersSummaries(
      categoryId: _category.id ?? '',
      pageNumber: _pageNumber,
      timePeriodFilter: selectedTimePeriodFilter.value,
      query: searchCtrl.text,
      onResponse: (final response) {
        List<CrmUserStatisticsSummary> list = [];
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
