import 'package:u/utilities.dart';

import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/core.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> with ChangePasswordController {
  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            WPasswordField(
              controller: currentPassController,
              labelText: s.currentPassword,
              required: true,
              showRequired: false,
            ),
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
            Row(
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: UNavigator.back,
                ).expanded(),
                const SizedBox(width: 10),
                Obx(
                  () => UElevatedButton(
                    title: s.save,
                    isLoading: buttonState.isLoading(),
                    onTap: callApi,
                  ),
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
