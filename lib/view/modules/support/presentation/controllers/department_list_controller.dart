import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../data/repositories/support_department_repository_impl.dart';
import '../../domain/entities/support_department.dart';
import '../../domain/usecases/archive_support_department.dart';
import '../../domain/usecases/create_support_department.dart';
import '../../domain/usecases/get_support_departments.dart';
import '../../domain/usecases/update_support_department.dart';

class SupportDepartmentListController extends GetxController {
  final SupportDepartmentRepositoryImpl _repository = SupportDepartmentRepositoryImpl();

  late final GetSupportDepartmentsUseCase _getDepartmentsUseCase = GetSupportDepartmentsUseCase(_repository);
  late final CreateSupportDepartmentUseCase _createDepartmentUseCase = CreateSupportDepartmentUseCase(_repository);
  late final UpdateSupportDepartmentUseCase _updateDepartmentUseCase = UpdateSupportDepartmentUseCase(_repository);
  late final ArchiveSupportDepartmentUseCase _archiveDepartmentUseCase = ArchiveSupportDepartmentUseCase(_repository);

  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<SupportDepartment> departments = <SupportDepartment>[].obs;

  bool get haveAdminAccess => Get.find<PermissionService>().haveSupportAdminAccess;

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

  void archiveDepartment(final SupportDepartment department) {
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

  Future<SupportDepartment?> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) async {
    try {
      final department = await _createDepartmentUseCase(
        avatarId: avatar?.fileId,
        title: title,
        members: members,
      );
      insertItem(department);
      return department;
    } catch (e) {
      return null;
    }
  }

  Future<SupportDepartment?> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) async {
    try {
      final department = await _updateDepartmentUseCase(
        id: id,
        avatarId: avatar?.fileId,
        title: title,
        members: members,
      );
      return updateItem(department);
    } catch (e) {
      return null;
    }
  }

  SupportDepartment? updateItem(final SupportDepartment department) {
    final index = departments.indexWhere((final d) => d.id == department.id);
    if (index == -1) return null;
    departments[index] = department;
    departments.refresh();
    return department;
  }

  void insertItem(final SupportDepartment newDepartment) {
    departments.insert(0, newDepartment);
  }
}
