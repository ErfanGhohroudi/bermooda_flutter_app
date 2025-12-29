import 'package:u/utilities.dart';

import '../../../utils/extensions/color_extension.dart';
import '../subtask_card_controller.dart';
import '../../widgets.dart';
import '../../fields/fields.dart';
import '../../image_files.dart';
import '../../links.dart';
import '../../time_tracking/time_tracking.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../../utils/enums/enums.dart';
import '../../../../data/data.dart';

class SubtaskDetailsPage extends StatefulWidget {
  const SubtaskDetailsPage({
    required this.subtask,
    required this.onChangedCheckBoxStatus,
    required this.onEdited,
    required this.onDelete,
    required this.showCheckBox,
    required this.canManage,
    this.canChange = true,
    this.showAppBar = true,
    super.key,
  });

  final SubtaskReadDto subtask;
  final Function(SubtaskReadDto model) onChangedCheckBoxStatus;
  final Function(SubtaskReadDto model) onEdited;
  final VoidCallback onDelete;
  final bool showCheckBox;
  final bool canManage;
  final bool canChange;
  final bool showAppBar;

  @override
  State<SubtaskDetailsPage> createState() => _SubtaskDetailsPageState();
}

class _SubtaskDetailsPageState extends State<SubtaskDetailsPage> with SubtaskCardController {
  bool get canManage => widget.canManage && haveAccess && !subtask.value.isCompleted && !subtask.value.isArchived && (haveAdminAccess || isMySubtask);

  @override
  void initState() {
    subtask(widget.subtask);
    super.initState();
  }

  @override
  void dispose() {
    subtask.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      color: context.theme.cardColor,
      appBar: widget.showAppBar
          ? AppBar(
              actions: canManage
                  ? [
                      /// More Button
                      Obx(
                        () {
                          if (!subtask.value.isCompleted) {
                            return WMoreButtonIcon(
                              items: [
                                if (canManage)
                                  WPopupMenuItem(
                                    title: s.edit,
                                    titleColor: AppColors.green,
                                    icon: AppIcons.editOutline,
                                    iconColor: AppColors.green,
                                    onTap: () => onEditTaped(onResponse: widget.onEdited),
                                  ),
                                if (haveAdminAccess)
                                  WPopupMenuItem(
                                    title: s.delete,
                                    titleColor: AppColors.red,
                                    icon: AppIcons.delete,
                                    iconColor: AppColors.red,
                                    onTap: () => deleteSubtask(action: () {
                                      widget.onDelete;
                                      if (mounted) UNavigator.back();
                                    }),
                                  ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(width: 10),
                    ]
                  : null,
            )
          : null,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 18,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      if (widget.showCheckBox && haveAccess)
                        WCheckBox(
                          isChecked: subtask.value.isCompleted, // Current checked state
                          onChanged: (final value) {
                            if (widget.canChange && canManage) {
                              changeSubtaskStatus(
                                onResponse: (final model) {
                                  widget.onChangedCheckBoxStatus(model);
                                  UNavigator.back();
                                },
                              );
                            }
                          },
                        ),
                      Text(
                        subtask.value.title ?? '',
                        textAlign: TextAlign.justify,
                        style: context.textTheme.titleMedium!,
                      ).bold().marginOnly(top: 4).expanded(),
                    ],
                  ).marginOnly(top: 24),
                  _item(
                    title: s.assignee,
                    icon: UImage(AppIcons.userOctagonOutline, size: 25, color: context.theme.hintColor),
                    value: WCircleAvatar(user: subtask.value.responsibleForDoing, size: 30, showFullName: true),
                  ),
                  _item(
                    title: s.date,
                    icon: UImage(AppIcons.calendarOutline, size: 25, color: context.theme.hintColor),
                    value: subtask.value.dateToStart != null || subtask.value.timeToStart != null || subtask.value.dateToEnd != null || subtask.value.timeToEnd != null
                        ? Text(
                            RangeDatePickerViewModel(
                              startDate: subtask.value.dateToStart,
                              startTime: subtask.value.timeToStart,
                              endDate: subtask.value.dateToEnd,
                              dueTime: subtask.value.timeToEnd,
                            ).getString(),
                          ).bodyMedium()
                        : Text(s.noDate).bodyMedium(color: context.theme.hintColor),
                  ),
                  _item(
                    title: s.label,
                    icon: UImage(AppIcons.tagOutline, size: 25, color: context.theme.hintColor),
                    value: subtask.value.labels.isNotEmpty
                        ? Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: List<WLabel>.generate(
                              subtask.value.labels.length,
                              (final index) => WLabel(
                                text: subtask.value.labels[index].title,
                                color: subtask.value.labels[index].colorCode.toColor(),
                              ),
                            ),
                          )
                        : Text(s.unlabeled).bodyMedium(color: context.theme.hintColor),
                    crossAxisAlignment: subtask.value.labels.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  ),
                ],
              ).pSymmetric(horizontal: 16),
              const Divider(),

              /// Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      UImage(AppIcons.progressStatusOutline, size: 25, color: context.theme.hintColor),
                      Text(s.progressStatus).bodyMedium(color: context.theme.hintColor),
                    ],
                  ),
                  WLabelProgressBar(
                    value: subtask.value.progress ?? 0,
                    interactive: isMySubtask,
                    onChanged: widget.canChange && canManage
                        ? (final value) => changeProgress(
                              value,
                              onResponse: (final model) => widget.onEdited(model),
                            )
                        : null,
                  ),
                ],
              ).pSymmetric(horizontal: 16),

              /// Timer
              if (subtask.value.timer != null) const Divider(),
              if (subtask.value.timer != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        UImage(AppIcons.timerOutline, size: 25, color: context.theme.hintColor),
                        Text(s.timeTracking).bodyMedium(color: context.theme.hintColor),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 35),
                      child: WTimeTracking(
                        timerDto: subtask.value.timer!,
                        showButtons: widget.canChange && widget.showCheckBox && !subtask.value.isCompleted && isMySubtask && !subtask.value.isArchived,
                        onTapButton: (final command) {
                          if (command == TimerStatusCommand.stop) {
                            appShowYesCancelDialog(
                              description: s.changeSubtaskStatusToDone,
                              onYesButtonTap: () {
                                UNavigator.back();
                                changedTimerStatus(command: command, onChangedTimer: widget.onChangedCheckBoxStatus);
                              },
                            );
                          } else {
                            changedTimerStatus(command: command, onChangedTimer: widget.onChangedCheckBoxStatus);
                          }
                        },
                      ),
                    ),
                  ],
                ).pSymmetric(horizontal: 16),
              const Divider(),
              WExpansionTile(
                title: s.links,
                showDivider: false,
                titleWidget: Row(
                  spacing: 16,
                  children: [
                    Flexible(child: Text(s.links).bodyMedium(color: context.theme.hintColor)),
                    UBadge(
                      badgeContent: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        child: Center(child: Text(subtask.value.links.length.toString()).bodyMedium(color: context.theme.hintColor)),
                      ),
                      badgeColor: context.theme.hintColor.withAlpha(100),
                    ),
                  ],
                ),
                icon: AppIcons.linkOutline,
                iconColor: context.theme.hintColor,
                startPadding: 0,
                child: subtask.value.links.isNotEmpty
                    ? WLinks(
                        links: subtask.value.links,
                        removable: false,
                        showAddWidget: false,
                        onChanged: (final list) {},
                      )
                    : SizedBox(height: 70, child: Center(child: Text(s.listIsEmpty).bodyMedium(color: context.theme.hintColor))),
                onChanged: (final value) {},
              ).pSymmetric(horizontal: 16),
              const Divider(),
              WExpansionTile(
                title: s.files,
                showDivider: false,
                titleWidget: Row(
                  spacing: 16,
                  children: [
                    Flexible(child: Text(s.files).bodyMedium(color: context.theme.hintColor)),
                    UBadge(
                      badgeContent: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        child: Center(child: Text(subtask.value.files.length.toString()).bodyMedium(color: context.theme.hintColor)),
                      ),
                      badgeColor: context.theme.hintColor.withAlpha(100),
                    ),
                  ],
                ),
                icon: AppIcons.attachment,
                titleColor: context.theme.hintColor,
                iconColor: context.theme.hintColor,
                startPadding: 0,
                child: subtask.value.files.isNotEmpty
                    ? WImageFiles(
                        files: subtask.value.files,
                        removable: false,
                        showUploadWidget: false,
                        onFilesUpdated: (final list) {},
                        uploadingFileStatus: (final value) {},
                      )
                    : SizedBox(height: 70, child: Center(child: Text(s.listIsEmpty).bodyMedium(color: context.theme.hintColor))),
                onChanged: (final value) {},
              ).pSymmetric(horizontal: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required final String title,
    required final Widget value,
    final Widget? icon,
    final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) =>
      Row(
        crossAxisAlignment: crossAxisAlignment,
        spacing: 10,
        children: [
          SizedBox(
            width: context.width / 3.5,
            child: Row(
              spacing: 10,
              children: [
                if (icon != null) icon,
                Flexible(
                  child: Text(title).bodyMedium(color: context.theme.hintColor),
                ),
              ],
            ),
          ),
          value.expanded(),
        ],
      );
}
