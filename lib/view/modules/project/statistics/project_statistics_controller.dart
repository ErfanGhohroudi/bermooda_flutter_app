import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin ProjectStatisticsController {
  final ProjectStatisticsDatasource _datasource = Get.find<ProjectStatisticsDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.loading.obs;
  late final ProjectReadDto _project;
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTop = false.obs;
  int _pageNumber = 1;
  bool _noMoreData = false;

  final Rx<StatisticsTimePeriodFilter> selectedTimePeriodFilter = StatisticsTimePeriodFilter.values.first.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<ProjectUserStatisticsSummary> userStatisticsSummaries = <ProjectUserStatisticsSummary>[].obs;
  final Rx<ProjectStatisticsSummary> totalStatistics = const ProjectStatisticsSummary(
    doneTasksCount: 0,
    overdueTasksCount: 0,
    runningTasksCount: 0,
    totalSeconds: 0,
    totalTasksCount: 0,
    withoutTimingTasksCount: 0,
  ).obs;

  bool get isAtEnd => _noMoreData;

  void initialController({required final ProjectReadDto project}) {
    _project = project;
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
    pageState.loading();
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
      final results = await Future.wait([_getTotalStatistics(), _getUsersStatistics()]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('timed out'),
      );

      if (totalStatistics.subject.isClosed) return;
      if (userStatisticsSummaries.subject.isClosed) return;
      totalStatistics(results[0] as ProjectStatisticsSummary);
      userStatisticsSummaries(results[1] as List<ProjectUserStatisticsSummary>);

      pageState.loaded();
    } catch (e) {
      if (pageState.subject.isClosed) return;
      pageState.error();
    }
  }

  Future<ProjectStatisticsSummary> _getTotalStatistics() {
    final completer = Completer<ProjectStatisticsSummary>();
    _datasource.getSummaries(
      projectId: _project.id ?? '',
      timePeriodFilter: selectedTimePeriodFilter.value,
      onResponse: (final response) {
        ProjectStatisticsSummary model = response.result ?? totalStatistics.value;
        completer.complete(model);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  Future<List<ProjectUserStatisticsSummary>> _getUsersStatistics() {
    final completer = Completer<List<ProjectUserStatisticsSummary>>();
    _datasource.getUsersSummaries(
      projectId: _project.id ?? '',
      pageNumber: _pageNumber,
      timePeriodFilter: selectedTimePeriodFilter.value,
      query: searchCtrl.text,
      onResponse: (final response) {
        List<ProjectUserStatisticsSummary> list = [];
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
