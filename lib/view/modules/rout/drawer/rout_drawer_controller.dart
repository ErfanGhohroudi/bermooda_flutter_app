import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/functions/init_app_functions.dart';
import '../../../../data/data.dart';
import '../../../../core/services/websocket_service.dart';
import '../../subscription/subscription_page.dart';
import '../rout_controller.dart';

mixin RoutDrawerController {
  final WorkspaceDatasource _datasource = Get.find<WorkspaceDatasource>();
  final core = Get.find<Core>();
  final RoutController routCtrl = Get.find<RoutController>();
  bool isShowWorkspaces = false;
  late final Worker userWorker;
  late final Worker notificationWorker;
  late final Worker workspaceWorker;
  Rx<UserReadDto> myUser = const UserReadDto(id: '').obs;
  RxBool haveNotAcceptedWorkspace = false.obs;
  RxInt unreadNotificationCount = 0.obs;

  void disposeItems() {
    userWorker.dispose();
    notificationWorker.dispose();
    workspaceWorker.dispose();
    myUser.close();
    haveNotAcceptedWorkspace.close();
    unreadNotificationCount.close();
  }

  void initialController() {
    myUser.value = core.userReadDto.value;
    userWorker = ever(core.userReadDto, (final user) {
      myUser(user);
      myUser.refresh();
    });
    unreadNotificationCount(routCtrl.unreadNotificationsCount.value);
    notificationWorker = ever(routCtrl.unreadNotificationsCount, (final count) {
      unreadNotificationCount(count);
    });
    haveNotAcceptedWorkspace(core.haveNotAcceptedWorkspace.value);
    workspaceWorker = ever(core.haveNotAcceptedWorkspace, (final status) {
      haveNotAcceptedWorkspace(status);
    });
  }

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

  void changeTheme() {
    UApp.switchTheme();
    routCtrl.resetCurrentPage();
  }

  void changeLanguage() {
    UApp.updateLocale(isPersianLang ? const Locale("en") : const Locale("fa"));
    routCtrl.resetCurrentPage();
  }

  void navigateToSubscription() {
    UNavigator.push(SubscriptionPage(workspaceId: core.currentWorkspace.value.id));
  }
}
