import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../departments/hr_departments_list_controller.dart';

class ArchivedHrDepartmentsController extends GetxController {
  final HumanResourceDatasource _datasource = Get.find<HumanResourceDatasource>();
  final PermissionService _permissionService = Get.find<PermissionService>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<HRDepartmentReadDto> departments = <HRDepartmentReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  bool get isAtEnd => _isAtEnd;
  bool get haveAdminAccess => _permissionService.haveHRAdminAccess;

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

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    _pageNumber = 1;
    _getArchivedDepartments();
  }

  void loadMore() {
    _pageNumber++;
    _getArchivedDepartments();
  }

  void _getArchivedDepartments() {
    _datasource.getArchivedDepartments(
      pageNumber: _pageNumber,
      query: searchCtrl.text.trim().isEmpty ? null : searchCtrl.text.trim(),
      onResponse: (final response) {
        if (departments.subject.isClosed || response.resultList == null) return;
        if (_pageNumber == 1) {
          departments(response.resultList);
          refreshController.refreshCompleted();
        } else {
          departments.addAll(response.resultList!);
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

  void restoreDepartment(final String? slug) {
    if (!haveAdminAccess) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }

    if (slug == null) return;

    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreDepartment(slug);
      },
    );
  }

  void _restoreDepartment(final String slug) {
    _datasource.restoreDepartment(
      slug: slug,
      onResponse: (final response) {
        departments.removeWhere((final e) => e.slug == slug);
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
        
        // Refresh departments list page if it's registered
        if (Get.isRegistered<HrDepartmentsListController>()) {
          Get.find<HrDepartmentsListController>().onRefresh();
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
