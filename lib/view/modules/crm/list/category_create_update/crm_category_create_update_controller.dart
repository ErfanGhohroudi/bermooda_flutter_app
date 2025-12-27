import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../data/data.dart';

mixin CrmCategoryCreateUpdateController {
  CrmCategoryReadDto? category;
  final GlobalKey<FormState> formKey = GlobalKey();
  final CrmDatasource _crmDatasource = Get.find<CrmDatasource>();
  final Rx<PageState> buttonState = PageState.loaded.obs;

  MainFileReadDto? avatar;
  final TextEditingController titleController = TextEditingController();
  bool isUploadingFile = false;
  List<UserReadDto> selectedMembers = [];

  void disposeItems() {
    buttonState.close();
    titleController.dispose();
  }

  void setValues() {
    avatar = category?.avatar?.fileId != null ? category?.avatar : null;
    titleController.text = category?.title ?? '';
    selectedMembers.assignAll(category?.members ?? selectedMembers);
  }

  void onSubmit({required final Function(CrmCategoryReadDto category) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            buttonState.loading();
            if (category == null) {
              create(onResponse);
            } else {
              update(onResponse);
            }
          },
        );
      },
    );
  }

  void create(final Function(CrmCategoryReadDto category) onResponse) {
    _crmDatasource.create(
      avatarId: avatar?.fileId,
      title: titleController.text,
      users: selectedMembers,
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
        buttonState.loaded();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void update(final Function(CrmCategoryReadDto category) onResponse) {
    _crmDatasource.update(
      id: category?.id,
      avatarId: avatar?.fileId,
      title: titleController.text,
      users: selectedMembers,
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
        buttonState.loaded();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }
}
