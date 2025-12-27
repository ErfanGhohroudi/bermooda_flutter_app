import 'package:bermooda_business/core/utils/enums/enums.dart';
import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../widgets.dart';
import 'create_update/status_reason_create_update_page.dart';

mixin StatusReasonMultiSelectController {
  late CustomerStatus type;
  final CustomerStatusReasonDatasource _statusReasonDatasource = Get.find<CustomerStatusReasonDatasource>();
  final Rx<PageState> listState = PageState.loading.obs;
  final RxList<StatusReasonReadDto> items = <StatusReasonReadDto>[].obs;
  final RxList<StatusReasonReadDto> selectedItems = <StatusReasonReadDto>[].obs;

  void disposeItems() {
    listState.close();
    items.close();
    selectedItems.close();
  }

  void getReasons(final String categoryId) {
    listState.loading();
    items.clear();
    _statusReasonDatasource.getAllReasons(
      crmCategoryId: categoryId,
      type: type,
      onResponse: (final result) {
        if (items.subject.isClosed) return;
        items.assignAll(result.resultList!);
        listState.loaded();
      },
      onError: (final e) => listState.error(),
    );
  }

  void deleteReason(final StatusReasonReadDto reason, {required final VoidCallback action}) {
    _statusReasonDatasource.delete(
      slug: reason.slug,
      onResponse: () {
        if (items.subject.isClosed) return;
        items.removeWhere((final e) => e.slug == reason.slug);
        action();
      },
      onError: (final errorResponse) {},
    );
  }

  void showCreateUpdateLabelDialog({required final String projectId, final StatusReasonReadDto? item}) {
    bottomSheet(
      isDismissible: false,
      child: StatusReasonCreateUpdatePage(
        statusReason: item,
        type: type,
        categoryId: projectId,
        onResponse: (final newLabel) {
          if (item == null) {
            items.insert(0, newLabel);
          } else {
            final i = items.indexWhere((final e) => e.slug == newLabel.slug);
            if (i != -1) items[i] = newLabel;
          }
        },
      ),
    );
  }
}
