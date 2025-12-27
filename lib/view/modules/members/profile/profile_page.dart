import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/theme.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/data.dart';
import 'profile_controller.dart';
import 'tabs/personal_info/personal_info_tab.dart';
import 'tabs/timesheet/timesheet_tab.dart';
import 'tabs/requests/requests_tab.dart';
import 'tabs/salary_benefits/salary_benefits_tab.dart';
import 'tabs/performance/performance_tab.dart';
import 'tabs/documents/documents_tab.dart';
import 'tabs/assets/assets_tab.dart';
import 'tabs/employment/employment_tab.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.memberId,
    this.initialIndex = 0,
    this.canEdit = true,
    this.showAppBar = true,
    super.key,
  });

  final int? memberId;
  final int initialIndex;
  final bool canEdit;
  final bool showAppBar;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late final String controllerTag;
  final SubscriptionService _subService = Get.find<SubscriptionService>();
  late final ProfileController controller;
  late final TabController tabController;

  late final List<Tab> _tabs;
  late final List<LazyKeepAliveTabView> _pages;

  bool get haveHRModule => _subService.hrModuleIsActive;

  @override
  void initState() {
    controllerTag = "profile_controller_$hashCode";
    _initialTabs();
    debugPrint("ProfileController created => $controllerTag");
    controller = Get.put(
      tag: controllerTag,
      ProfileController(
        memberId: widget.memberId,
        initialTabIndex: widget.initialIndex < _tabs.length ? widget.initialIndex : 0,
        canEdit: widget.canEdit,
      ),
    );
    tabController = TabController(
      vsync: this,
      length: 8,
      initialIndex: controller.currentTabIndex.value,
    );
    tabController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() async {
    tabController.removeListener(_listener);
    if (Get.isRegistered<ProfileController>(tag: controllerTag)) {
      await Get.delete<ProfileController>(tag: controllerTag);
      debugPrint("ProfileController deleted => $controllerTag");
    }
    super.dispose();
  }

  void _initialTabs() {
    _tabs = [
      Tab(text: s.personalInfo),
      Tab(text: s.requests),
      Tab(text: s.timesheet),
      Tab(text: s.salaryAndBenefits),
      Tab(text: s.performance),
      Tab(text: s.documents),
      Tab(text: s.assets),
      Tab(text: s.employment),
    ];
    _initialPages();
  }

  void _initialPages() {
    _pages = [
      LazyKeepAliveTabView(builder: () => PersonalInfoTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => RequestsTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => TimesheetTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => SalaryBenefitsTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => PerformanceTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => DocumentsTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => AssetsTab(controller: controller)),
      LazyKeepAliveTabView(builder: () => EmploymentTab(controller: controller)),
    ];
  }

  void _listener() {
    if (tabController.indexIsChanging) {
      controller.switchTab(tabController.index);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: widget.showAppBar ? AppBar(title: Text(s.profile)) : null,
      body: Column(
        children: [
          // Employee Header Card
          Obx(
            () => _buildEmployeeHeader(),
          ),

          // Tab Bar
          WTabBar(
            controller: tabController,
            isScrollable: true,
            horizontalLabelPadding: 10,
            tabs: _tabs,
          ),

          // Tab Content
          Expanded(
            child: Obx(
              () {
                if (controller.pageState.isLoaded() == false) {
                  return const SizedBox.shrink();
                }

                return WTabBarView(
                  controller: tabController,
                  pages: _pages,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeHeader() {
    final String? memberFullName = controller.currentMember.value.fullName;

    return WCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              WCircleAvatar(
                user: UserReadDto(
                  id: controller.currentMember.value.userAccount?.id.toString() ?? '',
                  avatarUrl: controller.currentMember.value.userAccount?.avatarUrlMain?.url,
                  fullName: memberFullName,
                ),
                size: 80,
                showFullName: false,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      memberFullName ?? "- -",
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      controller.currentMember.value.personnelCode ?? "- -",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.hintColor,
                      ),
                    ),
                    if (controller.hrModuleIsActive)
                      Row(
                        children: [
                          Text(
                            "${s.workShift}: ",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.theme.hintColor,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              controller.currentMember.value.workShift?.title ?? "- -",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.theme.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (controller.canEdit)
                WMoreButtonIcon(
                  items: [
                    WPopupMenuItem(
                      icon: AppIcons.editOutline,
                      title: s.edit,
                      iconColor: AppColors.green,
                      titleColor: AppColors.green,
                      onTap: controller.editPersonalInfo,
                    ),
                    if (controller.currentMember.value.type.isNotOwner() && controller.haveAdminAccess)
                      WPopupMenuItem(
                        icon: AppIcons.delete,
                        title: s.removeMember,
                        iconColor: AppColors.red,
                        titleColor: AppColors.red,
                        onTap: controller.removeMember,
                      ),
                    if (controller.department != null && _subService.hrModuleIsActive && controller.haveAdminAccess)
                      WPopupMenuItem(
                        icon: AppIcons.arrows,
                        title: s.transfer,
                        onTap: controller.transferMember,
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: AppIcons.departmentOutline,
                  title: s.department,
                  value: controller.department?.title ?? '- -',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: AppIcons.calendarOutline,
                  title: s.joinDate,
                  value: controller.currentMember.value.jtime ?? "- -",
                ),
              ),
            ],
          ),
          if (!controller.currentMember.value.isAccepted)
            WLabel(
              minWidth: context.width,
              text: s.pendingInvitation,
              color: AppColors.orange,
            ).marginOnly(top: 16),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required final String icon,
    required final String title,
    required final String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UImage(icon, size: 20, color: context.theme.hintColor),
        const SizedBox(height: 4),
        Text(title).bodySmall(color: context.theme.hintColor),
        const SizedBox(height: 2),
        Text(value, textAlign: TextAlign.center).bodyMedium(),
      ],
    );
  }
}
