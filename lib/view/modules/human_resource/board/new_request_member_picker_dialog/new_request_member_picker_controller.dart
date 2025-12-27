import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';

mixin NewRequestMemberPickerController {
  late final HRDepartmentReadDto _department;
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final RefreshController refreshController = RefreshController();

  MemberReadDto? selectedMember;

  int _pageNumber = 1;
  final RxList<MemberReadDto> members = <MemberReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;

  void disposeItems() {
    refreshController.dispose();
    members.close();
    pageState.close();
  }

  void initialController(final HRDepartmentReadDto department) {
    _department = department;
    _pageNumber = 1;
    _fetchMembers();
  }

  void loadNextListPage() {
    _pageNumber++;
    _fetchMembers();
  }

  void _fetchMembers() {
    if (_department.slug == null) return;
    _memberDatasource.getHrDepartmentMembers(
      departmentSlug: _department.slug!,
      pageNumber: _pageNumber,
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (members.subject.isClosed) return;
        if (_pageNumber == 1) {
          members.assignAll(response.resultList!);
          refreshController.refreshCompleted();
        } else {
          members.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
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

  void setSelectedMember(final MemberReadDto member) {
    selectedMember = member;
  }
}
