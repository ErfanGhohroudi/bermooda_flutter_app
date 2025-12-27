import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import 'imported_costumers/imported_costumer_list_page.dart';

class CustomersBankController extends GetxController {
  CustomersBankController({
    required this.categoryId,
  });

  final String categoryId;
  final CustomersBankDatasource _datasource = Get.find<CustomersBankDatasource>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<CustomersBankDocument> documents = <CustomersBankDocument>[].obs;
  int pageNumber = 1;
  bool isAtEnd = false;

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
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onRefresh() {
    pageNumber = 1;
    _getDocuments();
  }

  void onLoadMore() {
    pageNumber++;
    _getDocuments();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onTryAgain() {
    pageState.loading();
    onRefresh();
  }

  void _getDocuments() {
    _datasource.getAllDocuments(
      categoryId: categoryId,
      // pageNumber: pageNumber,
      // query: searchCtrl.text.trim(),
      onResponse: (final response) {
        if (documents.subject.isClosed || response.resultList == null) return;

        if (pageNumber == 1) {
          documents.assignAll(response.resultList!);
          refreshController.refreshCompleted();
        } else {
          documents.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          isAtEnd = true;
        } else {
          refreshController.loadComplete();
          isAtEnd = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (documents.isEmpty && pageNumber == 1) {
          pageState.error();
        }

        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
    );
  }

  void deleteDocument(final int? docId) {
    if (docId == null) return;
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(docId);
      },
    );
  }

  void _delete(final int docId) {
    _datasource.delete(
      id: docId,
      onResponse: () {
        final i = documents.indexWhere((final doc) => doc.id == docId);
        if (i != -1) {
          documents.removeAt(i);
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void navigateToDocumentImportedCustomersPage(final CustomersBankDocument document) {
    if (document.id == null) return;

    UNavigator.push(
      ImportedCostumerListPage(
        categoryId: categoryId,
        documentId: document.id,
        documentTitle: document.exelFile?.originalName,
      ),
    );
  }
}
