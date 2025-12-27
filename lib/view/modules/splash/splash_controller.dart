import 'package:u/utilities.dart';

import '../../../core/constants.dart';
import '../../../core/functions/init_app_functions.dart';
import '../../../core/functions/update_app_function.dart';
import '../../../core/services/secure_storage_service.dart';
import '../account/login/login_page.dart';
import '../conversation/presentation/pages/conversations/conversations_list_controller.dart';

mixin SplashController {
  Future<bool> isLogin() async {
    final String? token = await SecureStorageService.getAccessToken();
    final bool isLogin = ULocalStorage.getBool(AppConstants.isLogin) ?? false;
    return token != null && isLogin;
  }

  Future<void> init() async {
    if (!Get.isRegistered<ConversationsListController>()) {
      Get.put(ConversationsListController(), permanent: true);
    }

    checkAppUpdate(
      action: () async {
        if (await isLogin()) {
          initApp(withConnectWS: true);
        } else {
          delay(
            2000,
            () => UNavigator.offAll(const LoginPage()),
          );
        }
      },
    );
  }
}
