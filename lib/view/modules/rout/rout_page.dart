import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../core/constants.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../human_resource/attendance/attendance/attendance_page.dart';
import '../workspace/create/create_workspace_page.dart';
import 'drawer/rout_drawer_page.dart';
import 'widgets/workspace_list_item.dart';
import 'rout_controller.dart';

class RoutPage extends StatelessWidget {
  const RoutPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return const RoutPageState();
  }
}

class RoutPageState extends StatefulWidget {
  const RoutPageState({super.key});

  @override
  State<RoutPageState> createState() => _RoutPageState();
}

class _RoutPageState extends State<RoutPageState> {
  late final RoutController ctrl;
  final Core _core = Get.find<Core>();

  @override
  void initState() {
    debugPrint("✅✅✅ RoutPageState INITIALIZED - hashCode: $hashCode");

    // همیشه controller جدید ایجاد کنیم تا GlobalKey منحصر به فرد باشد
    // if (Get.isRegistered<RoutController>()) {
    //   Get.delete<RoutController>();
    // }
    ctrl = Get.put(RoutController());

    super.initState();
  }

  @override
  void dispose() {
    // if (Get.isRegistered<RoutController>()) {
    //   Get.delete<RoutController>();
    // }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final systemUiStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: context.theme.cardColor,
      statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiStyle,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (final didPop, final result) async {
          if (didPop) return;
          await ctrl.onWillPop();
        },
        child: Scaffold(
          key: routPageScaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: _workspaceSwitcherTitle(context),
            leading: Obx(
              () => UBadge(
                showBadge: ctrl.haveNotAcceptedWorkspace.value || ctrl.subService.isNoPurchased || ctrl.subService.isExpired,
                smallSize: 10,
                position: BadgePosition.topEnd(top: 15, end: 12),
                child: const Icon(Icons.menu_rounded, size: 25).onTap(
                  () => routPageScaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: showAttendanceBottomSheet,
                icon: const UImage(AppIcons.timerOutline, color: Colors.white, size: 25),
                tooltip: s.attendance,
                style: IconButton.styleFrom(
                  // padding: const EdgeInsets.all(2),
                  // fixedSize: const Size(25, 25),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              IconButton(
                onPressed: () => ULaunch.launchURL(AppConstants.supportUrl, mode: LaunchMode.inAppWebView),
                icon: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 25),
                tooltip: s.support,
                style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: const RoutDrawerPage(),
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.ltr,
            child: Obx(
              () => BottomNavigationBar(
                backgroundColor: context.theme.cardColor,
                currentIndex: ctrl.currentPageIndex.value,
                onTap: (final index) {
                  // if (index == 2) return print("menu clicked!!!");
                  ctrl.changePage(index);
                },
                unselectedFontSize: 10,
                selectedFontSize: 10,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: context.theme.primaryColor,
                unselectedItemColor: CupertinoColors.inactiveGray,
                items: [
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.dashboard,
                    activeIcon: AppIcons.dashboard,
                    deActiveIcon: AppIcons.dashboardOutline,
                  ),
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.conversations,
                    activeIcon: AppIcons.chat,
                    deActiveIcon: AppIcons.chatOutline,
                    showBadge: ctrl.unreadChatMessagesCount.value > 0,
                    badgeContent: ctrl.unreadChatMessagesCount.value.toString(),
                  ),
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.modules,
                    activeIcon: AppIcons.extension,
                    deActiveIcon: AppIcons.extensionOutline,
                  ),
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.notifications,
                    activeIcon: AppIcons.notification,
                    deActiveIcon: AppIcons.notificationOutline,
                    showBadge: ctrl.unreadNotificationsCount.value > 0,
                    badgeContent: ctrl.unreadNotificationsCount.value.toString(),
                  ),
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.profile,
                    activeIcon: AppIcons.profile,
                    deActiveIcon: AppIcons.profileOutline,
                  ),
                ],
              ),
            ),
          ),
          body: GetBuilder<RoutController>(
            builder: (final controller) => controller.screen,
          ),
        ),
      ),
    );
  }

  Widget _workspaceSwitcherTitle(final BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => _showWorkspaceBottomSheet(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            if (ctrl.haveNotAcceptedWorkspace.value)
              const UBadge(
                showBadge: true,
                smallSize: 10,
                animationType: BadgeAnimationType.fade,
              ),
            Flexible(
              child: Text(
                ctrl.currentWorkspaceTitle.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
            if (ctrl.isOwnerOfCurrentWorkspace.value) ...[
              const SizedBox.shrink(),
              const UImage(AppIcons.crownOutline, size: 20, color: Colors.white),
            ],
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.white,
            ),
          ],
        ).pSymmetric(horizontal: 24),
      ),
    );
  }

  void _showWorkspaceBottomSheet(final BuildContext context) {
    final currentId = _core.currentWorkspace.value.id;
    final workspaces = _core.workspaces;
    final listIsNotEmpty = workspaces.isNotEmpty;

    bottomSheetWithNoScroll(
      title: s.businesses,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          if (listIsNotEmpty)
            UElevatedButton(
              width: double.maxFinite,
              title: s.newWorkspace,
              icon: Icon(Icons.add_rounded, color: context.theme.primaryColor, size: 25),
              titleColor: context.theme.primaryColor,
              borderWidth: 2,
              borderColor: context.theme.primaryColor,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              onTap: () => showCreateWorkspaceDialog(
                action: (final workspace) {
                  ctrl.changeCurrentWorkspace(workspace);
                },
              ),
            ),
          SizedBox(
            height: context.height * 0.3,
            child: listIsNotEmpty
                ? Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: ListView.separated(
                      itemCount: workspaces.length,
                      separatorBuilder: (final context, final index) {
                        return Divider(height: 10, color: context.theme.dividerColor.withValues(alpha: 0.5));
                      },
                      itemBuilder: (final context, final index) {
                        final workspace = workspaces[index];
                        final isSelected = workspace.id == currentId;

                        return WorkspaceListItem(
                          workspace: workspace,
                          isSelected: isSelected,
                          onTap: () {
                            UNavigator.back();
                            ctrl.changeCurrentWorkspace(workspace);
                          },
                        );
                      },
                    ),
                  )
                : WEmptyWidget(
                    showUploadButton: true,
                    buttonTitle: s.newWorkspace,
                    buttonIcon: const Icon(Icons.add_rounded, color: Colors.white, size: 25),
                    onTapButton: () => showCreateWorkspaceDialog(
                      action: (final workspace) {
                        ctrl.changeCurrentWorkspace(workspace);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

BottomNavigationBarItem customBottomNavigationBarItem({
  required final BuildContext ctx,
  required final String title,
  required final String activeIcon,
  required final String deActiveIcon,
  final double size = 30,
  final Widget? iconWidget,
  final Widget? deActiveIconWidget,
  final bool showBadge = false,
  final String badgeContent = '',
}) => BottomNavigationBarItem(
  activeIcon: UBadge(
    showBadge: showBadge,
    animationType: BadgeAnimationType.fade,
    position: const BadgePosition(top: -5, start: 20),
    badgeContent: Text(badgeContent).bodyMedium(color: Colors.white),
    child: iconWidget ?? UImage(activeIcon, size: size, color: ctx.theme.primaryColor),
  ),
  icon: UBadge(
    showBadge: showBadge,
    animationType: BadgeAnimationType.fade,
    position: const BadgePosition(top: -5, start: 20),
    badgeContent: Text(badgeContent).bodyMedium(color: Colors.white),
    child: deActiveIconWidget ?? UImage(deActiveIcon, size: size, color: CupertinoColors.inactiveGray),
  ),
  label: title,
);
