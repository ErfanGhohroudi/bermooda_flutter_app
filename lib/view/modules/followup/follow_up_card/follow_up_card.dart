import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'follow_up_card_controller.dart';
import 'follow_up_details/follow_up_details_page.dart';

enum FollowUpCardShape { main, compact }

class WFollowUpCard extends StatefulWidget {
  const WFollowUpCard({
    required this.followUp,
    required this.onChanged,
    required this.onDelete,
    this.shape = FollowUpCardShape.main,
    this.showSourceData = true,
    super.key,
  });

  final FollowUpReadDto followUp;
  final Function(FollowUpReadDto model) onChanged;
  final VoidCallback onDelete;
  final FollowUpCardShape shape;
  final bool showSourceData;

  @override
  State<WFollowUpCard> createState() => _WFollowUpCardState();
}

class _WFollowUpCardState extends State<WFollowUpCard> with FollowUpCardController {
  bool get canManage =>
      haveAccess && !followUp.value.isFollowed && !followUp.value.isDeleted && (isMyFollowUp || haveAdminAccess);

  bool get isMainShape => widget.shape == FollowUpCardShape.main;

  @override
  void initState() {
    initialController(followUp: widget.followUp);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WFollowUpCard oldWidget) {
    if (oldWidget.followUp != widget.followUp) {
      followUp(widget.followUp);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WCard(
        onTap: isMainShape
            ? () {
                UNavigator.push(
                  FollowUpDetailsPage(
                    followUp: followUp.value,
                    showSourceData: widget.showSourceData,
                    canManage: canManage,
                    onChanged: (final model) {
                      followUp(model);
                      widget.onChanged(model);
                    },
                    onDelete: widget.onDelete,
                  ),
                );
              }
            : null,
        showBorder: true,
        borderColor: followUp.value.isDelayed ? AppColors.red.withAlpha(50) : null,
        color: followUp.value.isDelayed
            ? AppColors.red.withAlpha(20)
            : (isMainShape ? null : context.theme.scaffoldBackgroundColor),
        padding: isMainShape ? 12 : 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                WCheckBox(
                  isChecked: followUp.value.isFollowed, // Current checked state
                  onChanged: (final value) {
                    if (canManage) {
                      onTapFollowUpCheckBox(
                        followUp: followUp.value,
                        onResponse: (final model) => widget.onDelete(),
                      );
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (followUp.value.time != null) Text(followUp.value.time!).bodyMedium().bold(),
                    Text(followUp.value.date?.formatCompactDate() ?? '- -').bodyMedium(),
                  ],
                ).expanded(),

                /// Pulsing Circle
                if (followUp.value.timer?.status == TimerStatus.running) const WPulsingCircle(),

                /// Avatar
                if (!isMainShape)
                  WCircleAvatar(
                    user: followUp.value.assignedUser,
                    size: 30,
                  ),

                if (isMainShape) Icon(Icons.arrow_forward_ios_rounded, color: context.theme.hintColor, size: 18),
              ],
            ),
            if (isMainShape) ...[
              const Divider(height: 0),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  WCircleAvatar(
                    user: followUp.value.assignedUser,
                    size: 30,
                  ),
                  UBadge(
                    badgeContent: Text(followUp.value.files.length.toString()).bodySmall(color: Colors.white),
                    showBadge: followUp.value.files.isNotEmpty,
                    child: UImage(
                      AppIcons.attachment,
                      size: 25,
                      color: followUp.value.files.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
