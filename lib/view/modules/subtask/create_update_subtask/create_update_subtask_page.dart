import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/labels_dropdown/labels_dropdown_multi_select.dart';
import '../../../../core/widgets/image_files.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/widgets/links.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'create_update_subtask_controller.dart';

class CreateUpdateSubtaskPage extends StatefulWidget {
  const CreateUpdateSubtaskPage({
    required this.dataSourceType,
    required this.mainSourceId,
    required this.onResponse,
    this.model,
    this.sourceId,
    super.key,
  }) : assert(model == null || sourceId != null, 'When model is provided, sourceId must not be null');

  final SubtaskDataSourceType dataSourceType;

  /// projectId or legalDepartmentId
  final String mainSourceId;

  /// required for update
  final SubtaskReadDto? model;

  /// taskId or legalCaseId required for create
  final int? sourceId;

  final Function(SubtaskReadDto model) onResponse;

  @override
  State<CreateUpdateSubtaskPage> createState() => _CreateUpdateSubtaskPageState();
}

class _CreateUpdateSubtaskPageState extends State<CreateUpdateSubtaskPage> with CreateUpdateSubtaskController {
  @override
  void initState() {
    initialController(
      dataSourceType: widget.dataSourceType,
      sourceId: widget.sourceId,
      mainSourceId: widget.mainSourceId,
      subtask: widget.model,
    );
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _body(),
        const SizedBox(height: 24),
        _actionButton(),
      ],
    );
  }

  Widget _body() => Form(
    key: formKey,
    child: Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: titleController,
            labelText: s.title,
            required: true,
            multiLine: true,
            maxLines: 5,
            maxLength: 2000,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          // مسئول انجام
          WDropDownFormField<String>(
            labelText: membersState.isLoaded() ? s.assignee : s.loading,
            value: memberAssignee?.id,
            required: true,
            items: members
                .map(
                  (final UserReadDto member) => DropdownMenuItem<String>(
                    value: member.id,
                    child: WCircleAvatar(
                      user: member,
                      showFullName: true,
                      size: 30,
                    ),
                  ),
                )
                .toList(),
            onChanged: (final memberId) {
              memberAssignee = members.firstWhereOrNull((final member) => member.id == memberId);
            },
          ),
          WRangeDatePickerField(
            labelText: s.startDate,
            initialValue: dateTimes.startDate != null ? dateTimes : null,
            startDate: Jalali.now(),
            onConfirm: (final value) {
              dateTimes = value;
            },
          ),
          WLabelsMultiSelectFormField(
            dataSourceType: labelDataSourceType,
            sourceId: mainSourceId,
            initialValues: selectedLabels,
            onChanged: (final value) {
              return selectedLabels = value;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(s.links).titleMedium(color: context.theme.hintColor),
              WLinks(
                links: links,
                onChanged: (final list) {
                  links = list;
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(s.files).titleMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) {
                  files = list;
                },
                uploadingFileStatus: (final value) {
                  isUploadingFile = value;
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _actionButton() => Obx(
    () => UElevatedButton(
      title: s.save,
      width: context.width,
      isLoading: buttonState.isLoading(),
      onTap: () => callApi(
        action: (final model) {
          widget.onResponse(model);
          UNavigator.back();
        },
      ),
    ),
    // ).pOnly(left: 16, right: 16, bottom: 24),
  );
}
