import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/data.dart';
import '../invite/invite_member_page.dart';
import '../profile/profile_page.dart';
import 'members_list_controller.dart';

enum MemberListPageType { normal, bottomSheet }

/// ```dart
/// if (department == null) {
///   list = all the workspace members;
/// } else {
///   list = all the department members;
/// }
/// ```
class MembersListPage extends StatefulWidget {
  const MembersListPage({
    required this.department,
    this.pageType = MemberListPageType.normal,
    super.key,
  });

  final HRDepartmentReadDto? department;
  final MemberListPageType pageType;

  @override
  State<MembersListPage> createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  late final MembersListController controller;

  @override
  void initState() {
    controller = Get.put(MembersListController(
      department: widget.department,
      pageType: widget.pageType,
    ));
    super.initState();
  }

  @override
  void dispose() {
    if (Get.isRegistered<MembersListController>()) {
      Get.delete<MembersListController>();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: controller.haveAdminAccess
          ? FloatingActionButton(
              heroTag: "membersListFAB",
              onPressed: () {
                UNavigator.push(
                  /// For add new member
                  InviteMemberPage(
                    showDepartmentField: true,
                    department: controller.department,
                    onResponse: (final member) {
                      controller.members.add(member);
                    },
                  ),
                );
              },
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
      bottomNavigationBar: controller.isBottomSheet
          ? UElevatedButton(
              title: s.done,
              onTap: () => UNavigator.back(),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () => controller.pageState.isLoaded()
                ? WSmartRefresher(
                    controller: controller.refreshController,
                    scrollController: controller.scrollController,
                    enablePullUp: !controller.isBottomSheet,
                    enablePullDown: !controller.isBottomSheet,
                    onRefresh: controller.reloadMembers,
                    onLoading: controller.moreMembers,
                    child: controller.members.isNotEmpty
                        ? ListView.separated(
                            itemCount: controller.members.length,
                            padding: EdgeInsets.only(
                              left: controller.isBottomSheet ? 0 : 16,
                              right: controller.isBottomSheet ? 0 : 16,
                              top: 10,
                              bottom: controller.haveAdminAccess ? 100 : 10,
                            ),
                            separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                            itemBuilder: (final context, final index) => _memberItem(member: controller.members[index]),
                          )
                        : const Center(child: WEmptyWidget()),
                  )
                : ListView.separated(
                    itemCount: 15,
                    padding: EdgeInsets.symmetric(horizontal: controller.isBottomSheet ? 0 : 16, vertical: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                    itemBuilder: (final context, final index) => const WCard(
                      child: SizedBox(height: 40),
                    ),
                  ).shimmer(),
          ),

          /// Scroll to top
          WScrollToTopButton(
            scrollController: controller.scrollController,
            show: controller.showScrollToTop,
            bottomMargin: 90,
          ),
        ],
      ),
    );
  }

  Widget _memberItem({
    required final MemberReadDto member,
  }) {
    final String? memberFullName = member.fullName;

    final bool isMe = member.userAccount?.id.toString() == controller.core.userReadDto.value.id;
    final bool isOwner = member.type.isOwner();
    final bool inviteIsPending = !member.isAccepted;

    return WCard(
      showBorder: true,
      onTap: () {
        UNavigator.push(ProfilePage(memberId: member.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: WCircleAvatar(
                  user: UserReadDto(
                    id: '',
                    avatarUrl: member.userAccount?.avatarUrlMain?.url,
                    fullName: memberFullName,
                  ),
                  showFullName: true,
                  size: 50,
                ),
              ),
              const SizedBox(width: 10),
              if (isOwner) UImage(AppIcons.crownOutline, color: context.theme.primaryColor, size: 30),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ],
          ),
          const Divider(height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              _item(
                title: s.personnelCode,
                value: member.personnelCode,
              ),
              _item(
                title: s.workShift,
                value: member.workShift?.title,
              ),
              if (controller.haveAdminAccess)
                _item(
                  title: s.phoneNumber,
                  value: member.userAccount?.phoneNumber,
                ),
              _item(
                title: s.date,
                value: member.jtime ?? (isMe ? (controller.core.userReadDto.value.jTime) : null),
              ),
              if (inviteIsPending)
                _item(
                  title: s.status,
                  valueWidget: WLabel(
                    text: s.pendingInvitation,
                    color: AppColors.orange,
                  ),
                ),
            ],
          ).marginOnly(top: 6),
        ],
      ),
    );
  }

  Widget _item({
    required final String title,
    final String? value,
    final Widget? valueWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 5,
      children: [
        Flexible(child: Text("$title ------------------------------------------------------------------------------------", maxLines: 1).bodyMedium(color: Colors.grey)),
        valueWidget ?? ConstrainedBox(constraints: BoxConstraints(maxWidth: context.width / 2), child: Text(value ?? "- -").bodyMedium()),
      ],
    );
  }
}
