import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../services/websocket_service.dart';
import '../../view/modules/splash/splash_page.dart';
import '../widgets/widgets.dart';
import '../constants.dart';
import '../core.dart';
import '../services/secure_storage_service.dart';

/// Fetch my user data & save datas in [Core]
void getMyUser({
  required final VoidCallback action,
  final bool withLoading = false,
}) {
  Get.find<UserDatasource>().getUserData(
    onResponse: (final response) {
      final core = Get.find<Core>();

      core.updateUser(response.result);
      core.updateCurrentWorkspace(response.result?.currentWorkspace);
      core.unreadNotificationsCount(response.result?.currentWorkspace?.unreadNotifications);

      action();
    },
    onError: (final errorResponse) {},
    withRetry: true,
    withLoading: withLoading,
  );
}

/// Save username & password in storage
void saveUsernameAndPassword({
  required final String username,
  required final String password,
}) {
  ULocalStorage.set(AppConstants.username, username);
  SecureStorageService.savePassword(password);
}

/// Logout with show dialog and go to login page
void logoutWithShowDialog() {
  appShowYesCancelDialog(
    title: s.warning,
    description: s.areYouSureYouWantToLogOut,
    onYesButtonTap: () {
      UNavigator.back();
      logout();
    },
  );
}

/// Logout and go to login page
Future<void> logout() async {
  await SecureStorageService.deleteRefreshToken();
  await SecureStorageService.deleteAccessToken();
  await SecureStorageService.deleteChatWebsocketToken();
  WebSocketService().stopLifecycleListener();
  WebSocketService().disconnect();
  ULocalStorage.set(AppConstants.isLogin, false);
  Get.find<Core>().clearWorkspaces();
  UNavigator.offAll(const SplashPage());
}

/// Add FCM token
void addFcmToken({
  required final VoidCallback action,
}) async {
  try {
    // Try to get FCM token with retry logic
    final tokenRetrieved = await UFirebase.getFcmToken();

    // Only proceed if token was successfully retrieved
    if (!tokenRetrieved) {
      ULocalStorage.set(AppConstants.hasNotSetFcmToken, true);
      if (kDebugMode) {
        print("FCM token not available. Cannot add FCM token to server.");
      }
      action();
      return;
    }

    // Verify token is set before calling datasource
    try {
      // Access token to verify it's initialized (will throw if not)
      final fcmToken = UCore.fcmToken;

      Get.find<AddFcmDatasource>().addFcmToken(
        fcmToken: fcmToken,
        onResponse: () {
          ULocalStorage.set(AppConstants.hasNotSetFcmToken, false);
          action();
        },
        onError: (final GenericResponse<dynamic> errorResponse) {
          ULocalStorage.set(AppConstants.hasNotSetFcmToken, true);
          if (kDebugMode) {
            print("Error adding FCM token to server: ${errorResponse.message}");
          }
        },
        withRetry: true,
      );
    } catch (e) {
      // Token not initialized, call onError
      ULocalStorage.set(AppConstants.hasNotSetFcmToken, true);
      if (kDebugMode) {
        print("FCM token not initialized: $e");
      }
      action();
    }
  } catch (e) {
    ULocalStorage.set(AppConstants.hasNotSetFcmToken, true);
    if (kDebugMode) {
      print("Exception in addFcmToken: $e");
    }
    action();
  }
}
