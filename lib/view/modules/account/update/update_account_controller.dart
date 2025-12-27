import 'package:u/utilities.dart';

import '../../../../core/widgets/image_files.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';

mixin UpdateAccountController {
  final core = Get.find<Core>();
  final UserDatasource _datasource = Get.find<UserDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final TextEditingController fullNameController = TextEditingController(text: Get.find<Core>().userReadDto.value.fullName);
  final TextEditingController phoneNumberController = TextEditingController(text: Get.find<Core>().userReadDto.value.phoneNumber);
  MainFileReadDto? avatar;
  bool isUploadingFile = false;

  void disposeItems() {
    buttonState.close();
    fullNameController.dispose();
    phoneNumberController.dispose();
  }

  void initialController() {
    avatar = core.userReadDto.value.avatar;
  }

  void callApi() {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            buttonState.loading();
            _update();
          },
        );
      },
    );
  }

  void _update() {
    _datasource.changeFullNameAndAvatar(
      avatarId: avatar?.fileId,
      fullName: fullNameController.text.trim(),
      onResponse: () {
        core.updateUser(
          core.userReadDto.value.copyWith(
            fullName: fullNameController.text.trim(),
            avatarUrl: avatar?.url,
            avatar: avatar,
          ),
        );
        UNavigator.back();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }
}
