import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../data/data.dart';
import '../hr_departments_list_controller.dart';

mixin DepartmentCreateUpdateController {
  HRDepartmentReadDto? department;
  final HumanResourceDatasource _hrFolderDatasource = Get.find<HumanResourceDatasource>();
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
    avatar = department?.avatar;
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
    _hrFolderDatasource.create(
      title: titleController.text.trim(),
      avatarId: avatar?.fileId,
      memberIdList: selectedMembers.map((final e) => e.id.toInt()).toList(),
      onResponse: (final response) {
        if (Get.isRegistered<HrDepartmentsListController>() && response.result != null) {
          Get.find<HrDepartmentsListController>().insertDepartment(response.result!);
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
    _hrFolderDatasource.update(
      slug: department?.slug,
      title: titleController.text.trim(),
      avatarId: avatar?.fileId,
      memberIdList: selectedMembers.map((final e) => e.id.toInt()).toList(),
      onResponse: (final response) {
        if (Get.isRegistered<HrDepartmentsListController>() && response.result != null) {
          Get.find<HrDepartmentsListController>().updateDepartment(response.result!);
        }

        buttonState.loaded();
        UNavigator.back();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }
}
