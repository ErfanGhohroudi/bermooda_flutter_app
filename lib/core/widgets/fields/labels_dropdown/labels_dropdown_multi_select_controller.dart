import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../widgets.dart';
import 'create_update/label_create_update_page.dart';

mixin LabelsMultiSelectController {
  final LabelDatasource _labelDatasource = Get.find<LabelDatasource>();
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<LabelReadDto> labels = <LabelReadDto>[].obs;
  final RxList<LabelReadDto> selectedLabels = <LabelReadDto>[].obs;

  void disposeItems() {
    listState.close();
    labels.close();
    selectedLabels.close();
  }

  void getLabels(
    final String sourceId,
    final LabelDataSourceType dataSourceType,
  ) {
    _labelDatasource.getLabels(
      dataSourceType: dataSourceType,
      sourceId: sourceId,
      onResponse: (final result) {
        if (labels.subject.isClosed) return;
        labels.assignAll(result.resultList!);
        listState.loaded();
      },
      onError: (final e) => listState.error(),
    );
  }

  void deleteLabel(
    final LabelReadDto label,
    final LabelDataSourceType dataSourceType, {
    required final VoidCallback action,
  }) {
    _labelDatasource.deleteLabel(
      dataSourceType: dataSourceType,
      id: label.id,
      onResponse: () {
        labels.removeWhere((final e) => e.id == label.id);
        action();
      },
      onError: (final errorResponse) {},
    );
  }

  void showCreateUpdateLabelDialog(
    final LabelDataSourceType dataSourceType, {
    required final String sourceId,
    final LabelReadDto? label,
  }) {
    bottomSheet(
      isDismissible: false,
      child: LabelCreateUpdatePage(
        dataSourceType: dataSourceType,
        label: label,
        sourceId: sourceId,
        onResponse: (final newLabel) {
          if (label == null) {
            labels.insert(0, newLabel);
          } else {
            final i = labels.indexWhere((final e) => e.id == newLabel.id);
            if (i != -1) labels[i] = newLabel;
          }
        },
      ),
    );
  }
}
