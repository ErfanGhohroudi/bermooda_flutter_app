import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/core.dart';
import '../../../../../core/functions/init_app_functions.dart';
import '../../../../../core/functions/user_functions.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../../../../data/data.dart';

mixin CreateUsernamePasswordController {
  late String phoneNumber;
  late String accessToken;

  final RegisterDataSource _registerDataSource = Get.find<RegisterDataSource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isUploadingAvatar = false;
  int? avatarId;

  final TapGestureRecognizer termsRecognizer = TapGestureRecognizer()
    ..onTap = () {
      ULaunch.launchURL(AppConstants.termsAndConditionsUrl, mode: LaunchMode.inAppBrowserView);
    };

  void onSubmit() {
    validateForm(
      key: formKey,
      action: setInformation,
    );
  }

  void setInformation() {
    WImageFiles.checkFileUploading(
      isUploadingFile: isUploadingAvatar,
      action: () {
        buttonState.loading();
        _registerDataSource.createUsernamePasswords(
          accessToken: accessToken,
          fullName: "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          avatarId: avatarId,
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
              username: phoneNumber,
              password: passwordController.text,
            );

            /// Set isLogin
            ULocalStorage.set(AppConstants.isLogin, true);

            /// Add FCM token and get initials data of the App
            addFcmToken(
              action: () => initApp(withConnectWS: false),
            );
          },
          onError: (final errorResponse) {
            buttonState.loaded();
          },
        );
      },
    );
  }
}
