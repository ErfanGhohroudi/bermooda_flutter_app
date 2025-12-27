import 'package:u/utilities.dart';

import '../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../../../data/data.dart';
import '../../widgets.dart';
import 'create_update/label_create_update_page.dart';

mixin LabelsDropdownController {
  late final ILabelDatasource datasource;
  bool canManage = true;
  Rx<UniqueKey> dropdownKey = UniqueKey().obs;
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<LabelReadDto> labels = <LabelReadDto>[].obs;
  final Rxn<LabelReadDto?> selectedLabel = Rxn(null);

  void getLabels(final String sourceId, {required final Function(List<LabelReadDto> list) action}) {
    datasource.getLabels(
      sourceId: sourceId,
      onResponse: (final response) {
        if (labels.subject.isClosed) return;
        labels(response.resultList);
        action(labels);
        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void deleteLabel(final LabelReadDto label, {required final VoidCallback action}) {
    datasource.deleteLabel(
      slug: label.slug,
      onResponse: () {
        action();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void showCreateUpdateLabelDialog({
    required final String sourceId,
    final LabelReadDto? label,
  }) {
    showAppDialog(
      barrierDismissible: false,
      AlertDialog(
        content: LabelCreateUpdatePage(
          label: label,
          sourceId: sourceId,
          datasource: datasource,
          onResponse: (final newLabel) {
            if (label == null) {
              labels.insert(0, newLabel);
            } else {
              final i = labels.indexWhere((final e) => e.slug == newLabel.slug);
              if (i != -1) {
                labels[i] = newLabel;
                if (selectedLabel.value?.slug == newLabel.slug) {
                  selectedLabel(newLabel);
                  dropdownKey(UniqueKey());
                }
              }
            }
          },
        ),
      ),
    );
  }
}
