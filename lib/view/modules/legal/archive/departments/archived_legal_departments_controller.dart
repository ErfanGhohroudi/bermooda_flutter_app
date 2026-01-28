import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../departments/legal_department_list_controller.dart';

class ArchivedLegalDepartmentsController extends GetxController {
  final LegalDatasource _datasource = Get.find<LegalDatasource>();
  final PermissionService _permissionService = Get.find<PermissionService>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<LegalDepartmentReadDto> departments = <LegalDepartmentReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  bool get isAtEnd => _isAtEnd;
  bool get haveAdminAccess => _permissionService.haveLegalAdminAccess;

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

  void restoreDepartment(final String? departmentId) {
    if (!haveAdminAccess) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }

    if (departmentId == null) return;

    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreDepartment(departmentId);
      },
    );
  }

  void _restoreDepartment(final String departmentId) {
    _datasource.restoreDepartment(
      departmentId: departmentId,
      onResponse: (final response) {
        departments.removeWhere((final e) => e.id == departmentId);
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
        
        // Refresh departments list page if it's registered
        if (Get.isRegistered<LegalDepartmentListController>()) {
          Get.find<LegalDepartmentListController>().onRefresh();
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
