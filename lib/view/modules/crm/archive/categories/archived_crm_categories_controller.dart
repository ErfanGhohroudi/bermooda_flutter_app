import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../list/crm_categories_list_controller.dart';

class ArchivedCrmCategoriesController extends GetxController {
  final CrmArchiveDatasource _datasource = Get.find<CrmArchiveDatasource>();
  final PermissionService _permissionService = Get.find<PermissionService>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<CrmCategoryReadDto> categories = <CrmCategoryReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  bool get isAtEnd => _isAtEnd;
  bool get haveAdminAccess => _permissionService.haveCRMAdminAccess;

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

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onRefresh() {
    _pageNumber = 1;
    _getArchivedCategories();
  }

  void loadMore() {
    _pageNumber++;
    _getArchivedCategories();
  }

  void _getArchivedCategories() {
    _datasource.getArchivedCategories(
      pageNumber: _pageNumber,
      query: searchCtrl.text.trim().isEmpty ? null : searchCtrl.text.trim(),
      onResponse: (final response) {
        if (categories.subject.isClosed || response.resultList == null) return;
        if (_pageNumber == 1) {
          categories(response.resultList);
          refreshController.refreshCompleted();
        } else {
          categories.addAll(response.resultList!);
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
        if (pageState.isInitial()) {
          pageState.error();
        }
        if (_pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
    );
  }

  void restoreCategory(final String? categoryId) {
    if (!haveAdminAccess) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }

    if (categoryId == null) return;

    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreCategory(categoryId);
      },
    );
  }

  void _restoreCategory(final String categoryId) {
    _datasource.restoreCategory(
      categoryId: categoryId,
      onResponse: (final response) {
        categories.removeWhere((final e) => e.id == categoryId);
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
        
        // Refresh categories list page if it's registered
        if (Get.isRegistered<CrmCategoriesListController>()) {
          Get.find<CrmCategoriesListController>().onRefresh();
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
