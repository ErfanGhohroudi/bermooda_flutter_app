import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/navigator/navigator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../data/data.dart';
import 'create_update/workshift_create_update_page.dart';

class WorkshiftListController extends GetxController {
  WorkshiftListController({
    required this.departmentSlug,
  });

  final String departmentSlug;
  final WorkShiftDatasource _workShiftDatasource = Get.find<WorkShiftDatasource>();
  final RefreshController refreshController = RefreshController();
  final TextEditingController searchController = TextEditingController();
  int pageNumber = 1;
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<WorkShiftReadDto> workShifts = <WorkShiftReadDto>[].obs;
  bool isEndOfList = false;

  final bool haveAdminAccess = Get.find<PermissionService>().haveHRAdminAccess;

  @override
  void onInit() {
    _getWorkShifts();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    searchController.dispose();
    super.onClose();
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
    _getWorkShifts();
  }

  void loadMore() {
    pageNumber++;
    _getWorkShifts();
  }

  void _getWorkShifts() {
    _workShiftDatasource.getAllWorkShifts(
      slug: departmentSlug,
      pageNumber: pageNumber,
      // search: searchController.text,
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (workShifts.subject.isClosed) return;
        if (pageNumber == 1) {
          workShifts(response.resultList);
          refreshController.refreshCompleted();
        } else {
          workShifts.addAll(response.resultList!);
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
        if (pageState.isInitial()) {
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

  void deleteWorkShift(final WorkShiftReadDto workShift) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: Colors.red,
      onYesButtonTap: () {
        AppNavigator.back();
        _delete(workShift);
      },
    );
  }

  void _delete(final WorkShiftReadDto workShift) {
    _workShiftDatasource.delete(
      slug: workShift.slug,
      onResponse: () {
        final i = workShifts.indexWhere((final e) => e.slug == workShift.slug);
        if (i == -1) return;
        workShifts.removeAt(i);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void insertWorkShift(final WorkShiftReadDto newWorkShift) {
    workShifts.insert(0, newWorkShift);
  }

  void updateWorkShift(final WorkShiftReadDto updatedWorkShift) {
    final i = workShifts.indexWhere((final f) => f.slug == updatedWorkShift.slug);
    if (i == -1) return;
    workShifts[i] = updatedWorkShift;
    workShifts.refresh();
  }

  void showCreateUpdateBottomSheet({final WorkShiftReadDto? workShift}) {
    final title = workShift == null 
        ? s.newWorkShift
        : '${s.edit} ${s.workShift}';
    bottomSheet(
      title: title,
      child: WorkshiftCreateUpdatePage(
        departmentSlug: departmentSlug,
        workShift: workShift,
      ),
    );
  }
}

