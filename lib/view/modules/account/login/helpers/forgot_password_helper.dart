import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../../../../data/data.dart';

class ForgotPasswordHelper {
  final LoginDataSource _loginDataSource = Get.find<LoginDataSource>();
  final RegisterDataSource _registerDataSource = Get.find<RegisterDataSource>();

  void showForgotPassDialog(final BuildContext context) {
    final phoneNumberCtrl = TextEditingController();
    final buttonState = PageState.loaded.obs;
    final formKey = GlobalKey<FormState>();
    showAppDialog<String>(
      barrierDismissible: false,
      onDismiss: () {
        phoneNumberCtrl.dispose();
      },
      AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.passwordRecovery).titleMedium(),
            const Divider(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: WPhoneNumberField(
                controller: phoneNumberCtrl,
                autofocus: true,
                required: true,
                showRequired: false,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              spacing: 10,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: () => UNavigator.back(),
                ).expanded(),
                Obx(
                  () => UElevatedButton(
                    title: s.recovery,
                    isLoading: buttonState.isLoading(),
                    onTap: () {
                      validateForm(
                        key: formKey,
                        action: () {
                          buttonState.loading();
                          _sendOtpForgetPassword(
                            phoneNumberCtrl.text,
                            onResponse: () {
                              final phoneNumber = phoneNumberCtrl.text;
                              buttonState.loaded();
                              Navigator.pop(context);
                              delay(10, () => _showOTPDialog(context, phoneNumber));
                            },
                            onError: () => buttonState.loaded(),
                          );
                        },
                      );
                    },
                  ).expanded(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOTPDialog(final BuildContext context, final String phoneNumber) {
    final otpController = TextEditingController();
    final buttonState = PageState.loaded.obs;
    final resendState = PageState.loaded.obs;
    final formKey = GlobalKey<FormState>();
    final StreamController<ErrorAnimationType> errorController = StreamController();
    final countdownSeconds = 120.obs;
    Timer? resendTimer;

    void startResendTimer() {
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

    void resetResendTimer() {
      resendTimer?.cancel();
      startResendTimer();
    }

    // Start timer automatically when dialog is shown
    startResendTimer();

    showAppDialog<String>(
      barrierDismissible: false,
      onDismiss: () {
        delay(500, () {
          resendTimer?.cancel();
          errorController.close();
          countdownSeconds.close();
        });
      },
      AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.passwordRecovery).titleMedium(),
            const Divider(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.otpInfoText.replaceAll('#', phoneNumber),
              textAlign: TextAlign.center,
            ).titleMedium(),
            const SizedBox(height: 18),
            Form(
              key: formKey,
              child: UOtpField(
                controller: otpController,
                autoFocus: true,
                errorAnimationController: errorController,
                fieldWidth: 35,
                fieldHeight: 35,
                length: 6,
                fillColor: Colors.transparent,
                activeColor: context.theme.primaryColor,
                borderColor: context.theme.hintColor,
                cursorColor: context.theme.primaryColor,
                hintCharacter: '*',
                textStyle: context.textTheme.bodyLarge,
                hintStyle: context.textTheme.bodyLarge!.copyWith(color: context.theme.hintColor),
                errorTextDirection: isPersianLang ? TextDirection.rtl : TextDirection.ltr,
                validator: validateMinLength(
                  6,
                  requiredMessage: s.requiredField,
                  minLengthMessage: s.isShort.replaceAll('#', '6'),
                ),
                onCompleted: (final code) {
                  buttonState.loading();
                  _verifyOtp(context, phoneNumber, otpController.text, buttonState, errorController);
                },
              ),
            ),

            /// Resend OTP Code
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text(s.otpCodeNotReceived).bodyMedium(),
                Obx(
                  () {
                    final isTimerActive = countdownSeconds.value > 0;
                    final isResendEnabled = resendState.isLoaded() && !isTimerActive;

                    if (!isResendEnabled && resendState.isLoading()) {
                      return const WCircularLoading(size: 15, strokeWidth: 2);
                    }

                    if (isTimerActive) {
                      // Show disabled state with countdown
                      return Text(
                        '${s.resend} (${countdownSeconds.value} ${s.seconds})',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.theme.hintColor,
                          decoration: TextDecoration.underline,
                          decorationColor: context.theme.hintColor,
                        ),
                      );
                    }

                    return WTextButton2(
                      text: s.resend,
                      onPressed: () {
                        resendState.loading();
                        _sendOtpForgetPassword(
                          phoneNumber,
                          onResponse: () {
                            resendState.loaded();
                            resetResendTimer();
                          },
                          onError: () => resendState.loaded(),
                        );
                      },
                    );
                  },
                ),
              ],
            ).marginOnly(bottom: 24),
            Row(
              spacing: 10,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: () => UNavigator.back(),
                ).expanded(),
                Obx(
                  () => UElevatedButton(
                    title: s.next,
                    isLoading: buttonState.isLoading(),
                    onTap: () {
                      validateForm(
                        key: formKey,
                        action: () {
                          buttonState.loading();
                          _verifyOtp(context, phoneNumber, otpController.text, buttonState, errorController);
                        },
                      );
                    },
                  ).expanded(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendOtpForgetPassword(
    final String phoneNumber, {
    required final VoidCallback onResponse,
    required final VoidCallback onError,
  }) {
    _loginDataSource.sendOtpForgetPassword(
      phoneNumber: phoneNumber,
      onResponse: onResponse,
      onError: (final errorResponse) => onError(),
      withRetry: true,
    );
  }

  void _verifyOtp(
    final BuildContext context,
    final String phoneNumber,
    final String code,
    final Rx<PageState> buttonState,
    final StreamController<ErrorAnimationType> errorController,
  ) {
    _registerDataSource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      code: code,
      onResponse: (final response) async {
        final String? refreshToken = response.result?.jwtToken?.refresh;
        final String? accessToken = response.result?.jwtToken?.access;

        /// save refresh token (this token use for refresh access token)
        if (refreshToken != null) {
          await SecureStorageService.saveRefreshToken(refreshToken);
        }

        /// save access token
        if (accessToken != null) {
          await SecureStorageService.saveAccessToken(accessToken);
        }
        buttonState.loaded();
        Navigator.pop(context);
        delay(10, () => _showChangePassDialog(context));
      },
      onError: (final GenericResponse<dynamic> errorResponse) {
        buttonState.loaded();
        errorController.add(ErrorAnimationType.shake);
      },
    );
  }

  void _showChangePassDialog(final BuildContext context) {
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    final buttonState = PageState.loaded.obs;
    final formKey = GlobalKey<FormState>();

    showAppDialog<String>(
      barrierDismissible: false,
      onDismiss: () {
        newPassController.dispose();
        confirmPassController.dispose();
      },
      AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.passwordRecovery).titleMedium(),
            const Divider(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 18,
                children: [
                  WPasswordField(
                    controller: newPassController,
                    labelText: s.newPassword,
                    required: true,
                    showRequired: false,
                  ),
                  WPasswordField(
                    controller: confirmPassController,
                    labelText: s.confirmNewPassword,
                    confirmController: newPassController,
                    required: true,
                    showRequired: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              spacing: 10,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: () => UNavigator.back(),
                ).expanded(),
                Obx(
                  () => UElevatedButton(
                    title: s.next,
                    isLoading: buttonState.isLoading(),
                    onTap: () {
                      validateForm(
                        key: formKey,
                        action: () {
                          buttonState.loading();
                          _changePass(
                            newPassController.text,
                            confirmPassController.text,
                            onResponse: () {
                              buttonState.loaded();
                              Navigator.pop(context);
                              AppNavigator.snackbarGreen(title: s.done, subtitle: s.passwordChanged);
                            },
                            onError: () => buttonState.loaded(),
                          );
                        },
                      );
                    },
                  ).expanded(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changePass(
    final String newPassword,
    final String confirmNewPassword, {
    required final VoidCallback onResponse,
    required final VoidCallback onError,
  }) {
    _loginDataSource.changePassword(
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
      onResponse: onResponse,
      onError: (final errorResponse) => onError(),
    );
  }
}
