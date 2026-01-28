import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../list/project_list_controller.dart';

class ArchivedProjectsController extends GetxController {
  final ProjectDatasource _datasource = Get.find<ProjectDatasource>();
  final PermissionService _permissionService = Get.find<PermissionService>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<ProjectReadDto> projects = <ProjectReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  bool get isAtEnd => _isAtEnd;
  bool get haveAdminAccess => _permissionService.haveProjectAdminAccess;

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    onRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    refreshController.dispose();
    scrollController.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onRefresh() {
    _pageNumber = 1;
    _getArchivedProjects();
  }

  void loadMore() {
    _pageNumber++;
    _getArchivedProjects();
  }

  void _getArchivedProjects() {
    _datasource.getArchivedProjects(
      pageNumber: _pageNumber,
      query: searchCtrl.text.trim().isEmpty ? null : searchCtrl.text.trim(),
      onResponse: (final response) {
        if (projects.subject.isClosed || response.resultList == null) return;
        if (_pageNumber == 1) {
          projects(response.resultList);
          refreshController.refreshCompleted();
        } else {
          projects.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          _isAtEnd = true;
        } else {
          refreshController.loadComplete();
          _isAtEnd = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.isInitial()) {
          pageState.error();
        }
        if (_pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
    );
  }

  void restoreProject(final String? projectId) {
    if (!haveAdminAccess) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }

    if (projectId == null) return;

    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreProject(projectId);
      },
    );
  }

  void _restoreProject(final String projectId) {
    _datasource.restoreProject(
      projectId: projectId,
      onResponse: (final response) {
        projects.removeWhere((final e) => e.id == projectId);
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
        
        // Refresh project list page if it's registered
        if (Get.isRegistered<ProjectListController>()) {
          Get.find<ProjectListController>().onRefresh();
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
