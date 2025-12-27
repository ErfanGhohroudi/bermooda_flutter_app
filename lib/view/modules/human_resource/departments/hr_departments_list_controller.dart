import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

class HrDepartmentsListController extends GetxController {
  final HumanResourceDatasource _humanResourceDatasource = Get.find<HumanResourceDatasource>();
  final RefreshController refreshController = RefreshController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isReorderEnabled = false.obs;
  int pageNumber = 1;
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<HRDepartmentReadDto> departments = <HRDepartmentReadDto>[].obs;
  bool isEndOfList = false;

  final bool haveAdminAccess = Get.find<PermissionService>().haveHRAdminAccess;

  @override
  void onInit() {
    _getDepartments();
    super.onInit();
  }

  @override
  void onClose() {
    debugPrint("HrDepartmentsListController closed!!!");
    refreshController.dispose();
    searchController.dispose();
    super.onClose();
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
    _getDepartments();
  }

  void loadMore() {
    pageNumber++;
    _getDepartments();
  }

  void _getDepartments() {
    _humanResourceDatasource.getAllDepartments(
      pageNumber: pageNumber,
      query: searchController.text.trim(),
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (departments.subject.isClosed) return;
        if (pageNumber == 1) {
          departments(response.resultList);
          refreshController.refreshCompleted();
        } else {
          departments.addAll(response.resultList!);
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
      withRetry: pageNumber == 1 && departments.isEmpty,
    );
  }

  void deleteFolder(final HRDepartmentReadDto department) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(department);
      },
    );
  }

  void _delete(final HRDepartmentReadDto department) {
    _humanResourceDatasource.delete(
      slug: department.slug,
      onResponse: () {
        final i = departments.indexWhere((final e) => e.slug == department.slug);
        if (i == -1) return;
        departments.removeAt(i);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void updateOrders() {
    _humanResourceDatasource.updateOrders(
      departments: departments,
      onResponse: (final response) {
        isReorderEnabled(!isReorderEnabled.value);
        AppNavigator.snackbarGreen(title: s.done, subtitle: s.changesSaved);
        pageState.refresh();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void insertDepartment(final HRDepartmentReadDto newDepartment) {
    departments.insert(0, newDepartment);
  }

  void updateDepartment(final HRDepartmentReadDto newDepartment) {
    final i = departments.indexWhere((final f) => f.id == newDepartment.id);
    if (i != -1) {
      departments[i] = newDepartment;
      departments.refresh();
    }
  }
}
