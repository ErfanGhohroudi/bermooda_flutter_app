import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../data/repositories/voip_repository_imp.dart';
import '../../domain/entity/voip_department.dart';
import '../../domain/usecases/department_usecases/get_archived_departments.dart';
import '../../domain/usecases/department_usecases/restore_department.dart';
import 'department_list_controller.dart';

class VoipArchivedDepartmentListController extends GetxController {
  final VoipRepositoryImpl _repository = VoipRepositoryImpl();

  late final GetArchivedDepartmentsUseCase _getArchivedDepartmentsUseCase = GetArchivedDepartmentsUseCase(_repository);
  late final RestoreDepartmentUseCase _restoreDepartmentUseCase = RestoreDepartmentUseCase(_repository);

  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<VoipDepartment> departments = <VoipDepartment>[].obs;

  bool get haveAdminAccess => Get.find<PermissionService>().haveSMSAdminAccess;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _getDepartments();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    refreshController.dispose();
    pageState.close();
    departments.close();
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
    pageNumber = 1;
    _getDepartments();
  }

  void loadMore() {
    pageNumber++;
    _getDepartments();
  }

  Future<void> _getDepartments() async {
    try {
      final response = await _getArchivedDepartmentsUseCase(
        pageNumber: pageNumber,
        search: searchController.text.trim().isNotEmpty ? searchController.text.trim() : null,
      );

      if (departments.subject.isClosed) return;
      if (pageNumber == 1) {
        departments.assignAll(response.resultList ?? []);
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
    } catch (e) {
      if (pageState.isInitial()) {
        pageState.error();
      }
      if (pageNumber == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  void restoreDepartment(final VoipDepartment department) {
    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () async {
        AppNavigator.back();
        try {
          await _restoreDepartmentUseCase(department.id);
          final index = departments.indexOf(department);
          if (index == -1) return;
          departments.removeAt(index);
          departments.refresh();
          if (Get.isRegistered<VoipDepartmentListController>()) {
            Get.find<VoipDepartmentListController>().onRefresh();
          }
        } catch (e) {
          AppSnackBar.snackbarRed(title: s.error, subtitle: '');
        }
      },
    );
  }
}
