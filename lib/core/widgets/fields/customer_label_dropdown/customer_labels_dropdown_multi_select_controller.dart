import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../widgets.dart';
import 'create_update/customer_label_create_update_page.dart';

mixin CustomerLabelsMultiSelectController {
  final CustomerLabelDatasource _datasource = Get.find<CustomerLabelDatasource>();
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<LabelReadDto> labels = <LabelReadDto>[].obs;
  final RxList<LabelReadDto> selectedLabels = <LabelReadDto>[].obs;

  void disposeItems() {
    listState.close();
    labels.close();
    selectedLabels.close();
  }

  void getLabels(final String crmCategoryId) {
    _datasource.getLabels(
      crmCategoryId: crmCategoryId,
      onResponse: (final result) {
        if (labels.subject.isClosed) return;
        labels.assignAll(result.resultList!);
        listState.loaded();
      },
      onError: (final e) => listState.error(),
    );
  }

  void deleteLabel(final LabelReadDto label, {required final VoidCallback action}) {
    _datasource.delete(
      id: label.id,
      onResponse: () {
        labels.remove(label);
        // labels.removeWhere((final e) => e.id == label.id);
        action();
      },
      onError: (final errorResponse) {},
    );
  }

  void showCreateUpdateLabelDialog({required final String crmCategoryId, final LabelReadDto? label}) {
    bottomSheet(
      isDismissible: false,
      child: CustomerLabelCreateUpdatePage(
        label: label,
        crmCategoryId: crmCategoryId,
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
