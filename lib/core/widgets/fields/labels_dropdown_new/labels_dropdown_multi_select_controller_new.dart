import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../widgets.dart';
import 'create_update/label_create_update_page.dart';

mixin LabelsMultiSelectController {
  late final ILabelDatasource datasource;
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<LabelReadDto> labels = <LabelReadDto>[].obs;
  final RxList<LabelReadDto> selectedLabels = <LabelReadDto>[].obs;

  void disposeItems() {
    listState.close();
    labels.close();
    selectedLabels.close();
  }

  void getLabels(final String sourceId) {
    datasource.getLabels(
      sourceId: sourceId,
      onResponse: (final result) {
        if (labels.subject.isClosed) return;
        labels.assignAll(result.resultList!);
        listState.loaded();
      },
      onError: (final e) => listState.error(),
    );
  }

  void deleteLabel(final LabelReadDto label, {required final VoidCallback action}) {
    datasource.deleteLabel(
      slug: label.slug,
      onResponse: () {
        labels.removeWhere((final e) => e.slug == label.slug);
        action();
      },
      onError: (final errorResponse) {},
    );
  }

  void showCreateUpdateLabelDialog({required final String sourceId, final LabelReadDto? label}) {
    bottomSheet(
      isDismissible: false,
      child: LabelCreateUpdatePage(
        label: label,
        sourceId: sourceId,
        datasource: datasource,
        onResponse: (final newLabel) {
          if (label == null) {
            labels.insert(0, newLabel);
          } else {
            final i = labels.indexWhere((final e) => e.slug == newLabel.slug);
            if (i != -1) labels[i] = newLabel;
          }
        },
      ),
    );
  }
}
