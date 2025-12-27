import 'package:u/utilities.dart';

import '../../../../data/data.dart';

mixin CrmSectionsDropdownController {
  final CrmSectionDatasource _crmSectionDatasource = Get.find<CrmSectionDatasource>();
  bool canManage = false;
  Rx<UniqueKey> dropdownKey = UniqueKey().obs;
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<CrmSectionReadDto> sections = <CrmSectionReadDto>[].obs;
  final Rx<CrmSectionReadDto?> selectedSection = Rx(null);

  void getSections(final String projectId, {required final Function(List<CrmSectionReadDto> list) action}) {
    _crmSectionDatasource.getSections(
      categoryId: projectId,
      onResponse: (final response) {
        if (sections.subject.isClosed) return;
        sections(response.resultList?.reversed.toList());
        action(sections);
        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void deleteSection(final CrmSectionReadDto section, {required final VoidCallback action}) {
    _crmSectionDatasource.delete(
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
    final CrmSectionReadDto? section,
  }) {
    // showAppDialog(
    //   barrierDismissible: false,
    //   AlertDialog(
    //     content: LabelCreateUpdatePage(
    //       label: label,
    //       projectId: projectId,
    //       onResponse: (final newLabel) {
    //         if (label == null) {
    //           labels.insert(0, newLabel);
    //         } else {
    //           final i = labels.indexWhere((final e) => e.id == newLabel.id);
    //           if (i != -1) {
    //             labels[i] = newLabel;
    //             if (selectedLabel.value?.id == newLabel.id) {
    //               selectedLabel(newLabel);
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
