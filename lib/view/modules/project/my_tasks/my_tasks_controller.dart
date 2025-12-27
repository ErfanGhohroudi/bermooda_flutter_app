import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin MyTasksController {
  late final String _projectId;
  late final SubtaskDataSourceType _dataSourceType;
  final SubtaskDatasource _datasource = Get.find<SubtaskDatasource>();
  final RefreshController refreshController = RefreshController();
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<SubtaskReadDto> subtasks = <SubtaskReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<SubtaskFilter> selectedFilter = SubtaskFilter.values.first.obs;
  int pageNumber = 1;

  void disposeItems() {
    refreshController.dispose();
    searchCtrl.dispose();
    subtasks.close();
    pageState.close();
    selectedFilter.close();
  }

  void initialController({required final String projectId, required final SubtaskDataSourceType dataSourceType}) {
    _projectId = projectId;
    _dataSourceType = dataSourceType;
    onRefresh();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getMySubtasks();
  }

  void loadMore() {
    pageNumber++;
    _getMySubtasks();
  }

  void setFilter(final SubtaskFilter filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter(filter);
    pageState.loading();
    onRefresh();
  }

  void _getMySubtasks() {
    _datasource.getMySubtasks(
      dataSourceType: _dataSourceType,
      projectId: _projectId,
      pageNumber: pageNumber,
      filter: selectedFilter.value,
      query: searchCtrl.text.trim(),
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (subtasks.subject.isClosed) return;
        if (pageNumber == 1) {
          subtasks(response.resultList);
          refreshController.refreshCompleted();
        } else {
          subtasks.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: pageNumber == 1 && subtasks.isEmpty,
    );
  }
}
