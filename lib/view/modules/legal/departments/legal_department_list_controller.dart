import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import 'create_update/department_create_update_page.dart';

class LegalDepartmentListController extends GetxController {
  final LegalDatasource _datasource = Get.find<LegalDatasource>();
  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<LegalDepartmentReadDto> departments = <LegalDepartmentReadDto>[].obs;

  bool get haveAdminAccess => Get.find<PermissionService>().haveLegalAdminAccess;

  @override
  void onInit() {
    _getDepartments();
    super.onInit();
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
    _datasource.getAllDepartments(
      pageNumber: pageNumber,
      query: searchController.text.trim(),
      onResponse: (final response) {
        if (departments.subject.isClosed) return;
        if (pageNumber == 1) {
          departments(response.resultList ?? []);
          refreshController.refreshCompleted();
        } else {
          departments.addAll(response.resultList ?? []);
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

  void deleteDepartment(final LegalDepartmentReadDto department) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteCategory,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(department);
      },
    );
  }

  void _delete(final LegalDepartmentReadDto department) {
    _datasource.delete(
      id: department.id,
      onResponse: () => departments.removeWhere((final d) => d.id == department.id),
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void updateOrders() {
    _datasource.updateOrders(
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

  void insertDepartment(final LegalDepartmentReadDto newDepartment) {
    departments.insert(0, newDepartment);
  }

  void updateDepartment(final LegalDepartmentReadDto newDepartment) {
    final index = departments.indexWhere((final d) => d.id == newDepartment.id);
    if (index != -1) {
      departments[index] = newDepartment;
    }
  }

  void navigateToCreateDepartmentPage() {
    bottomSheet(
      title: s.newDepartment,
      child: const LegalDepartmentCreateUpdatePage(),
    );
  }

  void navigateToEditDepartmentPage(final LegalDepartmentReadDto department) {
    bottomSheet(
      title: s.editDepartment,
      child: LegalDepartmentCreateUpdatePage(
        department: department,
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    refreshController.dispose();
    debugPrint("LegalDepartmentListController closed!!!");
    super.onClose();
  }
}
