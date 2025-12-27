import 'package:u/utilities.dart';

import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../core/core.dart';
import 'update_account_controller.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({
    super.key,
  });

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> with UpdateAccountController {
  @override
  void initState() {
    initialController();
    super.initState();
  }

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
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                WProfileUploadAndShowImage(
                  file: avatar,
                  onUploaded: (final file) {
                    avatar = file;
                  },
                  onRemove: (final file) {
                    avatar = null;
                  },
                  uploadStatus: (final value) {
                    isUploadingFile = value;
                  },
                ),
                Text(s.uploadPhoto).bodyMedium(color: context.theme.hintColor),
              ],
            ),
            WTextField(
              controller: fullNameController,
              labelText: s.fullName,
              required: true,
              showRequired: false,
            ),
            WPhoneNumberField(
              enabled: false,
              controller: phoneNumberController,
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
                    onTap: () {
                      callApi();
                    },
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
