import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../controllers/follow_up_card_controller.dart';

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

class _WFollowUpCardState extends State<WFollowUpCard> {
  late FollowUpCardController ctrl;

  bool get canManage =>
      ctrl.haveAccess && !ctrl.followUp.value.isFollowed && !ctrl.followUp.value.isDeleted && (ctrl.isMyFollowUp || ctrl.haveAdminAccess);

  bool get isMainShape => widget.shape == FollowUpCardShape.main;

  @override
  void initState() {
    ctrl = FollowUpCardController(followUp: widget.followUp);
    super.initState();
  }

  @override
  void dispose() {
    ctrl.disposeItems();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WFollowUpCard oldWidget) {
    if (oldWidget.followUp != widget.followUp) {
      ctrl.followUp(widget.followUp);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WCard(
        onTap: isMainShape
            ? () {
                ctrl.navigateToDetailsPage(
                  showSourceData: widget.showSourceData,
                  canManage: canManage,
                  onChanged: widget.onChanged,
                  onDelete: widget.onDelete,
                );
              }
            : null,
        showBorder: true,
        borderColor: ctrl.followUp.value.isDelayed ? AppColors.red.withAlpha(50) : null,
        color: ctrl.followUp.value.isDelayed
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
                  isChecked: ctrl.followUp.value.isFollowed, // Current checked state
                  onChanged: (final value) {
                    if (canManage) {
                      ctrl.onTapFollowUpCheckBox(
                        followUp: ctrl.followUp.value,
                        onResponse: (final model) => widget.onDelete(),
                      );
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ctrl.followUp.value.time != null) Text(ctrl.followUp.value.time!).bodyMedium().bold(),
                    Text(ctrl.followUp.value.date?.formatCompactDate() ?? '- -').bodyMedium(),
                  ],
                ).expanded(),

                /// Pulsing Circle
                if (ctrl.followUp.value.timer?.status == TimerStatus.running) const WPulsingCircle(),

                /// Avatar
                if (!isMainShape)
                  WCircleAvatar(
                    user: ctrl.followUp.value.assignedUser,
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
                    user: ctrl.followUp.value.assignedUser,
                    size: 30,
                  ),
                  UBadge(
                    badgeContent: Text(ctrl.followUp.value.files.length.toString()).bodySmall(color: Colors.white),
                    showBadge: ctrl.followUp.value.files.isNotEmpty,
                    child: UImage(
                      AppIcons.attachment,
                      size: 25,
                      color: ctrl.followUp.value.files.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,
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
