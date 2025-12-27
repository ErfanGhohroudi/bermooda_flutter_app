import 'package:bermooda_business/core/utils/extensions/date_extensions.dart';
import 'package:u/utilities.dart';

import '../../../../core/navigator/navigator.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';

class WReviewersList extends StatelessWidget {
  const WReviewersList({
    required this.reviewers,
    required this.currentReviewer,
    required this.onTapRequestCheckBox,
    this.canEdit = true,
    super.key,
  });

  final List<AcceptorUserReadDto> reviewers;
  final AcceptorUserReadDto? currentReviewer;
  final ValueChanged<bool> onTapRequestCheckBox;
  final bool canEdit;

  @override
  Widget build(final BuildContext context) {
    final core = Get.find<Core>();

    return ListView.separated(
      itemCount: reviewers.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (final context, final index) => Divider(
        color: context.theme.dividerColor.withAlpha(100),
        height: 5,
      ),
      itemBuilder: (final context, final index) {
        final reviewer = reviewers[index];
        final isMe = reviewer.user.id == core.userReadDto.value.id;
        final isCurrentReviewer = reviewer.slug == currentReviewer?.slug;
        final isDelayed = reviewer.reviewDeadlineDate == null
            ? false
            : !reviewer.isChecked &&
                reviewer.reviewDeadlineDate!.toJalali().isBefore(Jalali.now().copyWith(
                      second: 0,
                      millisecond: 0,
                    ));

        return AnimatedScale(
          scale: isCurrentReviewer ? 1 : 0.9,
          duration: 300.milliseconds,
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: isCurrentReviewer ? 1 : 0.5,
            duration: 300.milliseconds,
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: 300.milliseconds,
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isCurrentReviewer ? context.theme.primaryColor.withAlpha(20) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 4,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      if (canEdit)
                        WCheckBox(
                          isChecked: reviewer.isChecked,
                          activeColor: isMe ? null : Colors.grey.shade300,
                          borderColor: isMe ? null : Colors.grey.shade300,
                          onChanged: (final value) {
                            if (!isCurrentReviewer) return;
                            if (!isMe || reviewer.isChecked) return AppNavigator.snackbarRed(title: s.error, subtitle: s.notAllowChangeStatus);
                            onTapRequestCheckBox(value);
                          },
                        ),
                      WCircleAvatar(user: reviewer.user, showFullName: true, size: 35).expanded(),
                      if (reviewer.status != null)
                        WLabel(
                          text: reviewer.status!.getTitle(),
                          color: reviewer.status!.color,
                        ),
                    ],
                  ),
                  if (reviewer.reviewDeadlineDate != null)
                    Text(
                      "${s.deadline}: "
                      "${reviewer.reviewDeadlineDate?.toJalaliDateString ?? '- -'}",
                    ).bodySmall(color: isDelayed ? AppColors.red : context.theme.hintColor).bold(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
