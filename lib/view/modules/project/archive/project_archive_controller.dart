import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin ProjectArchiveController {
  late final String _projectId;
  final TaskArchiveDatasource _datasource = Get.find<TaskArchiveDatasource>();
  final PermissionService _perService = Get.find<PermissionService>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final RxList<TaskReadDto> tasks = <TaskReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<ProjectArchiveFilter> selectedFilter = ProjectArchiveFilter.all.obs;
  int pageNumber = 1;
  bool isAtEnd = false;

  bool get haveAdminAccess => _perService.haveProjectAdminAccess;

  void disposeItems() {
    scrollController.removeListener(scrollListener);
    refreshController.dispose();
    scrollController.dispose();
    showScrollToTop.close();
    tasks.close();
    pageState.close();
    selectedFilter.close();
  }

  void initialController(final String projectId) {
    _projectId = projectId;
    scrollController.addListener(scrollListener);
    onRefresh();
  }

  void scrollListener() {
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onRefresh() {
    pageNumber = 1;
    _getTasks();
  }

  void loadMore() {
    pageNumber++;
    _getTasks();
  }

  void setFilter(final ProjectArchiveFilter filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter(filter);
    pageState.loading();
    onRefresh();
  }

  void _getTasks() {
    _datasource.getAllTasks(
      projectId: _projectId,
      pageNumber: pageNumber,
      filter: selectedFilter.value,
      onResponse: (final response) {
        if (tasks.subject.isClosed || response.resultList == null) return;
        if (pageNumber == 1) {
          tasks.assignAll(response.resultList!);
          refreshController.refreshCompleted();
        } else {
          tasks.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          isAtEnd = true;
        } else {
          refreshController.loadComplete();
          isAtEnd = false;
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
      withRetry: pageNumber == 1 && tasks.isEmpty,
    );
  }

  void restoreTask(final int? taskId) {
    if (taskId == null) return;
    if (!haveAdminAccess) return AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);

    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreTask(taskId);
      },
    );
  }

  void _restoreTask(final int? taskId) {
    _datasource.restoreATask(
      taskId: taskId,
      onResponse: (final response) {
        if (tasks.subject.isClosed) return;
        tasks.removeWhere((final e) => e.id == taskId);
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
