import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

class ProjectListController extends GetxController {
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  int pageNumber = 1;
  bool isEndOfList = false;
  final RxList<ProjectReadDto> projects = <ProjectReadDto>[].obs;
  final bool haveAdminAccess = Get.find<PermissionService>().haveProjectAdminAccess;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onClose() {
    searchController.dispose();
    refreshController.dispose();
    isReorderEnabled.close();
    pageState.close();
    projects.close();
    super.onClose();
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

  void archiveProject(
    final ProjectReadDto project, {
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.archive,
      description: s.areYouSureToArchiveProject,
      yesButtonTitle: s.archive,
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
