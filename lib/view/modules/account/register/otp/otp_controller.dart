import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../data/data.dart';
import '../create_username_password/create_username_password_page.dart';

mixin OtpController {
  final RegisterDataSource _registerDataSource = Get.find<RegisterDataSource>();
  late String phoneNumber;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final Rx<PageState> resendState = PageState.loaded.obs;
  final StreamController<ErrorAnimationType> errorController = StreamController();
  final RxInt countdownSeconds = 120.obs;
  Timer? resendTimer;

  void disposeItems() {
    resendTimer?.cancel();
    errorController.close();
    countdownSeconds.close();
    otpController.dispose();
    errorController.close();
    buttonState.close();
    resendState.close();
  }

  void initialController(final String phoneNumber) {
    this.phoneNumber = phoneNumber;
    _startResendTimer();
  }

  void _startResendTimer() {
    resendTimer?.cancel();
    countdownSeconds.value = 120;
    resendTimer = Timer.periodic(const Duration(seconds: 1), (final timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _resetResendTimer() {
    resendTimer?.cancel();
    _startResendTimer();
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: verifyCode,
    );
  }

  void verifyCode() {
    buttonState.loading();
    _registerDataSource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      code: otpController.text,
      onResponse: (final response) async {
        buttonState.loaded();
        final String? accessToken = response.result?.jwtToken?.access;
        if (accessToken != null) {
          WidgetsBinding.instance.addPostFrameCallback((final _) {
            UNavigator.offAll(
              CreateUsernamePasswordPage(
                phoneNumber: response.result?.phoneNumber ?? phoneNumber,
                accessToken: accessToken,
              ),
            );
          });
        }
      },
      onError: (final errorResponse) {
        buttonState.loaded();
        errorController.add(ErrorAnimationType.shake);
      },
    );
  }

  void resendCode() {
    resendState.loading();
    _registerDataSource.sendCode(
      phoneNumber: phoneNumber,
      onResponse: (final response) {
        resendState.loaded();
        _resetResendTimer();
        AppNavigator.snackbarGreen(title: s.done, subtitle: response.message);
      },
      onError: (final errorResponse) {
        resendState.loaded();
      },
    );
  }

  void onBack() {
    appShowYesCancelDialog(
      description: s.areYouSureToChangePhoneNumber,
      onYesButtonTap: () {
        UNavigator.back();
        UNavigator.back();
      },
    );
  }
}
