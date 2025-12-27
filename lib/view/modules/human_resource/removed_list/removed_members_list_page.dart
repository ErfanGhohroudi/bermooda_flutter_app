import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/data.dart';
import 'removed_members_list_controller.dart';

class RemovedMembersListPage extends StatefulWidget {
  const RemovedMembersListPage({
    this.department,
    super.key,
  });

  final HRDepartmentReadDto? department;

  @override
  State<RemovedMembersListPage> createState() => _RemovedMembersListPageState();
}

class _RemovedMembersListPageState extends State<RemovedMembersListPage> {
  late final RemovedMembersListController controller;

  @override
  void initState() {
    controller = Get.put(RemovedMembersListController(
      department: widget.department,
    ));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      body: Stack(
        children: [
          _emptyWidget(),
          Column(
            children: [
              _searchField(),
              Expanded(
                child: Stack(
                  children: [
                    Obx(
                      () => controller.pageState.isLoaded()
                          ? WSmartRefresher(
                              controller: controller.refreshController,
                              scrollController: controller.scrollController,
                              onRefresh: controller.refreshMembers,
                              onLoading: controller.moreMembers,
                              child: ListView.builder(
                                itemCount: controller.members.length,
                                padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: controller.isAtEnd ? 100 : 5),
                                itemBuilder: (final context, final index) => _memberItem(
                                  member: controller.members[index],
                                  onRestore: () {
                                    controller.members.removeAt(index);
                                  },
                                ),
                              ),
                            )
                          : _shimmerList(),
                    ),

                    /// Scroll to top
                    WScrollToTopButton(
                      scrollController: controller.scrollController,
                      show: controller.showScrollToTop,
                      bottomMargin: 90,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memberItem({
    required final MemberReadDto member,
    required final VoidCallback onRestore,
  }) {
    final String? memberFullName = member.fullName;

    return WCard(
      showBorder: true,
      child: Row(
        children: [
          WCircleAvatar(
            user: UserReadDto(
              id: '',
              avatarUrl: member.userAccount?.avatarUrlMain?.url,
              fullName: memberFullName,
            ),
            subTitle: Text(member.userAccount?.phoneNumber ?? '- -').bodySmall(color: context.theme.hintColor),
            showFullName: true,
            size: 50,
          ).expanded(),
          WMoreButtonIcon(
            items: [
              WPopupMenuItem(
                title: s.restore,
                icon: AppIcons.restore,
                onTap: () => controller.restoreAMembers(
                  member: member,
                  action: onRestore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return WSearchField(
      controller: controller.searchCtrl,
      borderRadius: 0,
      height: 50,
      onChanged: (final value) => controller.onSearch(),
    );
  }

  Widget _emptyWidget() {
    return Obx(
      () {
        final showEmptyWidget = controller.pageState.isLoaded() && controller.members.isEmpty;
        if (showEmptyWidget) return const Center(child: WEmptyWidget());
        return const SizedBox.shrink();
      },
    );
  }

  Widget _shimmerList() {
    return ListView.builder(
      itemCount: 15,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (final context, final index) => const WCard(
        child: SizedBox(height: 50),
      ),
    ).shimmer();
  }
}
