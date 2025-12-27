import 'package:u/utilities.dart';

import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import 'signup_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SignupController {
  @override
  void dispose() {
    buttonState.close();
    phoneNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      color: context.theme.cardColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: context.theme.cardColor,
        title: Text(s.createAccount).bodyLarge(color: context.theme.primaryColorDark),
        iconTheme: IconThemeData(
          color: context.theme.primaryColorDark,
        ),
      ),
      bottomNavigationBar: Obx(
        () => UElevatedButton(
          width: double.infinity,
          title: s.sendCode,
          isLoading: buttonState.isLoading(),
          onTap: onSubmit,
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
                  controller: phoneNumberCtrl,
                  required: true,
                  showRequired: false,
                ).marginOnly(bottom: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
