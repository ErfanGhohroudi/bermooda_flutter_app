import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/widgets/widgets.dart';
import 'subtask_details/subtask_details_page.dart';
import 'subtask_card_controller.dart';

class WSubtaskCard extends StatefulWidget {
  const WSubtaskCard({
    required this.subtask,
    required this.onChangedCheckBoxStatus,
    required this.onEdited,
    required this.onDelete,
    this.cardColor,
    this.showOwner = true,
    this.showCheckBox = true,
    this.showDetailsPage = true,
    super.key,
  });

  final SubtaskReadDto subtask;
  final Function(SubtaskReadDto model) onChangedCheckBoxStatus;
  final Function(SubtaskReadDto model) onEdited;
  final VoidCallback onDelete;
  final Color? cardColor;
  final bool showOwner;
  final bool showCheckBox;
  final bool showDetailsPage;

  @override
  State<WSubtaskCard> createState() => _WSubtaskCardState();
}

class _WSubtaskCardState extends State<WSubtaskCard> with SubtaskCardController {
  bool get canManage => haveAccess && !subtask.value.isCompleted && !subtask.value.isArchived;

  @override
  void initState() {
    subtask = widget.subtask.obs;
    super.initState();
  }

  @override
  void dispose() {
    subtask.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WSubtaskCard oldWidget) {
    if (oldWidget.subtask != widget.subtask) {
      subtask(widget.subtask);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: widget.showDetailsPage
            ? () {
                UNavigator.push(SubtaskDetailsPage(
                  subtask: subtask.value,
                  canManage: canManage,
                  showCheckBox: widget.showCheckBox,
                  onChangedCheckBoxStatus: (final model) {
                    subtask(model);
                    widget.onChangedCheckBoxStatus(model);
                  },
                  onEdited: (final model) {
                    subtask(model);
                    widget.onEdited(model);
                  },
                  onDelete: widget.onDelete,
                ));
              }
            : null,
        child: WCard(
          showBorder: true,
          borderColor: subtask.value.isDelayed ? AppColors.red.withAlpha(50) : null,
          color: subtask.value.isDelayed && !subtask.value.isCompleted ? AppColors.red.withAlpha(20) : widget.cardColor,
          padding: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  /// CheckBox
                  if (widget.showCheckBox && haveAccess)
                    WCheckBox(
                      isChecked: subtask.value.isCompleted, // Current checked state
                      onChanged: (final value) {
                        if (canManage) {
                          changeSubtaskStatus(onResponse: widget.onChangedCheckBoxStatus);
                        }
                      },
                    ),

                  /// Title
                  Text(
                    subtask.value.title ?? '',
                    textAlign: TextAlign.justify,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: widget.cardColor != null ? Colors.white : null,
                      height: 1.8,
                    ),
                  ).bold().expanded(),

                  /// Pulsing Circle
                  if (subtask.value.timer?.status == TimerStatus.running) const WPulsingCircle().marginOnly(top: 3),

                  Icon(Icons.arrow_forward_ios_rounded, size: 20, color: context.theme.hintColor),
                ],
              ).marginOnly(bottom: 6),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  WCircleAvatar(
                    user: subtask.value.responsibleForDoing,
                    size: 30,
                  ),
                  UImage(
                    AppIcons.calendarOutline,
                    size: 25,
                    color: subtask.value.dateToStart != null ? context.theme.primaryColorDark : context.theme.hintColor,
                  ),
                  UBadge(
                    badgeContent: Text(subtask.value.files.length.toString()).bodySmall(color: Colors.white),
                    showBadge: subtask.value.files.isNotEmpty,
                    child: UImage(AppIcons.attachment, size: 25, color: subtask.value.files.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,),
                  ),
                  UBadge(
                    badgeContent: Text(subtask.value.links.length.toString()).bodySmall(color: Colors.white),
                    showBadge: subtask.value.links.isNotEmpty,
                    child: UImage(AppIcons.linkOutline, size: 25, color: subtask.value.links.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,),
                  ),
                  UBadge(
                    badgeContent: Text(subtask.value.labels.length.toString()).bodySmall(color: Colors.white),
                    showBadge: subtask.value.labels.isNotEmpty,
                    child: UImage(AppIcons.tagOutline, size: 25, color: subtask.value.labels.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor),
                  ),
                ],
              ),

              /// Progress Bar
              WLabelProgressBar(
                value: subtask.value.progress ?? 0,
                interactive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
