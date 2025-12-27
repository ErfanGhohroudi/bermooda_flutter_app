import 'package:u/utilities.dart';

import '../../widgets.dart';
import '../../fields/fields.dart';
import '../../image_files.dart';
import '../../../core.dart';
import '../../../functions/date_picker_functions.dart';
import '../../../../data/data.dart';
import 'edit_follow_up_controller.dart';

class EditFollowUpForm extends StatefulWidget {
  const EditFollowUpForm({
    required this.model,
    required this.onResponse,
    super.key,
  });

  final FollowUpReadDto model;
  final Function(FollowUpReadDto model) onResponse;

  @override
  State<EditFollowUpForm> createState() => _EditFollowUpFormState();
}

class _EditFollowUpFormState extends State<EditFollowUpForm> with EditFollowUpController {
  @override
  void initState() {
    initialController(followUp: widget.model);
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
      child: Obx(
        () {
          if (!membersState.isLoaded()) return const SizedBox(height: 300, child: Center(child: WCircularLoading()));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 18,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  WDatePickerField(
                    labelText: s.date,
                    required: true,
                    showRequired: false,
                    startDate: Jalali.now(),
                    initialValue: followUp.date?.formatCompactDate(),
                    onConfirm: (final date, final compactFormatterDate) {
                      followUp = followUp.copyWith(date: date);
                    },
                  ).expanded(),
                  WDropDownFormField<String>(
                    labelText: s.time,
                    deselectable: true,
                    value: followUp.time,
                    items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                    onChanged: (final value) {
                      followUp = followUp.copyWith(time: value);
                    },
                  ).expanded(),
                ],
              ),
              // مسئول انجام
              WDropDownFormField<String>(
                labelText: membersState.isLoaded() ? s.assignee : s.loading,
                value: followUp.assignedUser?.id,
                required: true,
                showRequiredIcon: false,
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
                  followUp = followUp.copyWith(assignedUser: members.firstWhereOrNull((final member) => member.id == memberId));
                },
              ),
              WImageFiles(
                files: followUp.files,
                maxFilesCount: 20,
                onFilesUpdated: (final list) => followUp = followUp.copyWith(files: list),
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
              Obx(
                () => UElevatedButton(
                  title: s.save,
                  width: context.width,
                  isLoading: buttonState.isLoading(),
                  onTap: () => onSubmit(
                    action: (final model) {
                      widget.onResponse(model);
                      UNavigator.back();
                    },
                  ),
                ),
              ).marginOnly(top: 30),
            ],
          );
        },
      ),
    );
  }
}
