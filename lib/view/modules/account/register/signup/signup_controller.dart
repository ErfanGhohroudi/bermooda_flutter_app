import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../otp/otp_page.dart';

mixin SignupController {
  final RegisterDataSource _registerDataSource = Get.find<RegisterDataSource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final TextEditingController phoneNumberCtrl = TextEditingController();

  void onSubmit() {
    validateForm(
      key: formKey,
      action: signup,
    );
  }

  void signup() {
    buttonState.loading();
    _registerDataSource.sendCode(
      phoneNumber: phoneNumberCtrl.text,
      onResponse: (final response) {
        buttonState.loaded();
        bottomSheet(
          isDismissible: false,
          enableDrag: false,
          child: OtpPage(phoneNumber: phoneNumberCtrl.text),
        );
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
    );
  }
}
