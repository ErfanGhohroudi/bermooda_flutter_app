import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

mixin ProjectListController {
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  int pageNumber = 1;
  bool isEndOfList = false;
  final RxList<ProjectReadDto> projects = <ProjectReadDto>[].obs;
  final bool haveAdminAccess = Get.find<PermissionService>().haveProjectAdminAccess;

  void disposeItems() {
    searchController.dispose();
    refreshController.dispose();
    isReorderEnabled.close();
    pageState.close();
    projects.close();
  }

  void initialController() {
    onRefresh();
  }

  void toggleReorder() {
    isReorderEnabled(!isReorderEnabled.value);
    pageState.refresh();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getProjects();
  }

  void loadMore() {
    pageNumber++;
    _getProjects();
  }

  void _getProjects() {
    _projectDatasource.getAllProjects(
      pageNumber: pageNumber,
      query: searchController.text.trim(),
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (projects.subject.isClosed) return;
        if (pageNumber == 1) {
          projects(response.resultList ?? []);
          refreshController.refreshCompleted();
        } else {
          projects.addAll(response.resultList ?? []);
        }

        if (response.extra?.next == null || (response.resultList?.isEmpty ?? true)) {
          refreshController.loadNoData();
          isEndOfList = true;
        } else {
          refreshController.loadComplete();
          isEndOfList = false;
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
      withRetry: pageNumber == 1 && projects.isEmpty,
    );
  }

  void deleteProject(
    final ProjectReadDto project, {
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteProject,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(project, action: action);
      },
    );
  }

  void _delete(
    final ProjectReadDto project, {
    required final VoidCallback action,
  }) {
    _projectDatasource.delete(
      id: project.id,
      onResponse: action,
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void updateOrders() {
    _projectDatasource.updateOrders(
      projects: projects,
      onResponse: (final response) {
        isReorderEnabled(!isReorderEnabled.value);
        AppNavigator.snackbarGreen(title: s.done, subtitle: s.changesSaved);
        pageState.refresh();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void insertProject(final ProjectReadDto newProject) {
    projects.insert(0, newProject);
  }
}
