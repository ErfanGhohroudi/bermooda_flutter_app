import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/core.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme.dart';
import '../register/signup/signup_page.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginController {
  @override
  void initState() {
    _initializePasswordController();
    super.initState();
  }

  Future<void> _initializePasswordController() async {
    final password = await SecureStorageService.getPassword();
    if (mounted) {
      setState(() {
        passwordController.text = password ?? '';
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    buttonState.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      color: context.theme.cardColor,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(s.doNotHaveAnAccount).bodyMedium(),
                const SizedBox(width: 10),
                WTextButton2(
                  text: s.signup,
                  onPressed: () {
                    UNavigator.push(const SignupPage());
                  },
                ),
              ],
            ).marginOnly(bottom: 10),
            UElevatedButton(
              title: s.login,
              width: context.width,
              isLoading: buttonState.isLoading(),
              onTap: onSubmit,
            ),
          ],
        ).marginSymmetric(horizontal: 24).marginOnly(bottom: 24),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const UImage(AppImages.logo, size: 90).marginOnly(bottom: 18),
                Text(s.welcome).titleMedium(fontSize: 22).marginOnly(bottom: 100),
                WPhoneNumberField(
                  controller: usernameController,
                  required: true,
                  showRequired: false,
                ).marginOnly(bottom: 24),
                WPasswordField(
                  controller: passwordController,
                  required: true,
                  showRequired: false,
                ),
                Row(
                  children: [
                    WTextButton(
                      text: s.forgotPassword,
                      onPressed: () => onForgotPassword(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
