import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';

class CrmArchiveController extends GetxController {
  CrmArchiveController({required this.categoryId});

  late final String categoryId;
  final CrmArchiveDatasource _datasource = Get.find<CrmArchiveDatasource>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<CustomerReadDto> customers = <CustomerReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxBool currentFilter = false.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  bool get isAtEnd => _isAtEnd;

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    onRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    refreshController.dispose();
    scrollController.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void setFilter(final bool value) {
    if (currentFilter.value == value) return;
    currentFilter(value);
    pageState.loading();
    onRefresh();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    _pageNumber = 1;
    getCustomers();
  }

  void loadMore() {
    _pageNumber++;
    getCustomers();
  }

  void updateItem(final CustomerReadDto model) {
    for (var i = 0; i < customers.length; i++) {
      if (customers[i].id == model.id) {
        customers[i] = model;
        break;
      }
    }
  }

  void insertItem(final CustomerReadDto model) {
    customers.insert(0, model);
  }

  void removeItem(final CustomerReadDto model) {
    customers.removeWhere((final e) => e.id == model.id);
  }

  void getCustomers() {
    _datasource.getAllCustomers(
      categoryId: categoryId,
      pageNumber: _pageNumber,
      isFollowed: currentFilter.value,
      query: searchCtrl.text.trim(),
      onResponse: (final response) {
        if (customers.subject.isClosed || response.resultList == null) return;
        if (_pageNumber == 1) {
          customers(response.resultList);
          refreshController.refreshCompleted();
        } else {
          customers.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          _isAtEnd = true;
        } else {
          refreshController.loadComplete();
          _isAtEnd = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (_pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: _pageNumber == 1 && customers.isEmpty,
    );
  }

  void restoreCustomer(final int? id) {
    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreCustomer(id);
      },
    );
  }

  void _restoreCustomer(final int? id) {
    if (id == null) return;
    _datasource.restoreCustomer(
      id: id,
      categoryId: categoryId,
      onResponse: (final response) {
        customers.removeWhere((final e) => e.id == id);
      },
      onError: (final errorResponse) {},
    );
  }
}
