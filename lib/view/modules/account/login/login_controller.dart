import 'package:u/utilities.dart';

import '../../../../core/constants.dart';
import '../../../../core/core.dart';
import '../../../../core/functions/init_app_functions.dart';
import '../../../../core/functions/user_functions.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../data/data.dart';
import 'helpers/forgot_password_helper.dart';

mixin LoginController {
  final LoginDataSource _dataSource = Get.find<LoginDataSource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final TextEditingController usernameController = TextEditingController(text: ULocalStorage.getString(AppConstants.username));
  final TextEditingController passwordController = TextEditingController();

  void onSubmit() {
    validateForm(
      key: formKey,
      action: _login,
    );
  }

  void onForgotPassword(final BuildContext context) {
    ForgotPasswordHelper().showForgotPassDialog(context);
  }

  void _login() {
    buttonState.loading();
    _dataSource.login(
      dto: LoginParams(
        username: usernameController.text,
        password: passwordController.text,
      ),
      onResponse: (final response) async {
        final String? refreshToken = response.result?.jwtToken?.refresh;
        final String? accessToken = response.result?.jwtToken?.access;
        final String? chatWebsocketToken = response.result?.webSocketToken;

        /// save refresh token (this token use for refresh access token)
        if (refreshToken != null) {
          await SecureStorageService.saveRefreshToken(refreshToken);
        }

        /// save access token
        if (accessToken != null) {
          await SecureStorageService.saveAccessToken(accessToken);
        }

        /// save chat websocket token
        if (chatWebsocketToken != null) {
          await SecureStorageService.saveChatWebsocketToken(chatWebsocketToken);
        }

        /// save list of workspaces in [Core]
        Get.find<Core>().updateWorkspaces(response.result?.workspaces);

        /// save username & password
        saveUsernameAndPassword(
          username: usernameController.text,
          password: passwordController.text,
        );

        /// Set isLogin
        ULocalStorage.set(AppConstants.isLogin, true);

        /// Add FCM token and get initials data of the App
        addFcmToken(
          action: () => initApp(withConnectWS: true),
        );
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
    );
  }
}
