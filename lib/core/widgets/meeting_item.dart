part of 'widgets.dart';

class WMeetingItem extends StatelessWidget {
  const WMeetingItem({
    required this.meeting,
    required this.onEdited,
    required this.onDelete,
    super.key,
  });

  final MeetingReadDto meeting;
  final Function(MeetingReadDto model) onEdited;
  final VoidCallback onDelete;

  void deleteMeeting({
    required final MeetingReadDto meeting,
    required final VoidCallback action,
  }) {
    Get.find<MeetingDatasource>().delete(
      id: meeting.id,
      onResponse: () {
        action();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final core = Get.find<Core>();
    final meetingMembers = [...meeting.members!, ...meeting.meetingPhoneNumbers!, ...meeting.meetingEmails!];

    return WCard(
      // color: meeting.label?.colorCode.toColor(),
      showBorder: true,
      child: SizedBox(
        width: context.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              children: [
                UImage(meeting.label?.eventType?.icon ?? '', size: 20, color: meeting.label?.colorCode.toColor()),
                const SizedBox(width: 10),
                Text(
                  meeting.label?.title ?? '',
                  maxLines: 1,
                ).bodyMedium(color: meeting.label?.colorCode.toColor(), overflow: TextOverflow.ellipsis).bold().expanded(),
                if (meeting.members?.first.id == core.userReadDto.value.id)
                  Icon(Icons.more_vert_rounded, color: context.theme.hintColor).showMenus(
                    [
                      WPopupMenuItem(
                        title: s.edit,
                        icon: AppIcons.editOutline,
                        iconColor: AppColors.green,
                        onTap: () {
                          UNavigator.push(
                            CreateEditMeetingPage(
                              meeting: meeting,
                              onResponse: onEdited,
                            ),
                          );
                        },
                      ),
                      WPopupMenuItem(
                        title: s.delete,
                        icon: AppIcons.delete,
                        iconColor: AppColors.red,
                        onTap: () {
                          appShowYesCancelDialog(
                            title: s.delete,
                            description: s.areYouSureToDeleteMessage,
                            yesButtonTitle: s.delete,
                            yesBackgroundColor: AppColors.red,
                            onYesButtonTap: () {
                              UNavigator.back();
                              deleteMeeting(
                                meeting: meeting,
                                action: onDelete,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ).marginOnly(bottom: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                /// Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${s.title}: ").bodyMedium(),
                    Flexible(
                      child: Text(meeting.title ?? '').bodyMedium(),
                    ),
                  ],
                ),

                /// Link
                if (meeting.link != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${s.link}: ").bodyMedium(),
                      Flexible(
                        child: WTextButton2(
                          text: meeting.link!,
                          onPressed: () {
                            ULaunch.launchURL(meeting.link!);
                          },
                        ),
                      ),
                    ],
                  ),

                /// Description
                if ((meeting.description ?? '') != '')
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${s.description}: ").bodyMedium(),
                      Flexible(
                        child: Text(meeting.description ?? '').bodyMedium(),
                      ),
                    ],
                  ),

                /// Members
                if (meetingMembers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${s.members}:").bodyMedium(),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: meetingMembers.map(
                          (final item) {
                            return WLabel(
                              user: item is UserReadDto ? item : null,
                              text: item is MeetingPhoneNumber
                                  ? item.phoneNumber
                                  : item is MeetingEmail
                                  ? item.email
                                  : null,
                              color: context.theme.dividerColor,
                              textColor: Colors.black,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
              ],
            ),

            /// Files
            if (meeting.files?.isNotEmpty ?? false)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                runAlignment: WrapAlignment.start,
                children: List.generate(
                  meeting.files!.length,
                  (final fileIndex) => WUploadAndShowImage(
                    file: meeting.files![fileIndex],
                    onUploaded: (final file) {},
                    onRemove: (final file) {},
                    uploadStatus: (final value) {},
                    removable: false,
                    itemSize: 50,
                  ),
                ),
              ).marginOnly(top: 12),
            const Divider(),

            /// Labels
            if (meeting.reminderTimeType != null || meeting.repeatType != null)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  /// Reminder Time
                  if (meeting.reminderTimeType != null)
                    WLabel(
                      text: meeting.reminderTimeType?.getTitle(),
                      color: context.theme.dividerColor,
                      textColor: Colors.black,
                    ),

                  /// Repeat Type
                  if (meeting.repeatType != null)
                    WLabel(
                      text: meeting.repeatType?.getTitle(),
                      color: context.theme.dividerColor,
                      textColor: Colors.black,
                    ),
                ],
              ).marginOnly(bottom: 10),

            /// Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child:
                      Text(
                        "${s.start} : ${meeting.dateToStart?.formatCompactDate()} | ${meeting.startMeetingTime}",
                        textAlign: TextAlign.justify,
                      ).bodySmall(
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                Flexible(
                  child:
                      Text(
                        "${s.end} : ${meeting.dateToStart?.formatCompactDate()} | ${meeting.endMeetingTime}",
                        textAlign: TextAlign.justify,
                      ).bodySmall(
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
