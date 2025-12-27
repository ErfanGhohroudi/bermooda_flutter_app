import 'package:u/utilities.dart';

import '../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../../create_update/entity/project_settings_entity.dart';
import 'project_create_update_controller.dart';

class ProjectCreateUpdatePage extends StatefulWidget {
  const ProjectCreateUpdatePage({
    required this.onResponse,
    this.project,
    super.key,
  });

  final Function(ProjectReadDto project) onResponse;
  final ProjectReadDto? project;

  @override
  State<ProjectCreateUpdatePage> createState() => _ProjectCreateUpdatePageState();
}

class _ProjectCreateUpdatePageState extends State<ProjectCreateUpdatePage> with ProjectCreateUpdateController {
  @override
  void initState() {
    project = widget.project;
    if (project != null) setValues();
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
            helperText: s.projectAccessibleMembersHelper,
            showSelf: true,
            selectedMembers: selectedMembers,
            filterByPermissionName: PermissionName.project,
            onConfirm: (final list) {
              selectedMembers = list;
            },
          ),
          FormField<ProjectSettingsEntity>(
            builder: (final formFieldState) => InkWell(
              onTap: () async {
                final result = await _showSettingsBottomSheet();
                if (result == null) return;
                settingsParameters = result;
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: s.settings,
                  labelStyle: context.textTheme.bodyMedium!.copyWith(
                    fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
                  ),
                  floatingLabelStyle: context.textTheme.bodyLarge!,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  errorText: formFieldState.errorText,
                  prefixIcon: SizedBox(width: 30, child: Center(child: UImage(AppIcons.settingsOutline, color: context.theme.primaryColorDark, size: 25))),
                  suffixIcon: Icon(Icons.arrow_forward_ios_rounded, color: context.theme.hintColor, size: 20),
                ),
                isEmpty: true,
              ),
            ),
          ),
          Obx(
            () => UElevatedButton(
              width: double.maxFinite,
              title: s.submit,
              isLoading: buttonState.isLoading(),
              onTap: () => onSubmit(
                onResponse: (final project) {
                  widget.onResponse(project);
                  UNavigator.back();
                },
              ),
            ),
          ).marginOnly(top: 100),
        ],
      ),
    ).container().onTap(
          () => FocusManager.instance.primaryFocus?.unfocus(),
        );
  }

  Future<ProjectSettingsEntity?> _showSettingsBottomSheet() {
    String? startDate = settingsParameters.startDate;
    String? dueDate = settingsParameters.dueDate;
    final TextEditingController budgetCtrl = TextEditingController(text: settingsParameters.budget);
    // CurrencyUnitReadDto? currency = settingsParameters.currency;

    return bottomSheet<ProjectSettingsEntity>(
      title: s.settings,
      childBuilder: (final context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            WDatePickerField(
              initialValue: startDate,
              labelText: s.startDate,
              showYearSelector: true,
              onConfirm: (final date, final compactFormatterDate) {
                startDate = compactFormatterDate;
              },
            ),
            WDatePickerField(
              initialValue: dueDate,
              labelText: s.dueDate,
              showYearSelector: true,
              onConfirm: (final date, final compactFormatterDate) {
                dueDate = compactFormatterDate;
              },
            ),
            WAmountCurrencyField(
              controller: budgetCtrl,
              labelText: s.budget,
              // initialCurrency: currency,
              // onChangedCurrency: (final result) => currency = result,
            ),
            UElevatedButton(
              width: context.width,
              title: s.save,
              onTap: () {
                final model = ProjectSettingsEntity(
                  startDate: startDate,
                  dueDate: dueDate,
                  budget: budgetCtrl.text.isNotEmpty && budgetCtrl.text != '0' ? budgetCtrl.text : null,
                  // currency: budgetCtrl.text.isNotEmpty && budgetCtrl.text != '0' ? currency : null,
                );

                budgetCtrl.dispose();
                Navigator.of(context).pop(model);
              },
            ).marginOnly(top: 24),
          ],
        );
      },
    );
  }
}
