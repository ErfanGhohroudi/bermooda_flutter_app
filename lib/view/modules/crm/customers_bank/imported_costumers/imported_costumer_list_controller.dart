import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';

mixin ImportedCostumerListController {
  late final String categoryId;
  late final int? documentId;
  final CustomersBankDatasource _datasource = Get.find<CustomersBankDatasource>();
  final RefreshController refreshController = RefreshController();
  final TextEditingController searchCtrl = TextEditingController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<CustomerReadDto> customers = <CustomerReadDto>[].obs;
  final RxSet<int> selectedCustomerIds = <int>{}.obs;
  int pageNumber = 1;
  bool haveNoMoreData = false;

  void disposeItems() {
    refreshController.dispose();
    searchCtrl.dispose();
    pageState.close();
    customers.close();
    selectedCustomerIds.close();
  }

  void initialController({
    required final String categoryId,
    required final int? documentId,
  }) {
    this.categoryId = categoryId;
    this.documentId = documentId;
    selectedCustomerIds.clear();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getCustomers();
  }

  void onLoadMore() {
    pageNumber++;
    _getCustomers();
  }

  void onSearch() {
    pageState.loading();
    pageNumber = 1;
    selectedCustomerIds.clear();
    _getCustomers();
  }

  /// if ([id] == null) send all the [selectedCustomerIds] to board.
  ///
  /// if ([id] != null) just send this customer to board.
  void sendToBoard({final int? id}) {
    final isSingleSelect = id != null || selectedCustomerIds.length == 1;

    appShowYesCancelDialog(
      title: s.sendToBoard,
      description: isSingleSelect ? s.sendThisCustomerToBoardDialogDescription : s.sendSelectedCustomersToBoardDialogDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _sendToBoard(id: id);
      },
    );
  }

  /// if ([id] == null) delete all the [selectedCustomerIds].
  ///
  /// if ([id] != null) just delete this customer.
  void delete({final int? id}) {
    final isSingleSelect = id != null || selectedCustomerIds.length == 1;

    appShowYesCancelDialog(
      title: s.delete,
      description: isSingleSelect ? s.deleteThisCustomerDialogDescription : s.deleteSelectedCustomersDialogDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(id: id);
      },
    );
  }

  bool isCustomerSelected(final CustomerReadDto customer) {
    final id = customer.id;
    if (id == null) return false;
    return selectedCustomerIds.contains(id);
  }

  void toggleCustomerSelection(final CustomerReadDto customer) {
    final id = customer.id;
    if (id == null) return;
    if (selectedCustomerIds.contains(id)) {
      selectedCustomerIds.remove(id);
    } else {
      selectedCustomerIds.add(id);
    }
    selectedCustomerIds.refresh();
  }

  void toggleSelectAllCustomers() {
    if (customers.isEmpty) return;
    final ids = customers.map((final customer) => customer.id).whereType<int>().toSet();
    final hasAllSelected = ids.every(selectedCustomerIds.contains);

    if (hasAllSelected) {
      selectedCustomerIds.removeWhere(ids.contains);
    } else {
      selectedCustomerIds.addAll(ids);
    }
    selectedCustomerIds.refresh();
  }

  void clearSelectedCustomers() {
    if (selectedCustomerIds.isEmpty) return;
    selectedCustomerIds.clear();
    selectedCustomerIds.refresh();
  }

  /// if ([id] == null) delete all the [selectedCustomerIds] from [customers].
  ///
  /// if ([id] != null) just delete this customer from [customers].
  void deleteCustomerFromList({final int? id}) {
    if (id != null) {
      customers.removeWhere((final e) => e.id == id);
    } else {
      customers.removeWhere((final e) => selectedCustomerIds.contains(e.id));
    }
  }

  void _getCustomers() {
    _datasource.getAllDocumentCustomers(
      categoryId: categoryId,
      documentId: documentId,
      pageNumber: pageNumber,
      query: searchCtrl.text,
      onResponse: (final response) {
        if (pageState.subject.isClosed || response.resultList == null) return;

        if (pageNumber == 1) {
          customers.assignAll(response.resultList!);
          selectedCustomerIds.removeWhere(
            (final id) => customers.every((final customer) => customer.id != id),
          );
          refreshController.refreshCompleted();
        } else {
          customers.addAll(response.resultList!);
          selectedCustomerIds.removeWhere(
            (final id) => customers.every((final customer) => customer.id != id),
          );
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          haveNoMoreData = true;
        } else {
          refreshController.loadComplete();
          haveNoMoreData = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.isInitial() && customers.isEmpty && pageNumber == 1) {
          pageState.error();
          return;
        }

        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
    );
  }

  /// if ([id] == null) send all the [selectedCustomerIds] to board.
  ///
  /// if ([id] != null) just send this customer to board.
  void _sendToBoard({final int? id}) {
    _datasource.sendToBoard(
      categoryId: categoryId,
      selectedCustomerIds: id != null ? [id] : selectedCustomerIds.toList(),
      onResponse: () {
        deleteCustomerFromList(id: id);
        clearSelectedCustomers();
      },
      onError: (final errorResponse) {},
    );
  }

  /// if ([id] == null) delete all the [selectedCustomerIds].
  ///
  /// if ([id] != null) just delete this customer.
  void _delete({final int? id}) {
    _datasource.deleteImportedCustomers(
      selectedCustomerIds: id != null ? [id] : selectedCustomerIds.toList(),
      onResponse: () {
        deleteCustomerFromList(id: id);
        clearSelectedCustomers();
      },
      onError: (final errorResponse) {},
    );
  }
}
