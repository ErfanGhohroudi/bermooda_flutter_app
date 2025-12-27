import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../data/data.dart';

class RemovedMembersListController extends GetxController {
  RemovedMembersListController({
    this.department,
  });

  final HRDepartmentReadDto? department;
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchCtrl = TextEditingController();
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool _isAtEnd = false;
  int _pageNumber = 1;

  final RxList<MemberReadDto> members = <MemberReadDto>[].obs;

  bool get isAtEnd => _isAtEnd;

  @override
  void onInit() {
    refreshMembers();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    debugPrint("RemovedMembersListController closed!!!");
    scrollController.removeListener(_scrollListener);
    refreshController.dispose();
    scrollController.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onSearch() {
    pageState.loading();
    refreshMembers();
  }

  void refreshMembers() {
    _pageNumber = 1;
    _getAllRemovedMembers();
  }

  void moreMembers() {
    _pageNumber++;
    _getAllRemovedMembers();
  }

  void _getAllRemovedMembers() {
    _memberDatasource.getAllWorkspaceRemovedMembers(
      departmentSlug: department?.slug,
      pageNumber: _pageNumber,
      query: searchCtrl.text.trim(),
      onResponse: (final response) {
        if (members.subject.isClosed || response.resultList == null) return;

        if (_pageNumber == 1) {
          members.assignAll(response.resultList!);
          refreshController.refreshCompleted();
        } else {
          members.addAll(response.resultList!);
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
        if (_pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: _pageNumber == 1 && members.isEmpty,
    );
  }

  void restoreAMembers({
    required final MemberReadDto member,
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restoreAMembers(member: member, action: action);
      },
    );
  }

  void _restoreAMembers({
    required final MemberReadDto member,
    required final VoidCallback action,
  }) {
    _memberDatasource.restoreAMember(
      memberId: member.id,
      onResponse: () {
        action();
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
