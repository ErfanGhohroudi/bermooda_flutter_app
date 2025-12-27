import 'package:u/utilities.dart';

import '../../../../data/data.dart';

mixin ProjectsDropdownController {
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  Rx<UniqueKey> dropdownKey = UniqueKey().obs;
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<ProjectReadDto> projects = <ProjectReadDto>[].obs;
  ProjectReadDto? selectedProject;

  void getProjects() {
    _projectDatasource.getAllProjects(
      pageNumber: 1,
      perPageCount: 200,
      onResponse: (final response) {
        if (projects.subject.isClosed) return;
        projects(response.resultList);
        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void deleteProject(final ProjectReadDto project, {required final VoidCallback action}) {
    // _taskDatasource.deleteProject(
    //   labelId: label.id,
    //   onResponse: () {
    //     action();
    //   },
    //   onError: (final errorResponse) {},
    //   retryCallback: () => deleteProject(label, action: action),
    // );
  }

  void showCreateUpdateProjectDialog({
    final ProjectReadDto? project,
  }) {
    // appDialog(
    //   barrierDismissible: false,
    //   AlertDialog(
    //     content: LabelCreateUpdatePage(
    //       label: label,
    //       projectId: departmentId,
    //       onResponse: (final newLabel) {
    //         if (label == null) {
    //           projects.add(newLabel);
    //         } else {
    //           final i = projects.indexWhere((final e) => e.id == newLabel.id);
    //           if (i != -1) {
    //             projects[i] = newLabel;
    //             if (selectedProject?.id == newLabel.id) {
    //               selectedProject = newLabel;
    //               dropdownKey(UniqueKey());
    //             }
    //           }
    //         }
    //         listState.refresh();
    //       },
    //     ),
    //   ),
    // );
  }
}
