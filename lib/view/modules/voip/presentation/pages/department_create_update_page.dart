import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/image_files.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../domain/entity/voip_department.dart';
import '../controllers/department_list_controller.dart';

class VoipDepartmentCreateUpdatePage extends StatefulWidget {
  const VoipDepartmentCreateUpdatePage({
    required this.ctrl,
    this.department,
    super.key,
  });

  final VoipDepartment? department;
  final VoipDepartmentListController ctrl;

  @override
  State<VoipDepartmentCreateUpdatePage> createState() => _VoipDepartmentCreateUpdatePageState();
}

class _VoipDepartmentCreateUpdatePageState extends State<VoipDepartmentCreateUpdatePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  bool isUploadingFile = false;

  MainFileReadDto? avatar;
  final TextEditingController titleController = TextEditingController();
  List<UserReadDto> selectedMembers = [];

  bool get isCreating => widget.department == null;

  VoipDepartmentListController get ctrl => widget.ctrl;

  @override
  void initState() {
    avatar = widget.department?.avatar;
    titleController.text = widget.department?.title ?? '';
    selectedMembers = widget.department?.members ?? [];
    super.initState();
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () async {
            if (isCreating) {
              buttonState.loading();
              final result = await ctrl.createDepartment(
                title: titleController.text.trim(),
                members: selectedMembers,
                avatar: avatar,
              );
              buttonState.loaded();
              if (result != null) AppNavigator.back();
            } else {
              buttonState.loading();
              final result = await ctrl.updateDepartment(
                id: widget.department!.id,
                title: titleController.text.trim(),
                members: selectedMembers,
                avatar: avatar,
              );
              buttonState.loaded();
              if (result != null) AppNavigator.back();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    buttonState.close();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 18,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WProfileUploadAndShowImage(
                file: avatar,
                onUploaded: (final file) => avatar = file,
                onRemove: (final file) => avatar = null,
                uploadStatus: (final value) => isUploadingFile = value,
              ).marginOnly(bottom: 10),
              Text(s.uploadPhoto).bodyMedium(color: context.theme.hintColor),
            ],
          ),
          WTextField(
            controller: titleController,
            labelText: s.title,
            required: true,
            showRequired: false,
          ),
          WMembersPickerFormField(
            labelText: s.accessibleMembers,
            helperText: s.accessibleMembersHelper(s.department.toLowerCase()),
            filterByPermissionName: PermissionName.voip,
            showSelf: true,
            selectedMembers: selectedMembers,
            onConfirm: (final list) {
              selectedMembers = list;
            },
          ),
          Obx(
            () => UElevatedButton(
              title: isCreating ? s.confirm : s.save,
              width: context.width,
              isLoading: buttonState.isLoading(),
              onTap: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
