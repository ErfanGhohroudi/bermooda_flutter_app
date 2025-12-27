import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/functions/user_functions.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../../account/change_password/change_password_page.dart';
import '../../account/update/update_account_page.dart';
import '../../workspace/create/create_workspace_page.dart';
import '../../workspace/list/workspace_list_page.dart';
import 'rout_drawer_controller.dart';
import 'widgets/create_workspace_button.dart';
import 'widgets/workspace_list_item.dart';

class RoutDrawerPage extends StatefulWidget {
  const RoutDrawerPage({super.key});

  @override
  State<RoutDrawerPage> createState() => _RoutDrawerPageState();
}

class _RoutDrawerPageState extends State<RoutDrawerPage> with RoutDrawerController {
  @override
  void initState() {
    initialController();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  List<Widget> _buildWorkspacesList(final BuildContext context, final List<WorkspaceReadDto> workspaces) {
    final filteredList = workspaces.where((final e) => e.id != core.currentWorkspace.value.id).toList();

    return [
      CreateWorkspaceButton(
        onTap: () {
          showCreateWorkspaceDialog();
        },
      ),
      if (filteredList.isNotEmpty) const Divider(height: 6),
      for (int i = 0; i < filteredList.length; i++) ...[
        WorkspaceListItem(
          workspace: filteredList[i],
          onTap: () {
            setState(() {
              isShowWorkspaces = !isShowWorkspaces;
            });
            changeCurrentWorkspace(filteredList[i]);
          },
        ),
        if (i < filteredList.length - 1) const Divider(height: 6),
      ],
    ];
  }

  @override
  Widget build(final BuildContext context) {
    return WGlassDrawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.close, size: 35, color: Colors.white).onTap(
                        () {
                          setState(() {
                            isShowWorkspaces = false;
                            routCtrl.closeDrawerIfOpen();
                          });
                        },
                      ).marginOnly(top: 10),
                    ],
                  ).pSymmetric(horizontal: 6),

                  /// Header
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _avatarAndWorkspaces(),
                      if (core.currentWorkspace.value.type.isOwner()) _subscriptionInfo(),
                      _storage(),
                    ],
                  ).marginSymmetric(horizontal: 6),
                  const Divider(),

                  /// Other items
                  Column(
                    children: [
                      _myBusinesses(),
                      _theme(),
                      _logout(),
                      if (kDebugMode)
                        WCard(
                          onTap: changeLanguage,
                          child: const Text("s.changeLanguage"),
                        ),
                    ],
                  ).marginSymmetric(horizontal: 6),
                ],
              ),
            ),
          ),
          Text("${s.version}: ${UApp.version}").bodySmall(color: Colors.white).marginSymmetric(vertical: 6),
        ],
      ),
    );
  }

  Widget _avatarAndWorkspaces() => WCard(
        padding: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Avatar and full name
            Row(
              children: [
                Obx(() => WCircleAvatar(user: myUser.value, showFullName: true, maxLines: 2)).expanded(),
                Icon(Icons.more_vert_rounded, color: context.theme.hintColor).showMenus([
                  WPopupMenuItem(
                    title: '${s.edit} ${s.account}',
                    icon: AppIcons.editOutline,
                    onTap: () => showAppDialog(
                      barrierDismissible: false,
                      useSafeArea: true,
                      const AlertDialog(
                        content: UpdateAccountPage(),
                      ),
                    ),
                  ),
                  WPopupMenuItem(
                    title: '${s.edit} ${s.password}',
                    icon: AppIcons.editOutline,
                    onTap: () => showAppDialog(
                      barrierDismissible: false,
                      useSafeArea: true,
                      const AlertDialog(
                        content: ChangePasswordPage(),
                      ),
                    ),
                  ),
                ]),
              ],
            ).marginOnly(bottom: 10),

            /// Change workspace [dropdown]
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.theme.primaryColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Obx(
                    () => haveNotAcceptedWorkspace.value
                        ? const Row(
                            children: [
                              UBadge(showBadge: true, smallSize: 10),
                              SizedBox(width: 10),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  Text(
                    routCtrl.currentWorkspaceTitle.value,
                    maxLines: 1,
                    style: context.textTheme.bodyMedium!.copyWith(color: Colors.white, overflow: TextOverflow.ellipsis),
                  ).expanded(),
                  if (routCtrl.isOwnerOfCurrentWorkspace.value) const UImage(AppIcons.crownOutline, size: 20, color: Colors.white),
                  Icon(
                    isShowWorkspaces ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ).onTap(() {
              setState(() {
                isShowWorkspaces = !isShowWorkspaces;
              });
            }),

            /// Workspaces list
            if (isShowWorkspaces)
              Obx(
                () => Container(
                  constraints: BoxConstraints(maxHeight: context.height / 2),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _buildWorkspacesList(context, core.workspaces),
                    ),
                  ),
                ),
              ).marginSymmetric(horizontal: 10),
          ],
        ),
      ).marginOnly(top: 10);

  Widget _subscriptionInfo() {
    if (routCtrl.subService.isNoPurchased) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: UElevatedButton(
          width: double.infinity,
          title: s.buySubscription,
          backgroundColor: AppColors.orange,
          onTap: navigateToSubscription,
        ),
      );
    }

    return WCard(
      child: Column(
        spacing: 6,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.subscription).bodyMedium(),
              if (routCtrl.subService.isTrial || routCtrl.subService.isNoPurchased)
                Text(routCtrl.subService.subscription.purchaseType.getTitle()).bodyMedium(
                  color: routCtrl.subService.isNoPurchased
                      ? AppColors.red
                      : routCtrl.subService.isTrial
                          ? AppColors.orange
                          : Colors.grey,
                ),
              // WLabel(
              //   text: routCtrl.subService.subscription.purchaseType.getTitle(),
              //   color: routCtrl.subService.isNoPurchased
              //       ? AppColors.red
              //       : routCtrl.subService.isTrial
              //           ? AppColors.orange
              //           : Colors.grey,
              // ),
            ],
          ),
          if (routCtrl.subService.isPurchasedOrTrial) ...[
            Row(
              spacing: 8,
              children: [
                Text("${s.status}:").bodyMedium(color: context.theme.hintColor),
                Flexible(child: Text(routCtrl.subService.subscription.status.title).bodyMedium(color: routCtrl.subService.subscription.status.color)),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Text("${s.subscriptionPeriod}:").bodyMedium(color: context.theme.hintColor),
                Flexible(
                  child: Text(
                    routCtrl.subService.isTrial ? "30 ${s.days}" : routCtrl.subService.subscription.period.getTitle(),
                  ).bodyMedium(color: context.theme.hintColor),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Text("${s.remaining}:").bodyMedium(color: context.theme.hintColor),
                Flexible(child: Text("${routCtrl.subService.subscription.remainingDays} ${s.days}").bodyMedium(color: context.theme.hintColor)),
              ],
            ),
          ],
          SizedBox(
            height: 35,
            child: UElevatedButton(
              width: double.infinity,
              title: routCtrl.subService.isNoPurchased
                  ? s.buySubscription
                  : routCtrl.subService.isExpired
                      ? s.renewSubscription
                      : s.upgradeSubscription,
              titleColor: context.theme.primaryColor,
              borderColor: context.theme.primaryColor,
              borderWidth: 2,
              backgroundColor: context.theme.cardColor,
              onTap: navigateToSubscription,
            ),
          ),
        ],
      ),
    );
  }

  Widget _storage() => WCard(
        elevation: 0,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Text(s.storage).bodyMedium(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text("${core.currentWorkspace.value.usedStorage} ${s.gb} ").bodyMedium(),
                  Text("${s.ofText} ${core.currentWorkspace.value.totalStorage} ${s.gb}").bodySmall(color: context.theme.hintColor),
                ],
              ),
              LinearProgressIndicator(
                value: core.currentWorkspace.value.totalStorage != 0 ? (core.currentWorkspace.value.usedStorage / core.currentWorkspace.value.totalStorage) : 0,
                color: core.currentWorkspace.value.totalStorage != 0 && ((core.currentWorkspace.value.usedStorage / core.currentWorkspace.value.totalStorage) < 0.9)
                    ? AppColors.green
                    : AppColors.red,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: context.theme.dividerColor,
                minHeight: 8,
              ),
            ],
          ),
        ),
      );

  Widget _myBusinesses() => WCard(
        elevation: 0,
        onTap: () => UNavigator.push(const WorkspaceListPage()),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minTileHeight: 20,
          title: Text(s.myBusinesses, style: context.textTheme.bodyMedium),
          leading: UImage(
            AppIcons.businessesOutline,
            color: context.theme.primaryColorDark,
            size: 30,
          ),
        ),
      );

  Widget _theme() => WCard(
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minTileHeight: 20,
          title: Text(s.theme, style: context.textTheme.bodyMedium),
          leading: UImage(
            AppIcons.moonOutline,
            color: context.theme.primaryColorDark,
            size: 30,
          ),
          trailing: WSwitch(
            value: context.isDarkMode,
            activeTrackColor: context.theme.primaryColor,
            thumbColor: Colors.black,
            inactiveThumbColor: Colors.white,
            thumbIcon: WidgetStatePropertyAll(Icon(
              context.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 25,
              color: context.isDarkMode ? Colors.white : AppColors.orange,
            )),
            onChanged: (final value) => changeTheme(),
          ),
        ),
      );

  Widget _logout() => WCard(
        elevation: 0,
        onTap: logoutWithShowDialog,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minTileHeight: 20,
          title: Text(s.logout, style: context.textTheme.bodyMedium),
          leading: UImage(
            AppIcons.logout,
            color: context.theme.primaryColorDark,
            size: 30,
          ),
        ),
      );
}
