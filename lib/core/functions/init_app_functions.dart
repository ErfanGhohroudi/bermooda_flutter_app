import 'package:u/utilities.dart';

import '../services/websocket_service.dart';
import '../../view/modules/rout/rout_page.dart';
import '../../view/modules/workspace/create/create_workspace_page.dart';
import '../core.dart';
import 'banner_function.dart';
import 'user_functions.dart';
import 'workspace_functions.dart';

void initApp({
  final bool currentWorkspaceChanged = false,

  /// Just provide true after login, signup completed and splash if user is login
  final bool withConnectWS = false,
}) {
  getBanners();
  getMyUser(
    withLoading: currentWorkspaceChanged,
    action: () {
      getWorkspaces(
        withLoading: currentWorkspaceChanged,
        action: () async {
          if (withConnectWS) {
            WebSocketService().startLifecycleListener();
            WebSocketService().connect();
          }
          if (Get.find<Core>().workspaces.isEmpty) {
            showCreateWorkspaceDialog(barrierDismissible: false, barrierColor: navigatorKey.currentContext!.theme.scaffoldBackgroundColor);
          } else {
            if (currentWorkspaceChanged) return;
            WidgetsBinding.instance.addPostFrameCallback((final _) {
              UNavigator.offAll(const RoutPage(), milliSecondDelay: 0);
            });
          }
        },
      );
    },
  );
}
