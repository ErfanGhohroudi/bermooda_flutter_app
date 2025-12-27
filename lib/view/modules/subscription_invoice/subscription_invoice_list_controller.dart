import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../data/data.dart';

mixin SubscriptionInvoiceListController {
  late final String workspaceId;
  final SubscriptionInvoiceDatasource _datasource = Get.find<SubscriptionInvoiceDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<SubscriptionInvoiceReadDto> invoices = <SubscriptionInvoiceReadDto>[].obs;
  int pageNumber = 1;

  void disposeItems() {
    refreshController.dispose();
    pageState.close();
    invoices.close();
  }

  void initialController(final String workspaceId) {
    this.workspaceId = workspaceId;
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getInvoices();
  }

  void onLoadMore() {
    pageNumber++;
    _getInvoices();
  }

  void onTryAgain() {
    pageState.loading();
    _getInvoices();
  }

  void _getInvoices() {
    _datasource.getAllInvoices(
      workspaceId: workspaceId,
      pageNumber: pageNumber,
      onResponse: (final response) {
        if (pageState.subject.isClosed || response.resultList == null) return;

        if (pageNumber == 1) {
          invoices.assignAll(response.resultList!);
          refreshController.refreshCompleted();
        } else {
          invoices.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.subject.isClosed) return;
        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
        pageState.error();
      },
    );
  }
}
