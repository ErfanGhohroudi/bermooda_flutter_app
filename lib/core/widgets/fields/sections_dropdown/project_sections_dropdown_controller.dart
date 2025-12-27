import 'package:u/utilities.dart';

import '../../../../data/data.dart';

mixin ProjectSectionsDropdownController {
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  bool canManage = false;
  Rx<UniqueKey> dropdownKey = UniqueKey().obs;
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<ProjectSectionReadDto> sections = <ProjectSectionReadDto>[].obs;
  final Rx<ProjectSectionReadDto?> selectedSection = Rx(null);

  void getSections(final String projectId, {required final Function(List<ProjectSectionReadDto> list) action}) {
    _projectDatasource.getSections(
      projectId: projectId,
      onResponse: (final response) {
        if (sections.subject.isClosed) return;
        sections(response.resultList);
        action(sections);
        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void deleteSection(final ProjectSectionReadDto section, {required final VoidCallback action}) {
    _projectDatasource.deleteSection(
      id: section.id,
      onResponse: () {
        action();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void showCreateUpdateSectionDialog({
    required final String projectId,
    final ProjectSectionReadDto? section,
  }) {
    // showAppDialog(
    //   barrierDismissible: false,
    //   AlertDialog(
    //     content: LabelCreateUpdatePage(
    //       label: label,
    //       projectId: projectId,
    //       onResponse: (final newLabel) {
    //         if (label == null) {
    //           sections.insert(0, newLabel);
    //         } else {
    //           final i = sections.indexWhere((final e) => e.id == newLabel.id);
    //           if (i != -1) {
    //             sections[i] = newLabel;
    //             if (selectedSection.value?.id == newLabel.id) {
    //               selectedSection(newLabel);
    //               dropdownKey(UniqueKey());
    //             }
    //           }
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}
