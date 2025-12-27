import 'package:u/utilities.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../data/data.dart';

mixin ChangePasswordController {
  final GlobalKey<FormState> formKey = GlobalKey();
  final UserDatasource _datasource = Get.find<UserDatasource>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void disposeItems() {
    buttonState.close();
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
  }

  void callApi() {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        _changePassword();
      },
    );
  }

  void _changePassword() {
    _datasource.changeCurrentPassword(
      currentPassword: currentPassController.text,
      newPassword: newPassController.text,
      confirmNewPassword: confirmPassController.text,
      onResponse: () async {
        await SecureStorageService.savePassword(confirmPassController.text);
        UNavigator.back();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }
}
