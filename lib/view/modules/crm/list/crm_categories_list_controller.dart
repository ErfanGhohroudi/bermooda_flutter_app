import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

mixin CrmCategoriesListController {
  final CrmDatasource _crmDatasource = Get.find<CrmDatasource>();
  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final RxBool isReorderEnabled = false.obs;
  final bool haveAdminAccess = Get.find<PermissionService>().haveCRMAdminAccess;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<CrmCategoryReadDto> categories = <CrmCategoryReadDto>[].obs;

  void disposeItems() {
    searchController.dispose();
    refreshController.dispose();
    isReorderEnabled.close();
    pageState.close();
    categories.close();
  }

  void initialController() {
    _getCategories();
  }

  void toggleReorder() {
    isReorderEnabled(!isReorderEnabled.value);
    pageState.refresh();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getCategories();
  }

  void loadMore() {
    pageNumber++;
    _getCategories();
  }

  void _getCategories() {
    _crmDatasource.getAllGroups(
      pageNumber: pageNumber,
      query: searchController.text.trim(),
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (categories.subject.isClosed) return;
        if (pageNumber == 1) {
          categories.assignAll(response.resultList ?? []);
          refreshController.refreshCompleted();
        } else {
          categories.addAll(response.resultList ?? []);
        }

        if (response.extra?.next == null || (response.resultList?.isEmpty ?? true)) {
          refreshController.loadNoData();
          isEndOfList = true;
        } else {
          refreshController.loadComplete();
          isEndOfList = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: pageNumber == 1 && categories.isEmpty,
    );
  }

  void deleteCategory(
    final CrmCategoryReadDto category, {
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteCategory,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(category, action: action);
      },
    );
  }

  void _delete(
    final CrmCategoryReadDto category, {
    required final VoidCallback action,
  }) {
    _crmDatasource.delete(
      id: category.id,
      onResponse: action,
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void updateOrders() {
    _crmDatasource.updateOrders(
      categories: categories,
      onResponse: (final response) {
        isReorderEnabled(!isReorderEnabled.value);
        AppNavigator.snackbarGreen(title: s.done, subtitle: s.changesSaved);
        pageState.refresh();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void insertCategory(final CrmCategoryReadDto newCategory) {
    categories.insert(0, newCategory);
  }
}
