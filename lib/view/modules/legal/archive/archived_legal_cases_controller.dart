import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../data/data.dart';

class ArchivedLegalCasesController extends GetxController {
  ArchivedLegalCasesController({required this.legalDepartmentId});

  late final int legalDepartmentId;
  final LegalCaseDatasource _datasource = Get.find<LegalCaseDatasource>();
  final PermissionService _permissionService = Get.find<PermissionService>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<LegalCaseReadDto> legalCases = <LegalCaseReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  bool get isAtEnd => _isAtEnd;

  bool get haveLegalAdminAccess => _permissionService.haveLegalAdminAccess;

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

  void onRefresh() {
    _pageNumber = 1;
    _getArchivedCases();
  }

  void loadMore() {
    _pageNumber++;
    _getArchivedCases();
  }

  void _getArchivedCases() {
    _datasource.getArchivedCases(
      contractBoardId: legalDepartmentId.toString(),
      pageNumber: _pageNumber,
      search: searchCtrl.text.trim().isEmpty ? null : searchCtrl.text.trim(),
      onResponse: (final response) {
        if (legalCases.subject.isClosed || response.resultList == null) return;
        if (_pageNumber == 1) {
          legalCases(response.resultList);
          refreshController.refreshCompleted();
        } else {
          legalCases.addAll(response.resultList!);
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

  void restoreCase(final int? caseId) {
    if (!haveLegalAdminAccess) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }

    if (caseId == null) return;

    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _datasource.restoreCase(
          legalCaseId: caseId,
          onResponse: (final response) {
            legalCases.removeWhere((final e) => e.id == caseId);
            AppNavigator.snackbarGreen(title: s.done, subtitle: '');
          },
          onError: (final errorResponse) {},
        );
      },
    );
  }
}
