import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../core/core.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import 'department_create_update_controller.dart';

class DepartmentCreateUpdatePage extends StatefulWidget {
  const DepartmentCreateUpdatePage({
    this.department,
    super.key,
  });

  final HRDepartmentReadDto? department;

  @override
  State<DepartmentCreateUpdatePage> createState() => _DepartmentCreateUpdatePageState();
}

class _DepartmentCreateUpdatePageState extends State<DepartmentCreateUpdatePage> with DepartmentCreateUpdateController {
  @override
  void initState() {
    department = widget.department;
    setValues();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
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
            helperText: s.humanResourcesAccessibleMembersHelper,
            filterByPermissionName: PermissionName.humanResources,
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
