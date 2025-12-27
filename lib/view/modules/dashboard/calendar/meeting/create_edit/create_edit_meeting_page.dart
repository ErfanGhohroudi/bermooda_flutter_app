import 'package:u/utilities.dart';

import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/functions/date_picker_functions.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import 'create_edit_meeting_controller.dart';

class CreateEditMeetingPage extends StatefulWidget {
  const CreateEditMeetingPage({
    required this.onResponse,
    this.meeting,
    this.time,
    super.key,
  });

  final MeetingReadDto? meeting;
  final Jalali? time;
  final Function(MeetingReadDto meeting) onResponse;

  @override
  State<CreateEditMeetingPage> createState() => _CreateEditMeetingPageState();
}

class _CreateEditMeetingPageState extends State<CreateEditMeetingPage> with CreateEditMeetingController {
  @override
  void initState() {
    initValues(model: widget.meeting, time: widget.time);
    getEventTypes(
      action: () {},
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        appShowYesCancelDialog(
          title: s.warning,
          description: s.exitPage,
          onYesButtonTap: () {
            UNavigator.back();
            Future.delayed(const Duration(milliseconds: 10), () {
              UNavigator.back();
            });
          },
        );
      },
      child: UScaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(actionApiType.isCreate() ? s.newMeeting : s.editMeeting),
        ),
        bottomNavigationBar: Obx(
          () => UElevatedButton(
            title: actionApiType.isCreate() ? s.confirm : s.save,
            isLoading: buttonState.isLoading(),
            onTap: () => onSubmit(
              onResponse: (final model) {
                widget.onResponse(model);
                UNavigator.back();
              },
            ),
          ).marginOnly(left: 16, right: 16, bottom: 24, top: 10),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => labelList.isNotEmpty
                      ? WDropDownFormField<LabelReadDto>(
                          labelText: labelList.isNotEmpty ? s.meetingType : s.loading,
                          value: selectedLabel.value,
                          enable: actionApiType.isCreate(),
                          items: labelList
                              .map(
                                (final LabelReadDto label) => DropdownMenuItem<LabelReadDto>(
                                  value: label,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: isPersianLang ? BorderSide(color: label.colorCode.toColor(), width: 5) : BorderSide.none,
                                        left: !isPersianLang ? BorderSide(color: label.colorCode.toColor(), width: 5) : BorderSide.none,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        UImage(label.eventType?.icon ?? '', size: 20, color: label.colorCode.toColor()),
                                        const SizedBox(width: 12),
                                        WDropdownItemText(text: label.title ?? ''),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (final type) {
                            selectedLabel(type);
                          },
                        ).marginOnly(bottom: 12)
                      : const SizedBox(),
                ),
                _form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18,
        children: [
          /// Title
          WTextField(
            controller: titleController,
            required: true,
            labelText: s.title,
          ),

          /// Date
          WDatePickerField(
            initialValue: dateController.text,
            required: true,
            enableClearButton: false,
            onConfirm: (final date, final compactFormatterDate) {
              if (date != null) {
                selectedTime = date;
                dateController.text = compactFormatterDate ?? '';
              }
            },
          ),

          /// Start Time & End Time
          Row(
            children: [
              WDropDownFormField<String>(
                labelText: s.startTime,
                required: true,
                value: selectedStartTime,
                items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                onChanged: (final value) {
                  selectedStartTime = value;
                },
              ).expanded(),
              const SizedBox(width: 10),
              WDropDownFormField<String>(
                labelText: s.endTime,
                required: true,
                value: selectedEndTime,
                items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                onChanged: (final value) {
                  selectedEndTime = value;
                },
              ).expanded(),
            ],
          ),

          /// Description
          WTextField(
            controller: descriptionController,
            hintText: s.typeYourComments,
            multiLine: true,
            minLines: 3,
            maxLines: 10,
          ),

          /// Images
          WImageFiles(
            files: files,
            onFilesUpdated: (final list) {
              files = list;
            },
            uploadingFileStatus: (final value) {
              isUploadingFile = value;
            },
          ),

          /// Additional infos
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                WSwitchForm(
                  value: additionalInfoSwitch.value,
                  icon: AppIcons.info,
                  title: s.additionalInfo,
                  onChanged: () {
                    additionalInfoSwitch(!additionalInfoSwitch.value);
                  },
                ),
                if (additionalInfoSwitch.value) ...[
                  /// Reminder Time
                  WDropDownFormField(
                    labelText: s.reminderTime,
                    value: selectedReminderTime,
                    items: ReminderTimeType.values
                        .map(
                          (final ReminderTimeType type) => DropdownMenuItem<ReminderTimeType>(
                            value: type,
                            child: WDropdownItemText(text: type.getTitle()),
                          ),
                        )
                        .toList(),
                    onChanged: (final type) {
                      selectedReminderTime = type!;
                    },
                  ),

                  /// Repeat Type
                  WDropDownFormField<RepeatType>(
                    labelText: s.repeat,
                    value: repeatType,
                    items: RepeatType.values
                        .map(
                          (final RepeatType type) => DropdownMenuItem<RepeatType>(
                            value: type,
                            child: WDropdownItemText(text: type.getTitle()),
                          ),
                        )
                        .toList(),
                    onChanged: (final type) {
                      repeatType = type!;
                    },
                  ),

                  /// Link
                  UTextFormField(
                    controller: linkController,
                    labelText: s.link,
                    hintText: "https://example.com",
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.url,
                    formatters: [FilteringTextInputFormatter.deny(RegExp(r'[\s\u200C\n\t]'))],
                    maxLines: 5,
                  ),

                  /// Add Members
                  WMembersPickerFormField(
                    labelText: s.inviteMembers,
                    selectedMembers: selectedMembers,
                    onConfirm: (final list) {
                      selectedMembers = list;
                    },
                  ),

                  /// Invite Guests
                  _inviteGuests(),
                ],
              ],
            ),
          ),
        ],
      );

  Widget _inviteGuests() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(s.inviteGuests).bodyMedium(),
              const SizedBox(width: 10),
              WTextButton2(
                text: s.help,
                onPressed: () {
                  showAppDialog(
                    AlertDialog(
                      title: Text(s.inviteGuests).titleMedium(),
                      content: Text(s.inviteGuestsHelper).bodyMedium(),
                    ),
                  );
                },
              ),
            ],
          ),
          const Divider().marginOnly(bottom: 10),

          /// Add Phone Number
          WPhoneNumberField(
            controller: phoneNumberController,
            helperText: s.tapEnterToAdd,
            helperStyle: context.textTheme.bodySmall!.copyWith(color: context.theme.primaryColor),
            onEditingComplete: onEnteredPhoneNumber,
          ).marginOnly(bottom: selectedPhoneNumbersList.isEmpty ? 18 : 0),

          /// Selected Phone Numbers
          if (selectedPhoneNumbersList.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List<Widget>.generate(
                selectedPhoneNumbersList.length,
                (final index) => FilterChip(
                  label: Text(selectedPhoneNumbersList[index]),
                  onSelected: (final value) {},
                  onDeleted: () => removePhoneNumber(selectedPhoneNumbersList[index]),
                ),
              ),
            ).marginOnly(top: 5, bottom: 18),

          /// Add Emails
          WEmailField(
            controller: emailController,
            helperText: s.tapEnterToAdd,
            helperStyle: context.textTheme.bodySmall!.copyWith(color: context.theme.primaryColor),
            onEditingComplete: onEnteredEmail,
          ).marginOnly(bottom: selectedEmailsList.isEmpty ? 5 : 0),

          /// Selected Emails
          if (selectedEmailsList.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List<Widget>.generate(
                selectedEmailsList.length,
                (final index) => FilterChip(
                  label: Text(selectedEmailsList[index]),
                  onSelected: (final value) {},
                  onDeleted: () => removeEmail(selectedEmailsList[index]),
                ),
              ),
            ).marginOnly(top: 5, bottom: 18),
        ],
      );
}
