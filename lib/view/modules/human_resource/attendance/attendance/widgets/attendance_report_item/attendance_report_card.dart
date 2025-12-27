import 'package:bermooda_business/core/utils/extensions/date_extensions.dart';
import 'package:u/utilities.dart';

import '../../../../../../../core/utils/extensions/request_extensions.dart';
import '../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../core/core.dart';
import '../../../../../../../data/data.dart';
import '../../../../../requests/details/request_detail_page.dart';

class WAttendanceReportCard extends StatelessWidget {
  const WAttendanceReportCard({
    required this.report,
    this.model,
    super.key,
  });

  final AttendanceReportDto report;
  final MemberAttendanceSummaryReadDto? model;

  @override
  Widget build(final BuildContext context) {
    if (report.actionType == null) {
      return const SizedBox.shrink();
    }

    return WCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 12,
            children: [
              if (model != null)
                Stack(
                  children: [
                    WCircleAvatar(
                      user: UserReadDto(id: '', fullName: model!.fullname, avatar: model!.avatar),
                      size: 30,
                    ),
                    Positioned(
                      bottom: 0,
                      left: isPersianLang ? 0 : null,
                      right: !isPersianLang ? 0 : null,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: report.actionType!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              Expanded(child: Text(report.actionType!.title).titleMedium(color: report.actionType!.color)),
              if (report.actionDatetime != null)
                Text(
                  report.actionDatetime.toJalaliDateTimeString,
                  textDirection: TextDirection.ltr,
                ).bodyMedium(color: context.theme.hintColor),
            ],
          ),
          if (report.message != null) Text(report.message!).bodyMedium(),
          // if (report.relatedObject != null) _buildSubTaskItem(context, report.relatedObject!),
        ],
      ),
    );
  }

  Widget _buildSubTaskItem(final BuildContext context, final IRequestReadDto request) {
    return WCard(
      onTap: () => UNavigator.push(
        RequestDetailPage(
          request: request,
          // showRequestingUser: true,
          canEdit: false,
          onTapRequestCheckBox: (final status) {},
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: 6,
      color: context.isDarkMode ? Colors.white10 : Colors.grey[50],
      showBorder: true,
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Text(
              request.getTitle(),
              maxLines: 2,
              style: context.textTheme.bodyMedium?.copyWith(
                // decoration: request.status.isPending() ? null : TextDecoration.lineThrough,
                // color: request.status.isPending() ? null : context.theme.hintColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // if (request.assignedTo.isNotEmpty)
          //   WOverlappingAvatarRow(
          //     users: request.assignedTo.map((final e) => e.user).toList(),
          //     maxVisibleAvatars: 2,
          //   )
          // else
          //   const UImage(AppIcons.info, size: 35, color: AppColors.orange),
        ],
      ),
    );
  }
}
