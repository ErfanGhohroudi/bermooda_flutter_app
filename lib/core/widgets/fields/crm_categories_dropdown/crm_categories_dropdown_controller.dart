import 'package:u/utilities.dart';

import '../../../../data/data.dart';

mixin CrmCategoriesDropdownController {
  final CrmDatasource _crmDatasource = Get.find<CrmDatasource>();
  Rx<UniqueKey> dropdownKey = UniqueKey().obs;
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<CrmCategoryReadDto> categories = <CrmCategoryReadDto>[].obs;
  CrmCategoryReadDto? selectedCategory;

  void getCategories() {
    _crmDatasource.getAllGroups(
      isPaginate: false,
      onResponse: (final response) {
        if (categories.subject.isClosed) return;
        categories(response.resultList);
        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void deleteCategory(final CrmCategoryReadDto category, {required final VoidCallback action}) {
    // _taskDatasource.deleteProject(
    //   labelId: label.id,
    //   onResponse: () {
    //     action();
    //   },
    //   onError: (final errorResponse) {},
    //   withRetry: true,
    // );
  }

  void showCreateUpdateDialog({
    final CrmCategoryReadDto? project,
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
