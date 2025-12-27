import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import 'otp_controller.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    required this.phoneNumber,
    super.key,
  });

  final String phoneNumber;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with OtpController {
  @override
  void initState() {
    initialController(widget.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final _) {
        if (didPop) return;
        onBack();
      },
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Back Icon
            Row(
              children: [
                WBackIcon(
                  action: onBack,
                ),
              ],
            ).marginOnly(bottom: 30),

            /// Info
            Text(
              s.otpInfoText.replaceAll('#', phoneNumber),
              textAlign: TextAlign.center,
            ).titleMedium().marginOnly(bottom: 50),

            /// OTP Field
            UOtpField(
              controller: otpController,
              errorAnimationController: errorController,
              fieldWidth: 50,
              fieldHeight: 50,
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
                onSubmit();
              },
            ).marginOnly(bottom: 50),

            /// Resend Code
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(s.otpCodeNotReceived).bodyMedium(),
                const SizedBox(width: 10),
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
                      onPressed: resendCode,
                    );
                  },
                ),
              ],
            ).marginOnly(bottom: 50),

            /// Submit Button
            Obx(
              () => UElevatedButton(
                title: s.confirm,
                width: context.width,
                isLoading: buttonState.isLoading(),
                onTap: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
