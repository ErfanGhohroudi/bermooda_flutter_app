import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../data/data.dart';
import '../../human_resource/removed_list/removed_members_list_controller.dart';
import 'members_list_page.dart';

class MembersListController extends GetxController {
  MembersListController({
    required this.department,
    this.pageType = MemberListPageType.normal,
  });

  List<int?> deletedMembersId = [];
  final core = Get.find<Core>();
  final _perService = Get.find<PermissionService>();

  late final MemberListPageType pageType;
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final HRDepartmentReadDto? department;
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  int pageNumber = 1;

  bool get haveAdminAccess => _perService.haveHRAdminAccess;

  final RxList<MemberReadDto> members = <MemberReadDto>[].obs;

  bool get isBottomSheet => pageType == MemberListPageType.bottomSheet;

  @override
  void onInit() {
    reloadMembers();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    debugPrint("MembersListController closed!!!");
    scrollController.removeListener(_scrollListener);
    refreshController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void updateMember(final MemberReadDto member) {
    if (deletedMembersId.contains(member.id)) return;
    final i = members.indexWhere((final e) => e.id == member.id);
    if (i != -1) {
      if (department != null && members[i].department?.slug != department?.slug) {
        members.removeAt(i);
        deletedMembersId.add(member.id);
      } else {
        members[i] = member;
      }
    }
  }

  void deleteMember(final MemberReadDto member) {
    if (deletedMembersId.contains(member.id)) return;
    final i = members.indexWhere((final e) => e.id == member.id);
    if (i != -1) {
      members.removeAt(i);
      if (Get.isRegistered<RemovedMembersListController>()) {
        Get.find<RemovedMembersListController>().refreshMembers();
      }
    }
  }

  void reloadMembers() {
    pageNumber = 1;
    _getAllMembers();
  }

  void moreMembers() {
    pageNumber++;
    _getAllMembers();
  }

  void _getAllMembers() {
    final justDepartmentMembers = department != null;

    _memberDatasource.getHrDepartmentMembers(
      justDepartmentMembers: justDepartmentMembers,
      departmentSlug: justDepartmentMembers ? department!.slug! : '',
      pageNumber: pageNumber,
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (members.subject.isClosed) return;
        if (pageNumber == 1) {
          members(response.resultList);
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
        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: pageNumber == 1 && members.isEmpty,
    );
  }
}
