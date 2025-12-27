import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../core/constants.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import '../human_resource/attendance/attendance/attendance_page.dart';
import 'drawer/rout_drawer_page.dart';
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
            title: Obx(
              () => Text(
                ctrl.currentWorkspaceTitle.value,
                style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ).pSymmetric(horizontal: 24),
            ),
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
              ),
              const Icon(
                Icons.headset_mic_rounded,
                size: 25,
              ).withTooltip(s.support).onTap(
                () {
                  ULaunch.launchURL(AppConstants.supportUrl, mode: LaunchMode.inAppWebView);
                },
              ),
              const SizedBox(width: 16),
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
                  customBottomNavigationBarItem(ctx: context, title: s.dashboard, activeIcon: AppIcons.dashboard, deActiveIcon: AppIcons.dashboardOutline),
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.conversations,
                    activeIcon: AppIcons.chat,
                    deActiveIcon: AppIcons.chatOutline,
                    showBadge: ctrl.unreadChatMessagesCount.value > 0,
                    badgeContent: ctrl.unreadChatMessagesCount.value.toString(),
                  ),
                  customBottomNavigationBarItem(ctx: context, title: s.modules, activeIcon: AppIcons.extension, deActiveIcon: AppIcons.extensionOutline),
                  customBottomNavigationBarItem(
                    ctx: context,
                    title: s.notifications,
                    activeIcon: AppIcons.notification,
                    deActiveIcon: AppIcons.notificationOutline,
                    showBadge: ctrl.unreadNotificationsCount.value > 0,
                    badgeContent: ctrl.unreadNotificationsCount.value.toString(),
                  ),
                  customBottomNavigationBarItem(ctx: context, title: s.profile, activeIcon: AppIcons.profile, deActiveIcon: AppIcons.profileOutline),
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
}) =>
    BottomNavigationBarItem(
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
