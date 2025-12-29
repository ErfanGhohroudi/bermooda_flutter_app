import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'subtask_card_controller.dart';

class WSubtaskCardCompact extends StatefulWidget {
  const WSubtaskCardCompact({
    required this.subtask,
    required this.onChangedStatus,
    super.key,
  });

  final SubtaskReadDto subtask;
  final Function(SubtaskReadDto model) onChangedStatus;

  @override
  State<WSubtaskCardCompact> createState() => _WSubtaskCardCompactState();
}

class _WSubtaskCardCompactState extends State<WSubtaskCardCompact> with SubtaskCardController {
  bool get canManage => haveAccess && !subtask.value.isCompleted && !subtask.value.isArchived && (haveAdminAccess || isMySubtask);

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
  void didUpdateWidget(covariant final WSubtaskCardCompact oldWidget) {
    if (oldWidget.subtask != widget.subtask) {
      subtask(widget.subtask);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WCard(
        showBorder: true,
        borderColor: subtask.value.isDelayed ? AppColors.red.withAlpha(50) : null,
        color: subtask.value.isDelayed && !subtask.value.isCompleted ? AppColors.red.withAlpha(20) : context.theme.scaffoldBackgroundColor,
        padding: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                /// CheckBox
                if (haveAccess)
                  WCheckBox(
                    isChecked: subtask.value.isCompleted, // Current checked state
                    onChanged: (final value) {
                      if (canManage) {
                        changeSubtaskStatus(onResponse: widget.onChangedStatus);
                      }
                    },
                  ),

                /// Title
                Text(
                  subtask.value.title ?? '',
                  textAlign: TextAlign.justify,
                  maxLines: 1,
                  style: context.textTheme.bodySmall!.copyWith(
                    decoration: subtask.value.isCompleted ? TextDecoration.combine([TextDecoration.lineThrough]) : null,
                    decorationColor: subtask.value.isCompleted ? context.theme.primaryColorDark.withAlpha(150) : null,
                  ),
                ).bold().marginOnly(top: 2).expanded(),

                /// Pulsing Circle
                if (subtask.value.timer?.status == TimerStatus.running) const WPulsingCircle(),

                /// Avatar
                WCircleAvatar(
                  user: subtask.value.responsibleForDoing,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
