import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../app_config.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/sms_department.dart';
import '../../domain/usecases/department_usecases/archive_department.dart';
import '../../domain/usecases/department_usecases/create_department.dart';
import '../../domain/usecases/department_usecases/get_departments.dart';
import '../../domain/usecases/department_usecases/update_department.dart';

class SmsDepartmentListController extends GetxController {
  final SmsPanelRepositoryImpl _repository = SmsPanelRepositoryImpl();

  late final GetDepartmentsUseCase _getDepartmentsUseCase = GetDepartmentsUseCase(_repository);
  late final CreateDepartmentUseCase _createDepartmentUseCase = CreateDepartmentUseCase(_repository);
  late final UpdateDepartmentUseCase _updateDepartmentUseCase = UpdateDepartmentUseCase(_repository);
  late final ArchiveDepartmentUseCase _archiveDepartmentUseCase = ArchiveDepartmentUseCase(_repository);

  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<SmsDepartment> departments = <SmsDepartment>[].obs;

  bool get haveAdminAccess => Get.find<PermissionService>().haveSMSAdminAccess || AppConfig.instance.isDevelopment;

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
    isReorderEnabled.close();
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

  void toggleReorder() {
    isReorderEnabled(!isReorderEnabled.value);
    pageState.refresh();
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
      final response = await _getDepartmentsUseCase(
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

  void archiveDepartment(final SmsDepartment department) {
    appShowYesCancelDialog(
      title: s.archive,
      description: s.areYouSureToArchiveDepartment,
      yesButtonTitle: s.archive,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () async {
        AppNavigator.back();
        try {
          await _archiveDepartmentUseCase(department.id);
          final index = departments.indexOf(department);
          if (index == -1) return;
          departments.removeAt(index);
          departments.refresh();
        } catch (e) {
          AppSnackBar.snackbarRed(title: s.error, subtitle: '');
        }
      },
    );
  }

  void updateOrders() {
    // _crmDatasource.updateOrders(
    //   departments: departments,
    //   onResponse: (final response) {
    //     isReorderEnabled(!isReorderEnabled.value);
    //     AppSnackBar.snackbarGreen(title: s.done, subtitle: s.changesSaved);
    //     pageState.refresh();
    //   },
    //   onError: (final errorResponse) {},
    //   withRetry: true,
    // );
  }

  Future<SmsDepartment?> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) async {
    try {
      final SmsDepartment department = await _createDepartmentUseCase(
        title: title,
        members: members,
      );
      insertDepartment(department);
      return department;
    } catch (e) {
      return null;
    }
  }

  Future<SmsDepartment?> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) async {
    try {
      final department = await _updateDepartmentUseCase(
        id: id,
        title: title,
        members: members,
      );
      final index = departments.indexWhere((final d) => d.id == id);
      if (index == -1) return null;
      departments[index] = department;
      departments.refresh();
      return department;
    } catch (e) {
      return null;
    }
  }

  void insertDepartment(final SmsDepartment newDepartment) {
    departments.insert(0, newDepartment);
  }
}
