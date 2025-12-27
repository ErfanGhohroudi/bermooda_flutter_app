import 'package:u/utilities.dart';

import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import 'create_username_password_controller.dart';

class CreateUsernamePasswordPage extends StatefulWidget {
  const CreateUsernamePasswordPage({
    required this.phoneNumber,
    required this.accessToken,
    super.key,
  });

  final String phoneNumber;
  final String accessToken;

  @override
  State<CreateUsernamePasswordPage> createState() => _CreateUsernamePasswordPageState();
}

class _CreateUsernamePasswordPageState extends State<CreateUsernamePasswordPage> with CreateUsernamePasswordController {
  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    accessToken = widget.accessToken;
    super.initState();
  }

  @override
  void dispose() {
    termsRecognizer.dispose();
    buttonState.close();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(s.account),
        centerTitle: true,
      ),
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: isPersianLang ? context.textTheme.bodyMedium : context.textTheme.bodySmall,
                children: [
                  TextSpan(text: isPersianLang ? 'با ایجاد حساب کاربری، با ' : 'By creating an account, I agree to the '),
                  TextSpan(
                    text: isPersianLang ? 'شرایط و قوانین' : 'terms and conditions',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: AppColors.blueLink,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blueLink,
                    ),
                    recognizer: termsRecognizer,
                  ),
                  TextSpan(text: isPersianLang ? ' موافقت می‌کنم.' : '.'),
                ],
              ),
            ).marginOnly(bottom: 10),
            UElevatedButton(
              title: s.createAccount,
              width: context.width,
              isLoading: buttonState.isLoading(),
              onTap: onSubmit,
            ),
          ],
        ),
      ).pOnly(left: 16, right: 16, bottom: 24),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                Column(
                  children: [
                    WProfileUploadAndShowImage(
                      isSignUpAvatar: true,
                      onUploaded: (final file) {
                        avatarId = file.fileId;
                      },
                      onRemove: (final file) {
                        avatarId = null;
                      },
                      uploadStatus: (final value) {
                        isUploadingAvatar = value;
                      },
                    ).marginOnly(bottom: 10),
                    Text(s.accountPhoto).bodyMedium(fontSize: 14),
                  ],
                ).marginOnly(bottom: 30),
                WTextField(
                  controller: firstNameController,
                  labelText: s.firstName,
                  required: true,
                  showRequired: false,
                ),
                WTextField(
                  controller: lastNameController,
                  labelText: s.lastName,
                  required: true,
                  showRequired: false,
                ),
                WPasswordField(
                  controller: passwordController,
                  required: true,
                  showRequired: false,
                ),
                WPasswordField(
                  controller: confirmPasswordController,
                  labelText: s.confirmPassword,
                  required: true,
                  showRequired: false,
                  confirmController: passwordController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
