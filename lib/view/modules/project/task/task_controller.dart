import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

mixin TaskController {
  final TaskDatasource _taskDatasource = Get.find<TaskDatasource>();
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final bool haveAdminAccess = Get.find<PermissionService>().haveProjectAdminAccess;
  late int? taskId;
  final Rx<TaskReadDto> task = TaskReadDto().obs;
  final Rx<PageState> projectsState = PageState.loaded.obs;
  List<ProjectReadDto> projects = [];

  ProjectSectionReadDto? selectedSection;

  void disposeItems() {
    buttonState.close();
    pageState.close();
    task.close();
    projectsState.close();
  }

  void getTask() {
    _taskDatasource.getATask(
      taskId: taskId,
      onResponse: (final response) {
        task(response.result);
        pageState.loaded();
        _getAllProjects();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _getAllProjects() {
    projectsState.loading();
    _projectDatasource.getAllProjects(
      pageNumber: 1,
      perPageCount: 200,
      onResponse: (final response) {
        projects = response.resultList ?? [];
        projectsState.loaded();
      },
      onError: (final errorResponse) {
        projectsState.loaded();
      },
    );
  }

  void delete({required final VoidCallback action}) {
    appShowYesCancelDialog(
      title: s.error,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _taskDatasource.delete(
          taskId: taskId,
          onResponse: action,
          onError: (final errorResponse) {},
        );
      },
    );
  }

  void updateTaskCategory() {
    if (selectedSection != null) {
      UNavigator.back();
      buttonState.loading();

      _taskDatasource.update(
        taskId: task.value.id,
        dto: TaskParams(
          title: task.value.title,
          description: task.value.description,
          projectId: task.value.projectId,
          sectionId: selectedSection?.id,
        ),
        onResponse: (final response) {
          task(response.result!);
          buttonState.loaded();
        },
        onError: (final errorResponse) {
          buttonState.loaded();
        },
        withRetry: true,
      );
    }
  }

  void changeProject(final String projectId) {
    _taskDatasource.changeTaskProject(
      taskId: taskId,
      projectId: projectId,
      onResponse: (final response) {
        task(response.result);
        pageState.refresh();
      },
      onError: (final errorResponse) {},
    );
  }
}
