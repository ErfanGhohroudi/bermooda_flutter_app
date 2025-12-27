import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'crm_category_create_update_controller.dart';

class CrmCategoryCreateUpdatePage extends StatefulWidget {
  const CrmCategoryCreateUpdatePage({
    required this.onResponse,
    this.category,
    super.key,
  });

  final Function(CrmCategoryReadDto category) onResponse;
  final CrmCategoryReadDto? category;

  @override
  State<CrmCategoryCreateUpdatePage> createState() => _CrmCategoryCreateUpdatePageState();
}

class _CrmCategoryCreateUpdatePageState extends State<CrmCategoryCreateUpdatePage> with CrmCategoryCreateUpdateController {
  @override
  void initState() {
    category = widget.category;
    if (category != null) setValues();
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
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
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
              Flexible(
                child: Text(s.uploadPhoto).bodyMedium(color: context.theme.hintColor),
              ),
            ],
          ).marginOnly(bottom: 18),
          WTextField(
            controller: titleController,
            labelText: s.title,
            required: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WMembersPickerFormField(
            labelText: s.accessibleMembers,
            helperText: s.crmAccessibleMembersHelper,
            showSelf: true,
            required: true,
            selectedMembers: selectedMembers,
            filterByPermissionName: PermissionName.crm,
            onConfirm: (final list) {
              selectedMembers = list;
            },
          ),
          // WTextButton(
          //   text: s.settings,
          //   onPressed: () => AppNavigator.snackbarRed(title: s.warning, subtitle: s.availableOnAdvancedPlan, backgroundColor: Colors.grey.withAlpha(100)),
          // ),
          Obx(
                () => UElevatedButton(
              width: double.maxFinite,
              title: s.submit,
              isLoading: buttonState.isLoading(),
              onTap: () => onSubmit(
                onResponse: (final category) {
                  widget.onResponse(category);
                  UNavigator.back();
                },
              ),
            ),
          ).marginOnly(top: 100),
        ],
      ),
    ).container().onTap(() => FocusManager.instance.primaryFocus?.unfocus(),);
  }
}
