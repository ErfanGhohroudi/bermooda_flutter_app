import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../data/data.dart';
import '../legal_department_list_controller.dart';

mixin LegalDepartmentCreateUpdateController {
  LegalDepartmentReadDto? department;
  final LegalDatasource _datasource = Get.find<LegalDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  bool isUploadingFile = false;

  MainFileReadDto? avatar;
  final TextEditingController titleController = TextEditingController();
  List<UserReadDto> selectedMembers = [];

  bool get isCreating => department == null;

  void disposeItems() {
    buttonState.close();
    titleController.dispose();
  }

  void setValues() {
    avatar = (department?.avatarUrl ?? '').trim().isNotEmpty ? MainFileReadDto(url: department?.avatarUrl) : null;
    titleController.text = department?.title ?? '';
    selectedMembers = department?.members ?? [];
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            if (isCreating) {
              create();
            } else {
              update();
            }
          },
        );
      },
    );
  }

  void create() {
    buttonState.loading();
    _datasource.create(
      title: titleController.text.trim(),
      avatarId: avatar?.fileId,
      memberIdList: selectedMembers.map((final e) => e.id.toInt()).toList(),
      onResponse: (final response) {
        if (Get.isRegistered<LegalDepartmentListController>() && response.result != null) {
          Get.find<LegalDepartmentListController>().insertDepartment(response.result!);
        }
        buttonState.loaded();
        UNavigator.back();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }

  void update() {
    buttonState.loading();
    _datasource.update(
      id: department?.id,
      title: titleController.text.trim(),
      avatar: avatar,
      memberIdList: selectedMembers.map((final e) => e.id.toInt()).toList(),
      onResponse: (final response) {
        if (Get.isRegistered<LegalDepartmentListController>() && response.result != null) {
          Get.find<LegalDepartmentListController>().updateDepartment(response.result!);
        }

        buttonState.loaded();
        UNavigator.back();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }
}
