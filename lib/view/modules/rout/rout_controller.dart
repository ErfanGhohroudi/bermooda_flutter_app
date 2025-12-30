import 'package:u/utilities.dart';
import 'dart:developer' as developer;

import '../../../core/services/subscription_service.dart';
import '../../../core/functions/workspace_functions.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../data/data.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/constants.dart';
import '../../../core/core.dart';
import '../../../core/functions/user_functions.dart';
import '../../../core/functions/init_app_functions.dart';
import '../../../core/services/websocket_service.dart';
import '../conversation/presentation/pages/conversations/conversations_list_page.dart';
import '../dashboard/dashboard_page.dart';
import '../members/list/members_list_page.dart';
import '../modules/modules_page.dart';
import '../notification/notification_page.dart';
import '../members/profile/profile_page.dart';
import '../../../view/modules/subscription/subscription_page.dart';

class RoutController extends GetxController {
  final WorkspaceDatasource _datasource = Get.find<WorkspaceDatasource>();
  final core = Get.find<Core>();
  final subService = Get.find<SubscriptionService>();
  bool? isNoSubscriptionDialogOpen;

  final int initialPageIndex = 0;
  final int maxPageIndex = 4;
  final Rx<int> currentPageIndex = 0.obs;

  // --- LAZY LOADING IMPLEMENTATION ---
  // لیستی برای نگهداری ویجت‌های ساخته شده (کش کردن صفحات)
  late Widget screen;

  final RxString currentWorkspaceTitle = ''.obs;
  final RxBool isOwnerOfCurrentWorkspace = false.obs;

  final RxInt unreadNotificationsCount = 0.obs;
  final RxInt unreadChatMessagesCount = 0.obs;
  final RxBool haveNotAcceptedWorkspace = false.obs;

  late final Worker _workspaceWorker;
  late final Worker _notificationsWorker;
  late final Worker _chatMessagesWorker;
  late final Worker _notAcceptedWorkspaceWorker;

  @override
  void onInit() {
    currentWorkspaceTitle.value = core.currentWorkspace.value.title ?? '';
    isOwnerOfCurrentWorkspace.value = core.currentWorkspace.value.type.isOwner();
    _workspaceWorker = ever(core.currentWorkspace, (final newWorkspace) {
      currentWorkspaceTitle(newWorkspace.title);
      isOwnerOfCurrentWorkspace(newWorkspace.type.isOwner());
      onWorkspaceChanged();
    });
    unreadNotificationsCount.value = core.unreadNotificationsCount.value;
    _notificationsWorker = ever(core.unreadNotificationsCount, (final count) {
      unreadNotificationsCount(count);
    });
    unreadChatMessagesCount.value = core.unreadChatMessagesCount.value;
    _chatMessagesWorker = ever(core.unreadChatMessagesCount, (final count) {
      unreadChatMessagesCount(count);
    });
    haveNotAcceptedWorkspace(core.haveNotAcceptedWorkspace.value);
    _notAcceptedWorkspaceWorker = ever(core.haveNotAcceptedWorkspace, (final status) {
      haveNotAcceptedWorkspace(status);
    });
    currentPageIndex(initialPageIndex);
    _setupFirebaseMessaging();
    _handleInitialInviteCheck();
    changePage(initialPageIndex);
    _checkSubscription();
    _checkFcmToken();
    super.onInit();
  }

  @override
  void onClose() {
    developer.log("❌❌❌ RoutPageState DISPOSED - hashCode: $hashCode");
    _workspaceWorker.dispose();
    _notificationsWorker.dispose();
    _chatMessagesWorker.dispose();
    _notAcceptedWorkspaceWorker.dispose();
    super.onClose();
  }

  void _setupFirebaseMessaging() {
    UFirebase.setupFirebaseMessaging(
      channelId: channelId,
      channelName: channelName,
      icon: notificationIcon,
      onReceiveNotificationWhenInApp: (final message) {
        final data = message.data;
        developer.log("notifLog onReceiveNotificationWhenInApp message.data => $data");
        final type = data["type"];

        switch (type) {
          case "conversation_notification":
            core.increaseUnreadChatMessagesCount();
            break;
          default:
            core.increaseUnreadNotificationsCount();
            break;
        }
      },
      onMessageOpenedApp: (final message) {
        // When tap notification
        final data = message.data;
        developer.log("notifLog onMessageOpenedApp message.data => $data");
        final type = data["type"] as String?;

        handleNotificationTap(type);
      },
      onBackgroundMessageReceive: (final message) async {},
    );
  }

  void handleNotificationTap(final String? type) {
    switch (type) {
      case "conversation_notification":
        if (currentPageIndex.value != 1) {
          delay(500, () {
            /// switch page to notification page
            changePage(1);
          });
        } else {
          resetCurrentPage();
        }
        break;
      default:
        if (currentPageIndex.value != 3) {
          delay(500, () {
            /// switch page to notification page
            changePage(3);
          });
        } else {
          resetCurrentPage();
        }
        break;
    }
  }

  // این تابع ویجت یک صفحه را بر اساس ایندکس آن می‌سازد
  Widget _buildPageForIndex(final int index) {
    switch (index) {
      case 0:
        return DashboardPage(key: UniqueKey());
      case 1:
        return ConversationsListPage(key: UniqueKey());
      case 2:
        return ModulesPage(key: UniqueKey());
      case 3:
        return NotificationPage(key: UniqueKey());
      case 4:
        return ProfilePage(
          showAppBar: false,
          memberId: core.currentWorkspace.value.memberId ?? 0,
          canEdit: false,
          key: UniqueKey(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void resetCurrentPage() {
    screen = _buildPageForIndex(currentPageIndex.value);
    currentPageIndex.refresh();
    update();
  }

  /// Change current workspace and re-init app if needed
  void changeCurrentWorkspace(final WorkspaceReadDto newWorkspace) {
    _datasource.changeCurrentWorkspace(
      id: newWorkspace.id,
      onResponse: () {
        if (WebSocketService().isConnected.value) return;
        initApp(currentWorkspaceChanged: true);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  Future<void> changePage(int index) async {
    if (currentPageIndex.value == index) {
      // Reset current page
      resetCurrentPage();
      return;
    }

    if (index > maxPageIndex) index = maxPageIndex;

    screen = _buildPageForIndex(index);
    update(); // به GetBuilder اطلاع می‌دهیم که UI را با کلید جدید بازسازی کند

    currentPageIndex(index);
  }

  /// For Rebuild Pages After Changed Workspace
  void onWorkspaceChanged() async {
    _handleInitialInviteCheck();
    closeDrawerIfOpen();

    await changePage(initialPageIndex);
    Navigator.popUntil(navigatorKey.currentContext!, (final route) => route.isFirst);
    _checkSubscription();
  }

  void closeDrawerIfOpen() {
    if (routPageScaffoldKey.currentState?.isDrawerOpen ?? false) {
      routPageScaffoldKey.currentState!.closeDrawer();
    }
  }

  Future<bool> onWillPop() async {
    final isDrawerOpen = routPageScaffoldKey.currentState?.isDrawerOpen ?? false;

    if (isDrawerOpen) {
      routPageScaffoldKey.currentState!.closeDrawer();
    } else if (currentPageIndex.value != initialPageIndex) {
      changePage(initialPageIndex);
    } else {
      await appShowYesCancelDialog(
        title: s.exit,
        description: s.exitApp,
        onYesButtonTap: () {
          UNavigator.back(); // Close the dialog
          SystemNavigator.pop(); // Exit the app
        },
      );
    }
    return false;
  }

  void _checkSubscription() {
    final isWorkspaceOwner = core.currentWorkspace.value.type.isOwner();
    final isExpired = subService.isExpired;
    final isNoPurchased = subService.isNoPurchased;

    if (isWorkspaceOwner == false) return;

    if (isExpired || isNoPurchased) {
      _showNoSubscriptionDialog(isNoPurchased: isNoPurchased, isExpired: isExpired);
    } else if (core.currentWorkspace.value.membersIsEmpty) {
      _showAddMemberBottomSheet();
    }
  }

  void _checkFcmToken() {
    final fcmTokenHasNotSet = ULocalStorage.getBool(AppConstants.hasNotSetFcmToken);
    if (fcmTokenHasNotSet == true) {
      addFcmToken(action: () {});
    }
  }

  void _showNoSubscriptionDialog({
    required final bool isNoPurchased,
    required final bool isExpired,
  }) {
    if (isNoSubscriptionDialogOpen == true) return;
    delay(2000, () {
      if (isNoSubscriptionDialogOpen == true) return;
      if (isNoPurchased == false && isExpired == false) return;
      isNoSubscriptionDialogOpen = true;
      appShowYesCancelDialog(
        barrierDismissible: false,
        title: s.subscription,
        description: isNoPurchased
            ? s.noSubscriptionDialogDescription
            : isExpired
            ? s.expiredSubscriptionDialogDescription
            : '',
        cancelButtonTitle: s.later,
        yesButtonTitle: isNoPurchased
            ? s.buySubscription
            : isExpired
            ? s.renewSubscription
            : '',
        onYesButtonTap: () {
          UNavigator.back();
          delay(500, () {
            UNavigator.push(SubscriptionPage(workspaceId: core.currentWorkspace.value.id));
          });
        },
      ).then((final value) => delay(1000, () => isNoSubscriptionDialogOpen = false));
    });
  }

  void _showAddMemberBottomSheet() {
    delay(2000, () {
      bottomSheetWithNoScroll(
        title: s.membersList,
        isDismissible: false,
        enableDrag: false,
        child: const MembersListPage(department: null, pageType: MemberListPageType.bottomSheet),
      );
    });
  }

  void _handleInitialInviteCheck() {
    if (!core.currentWorkspace.value.isAccepted && core.currentWorkspace.value.type.isMember()) {
      // Show who is invited you to this workspace and you can accept or reject it.
      _getTextInvite();
    }
  }

  void _getTextInvite() {
    _datasource.getTextInvite(
      onResponse: (final text) {
        appShowYesCancelDialog(
          description: text,
          descriptionTextAlign: TextAlign.center,
          barrierDismissible: false,
          cancelButtonTitle: s.decline,
          onCancelButtonTap: () {
            UNavigator.back();
            _acceptWorkspaceInvite(isAccepted: false);
          },
          yesButtonTitle: s.accept,
          onYesButtonTap: () {
            UNavigator.back();
            _acceptWorkspaceInvite(isAccepted: true);
          },
        );
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _acceptWorkspaceInvite({required final bool isAccepted}) {
    _datasource.acceptWorkspaceInvitation(
      isAccepted: isAccepted,
      onResponse: () {
        getMyUser(
          withLoading: true,
          action: () {
            getWorkspaces(
              withLoading: true,
              action: () => onWorkspaceChanged(),
            );
          },
        );
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
