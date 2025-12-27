import 'package:u/utilities.dart';

import '../../../../core/navigator/navigator.dart';
import '../../../../core/utils/extensions/money_extensions.dart';
import '../../../../core/utils/extensions/request_extensions.dart';
import '../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../data/data.dart';
import '../details/request_detail_page.dart';
import 'reviewers_list.dart';

class WRequestCard extends StatelessWidget {
  const WRequestCard({
    required this.request,
    required this.onSelectedNewStatus,
    this.showRequestingUser = true,
    this.canEdit = true,
    this.onTap,
    this.addReviewersButton,
    super.key,
  });

  final IRequestReadDto request;
  final ValueChanged<StatusType> onSelectedNewStatus;
  final bool showRequestingUser;
  final bool canEdit;
  final VoidCallback? onTap;
  final Widget? addReviewersButton;

  bool get isChecked => !(request.status?.isPending() ?? true);

  void toggleRequestStatus() {
    if (isChecked) return AppNavigator.snackbarRed(title: s.warning, subtitle: s.notAllowChangeStatus);
    appShowYesCancelDialog(
      title: s.changeRequestStatusDialogTitle,
      description: s.changeRequestStatusDialogContent,
      cancelButtonTitle: s.reject,
      cancelBackgroundColor: StatusType.rejected.color,
      onCancelButtonTap: () {
        UNavigator.back();
        onSelectedNewStatus(StatusType.rejected);
      },
      yesButtonTitle: s.approve,
      yesBackgroundColor: StatusType.approved.color,
      onYesButtonTap: () {
        UNavigator.back();
        onSelectedNewStatus(StatusType.approved);
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      borderColor: request.reviewerUsers.isEmpty ? AppColors.orange : null,
      onTap: onTap ??
          () => UNavigator.push(
                RequestDetailPage(
                  request: request,
                  canEdit: canEdit,
                  onTapRequestCheckBox: (final value) => toggleRequestStatus(),
                ),
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with user info and status
          _buildHeader(context),

          // Request type and description
          _buildRequestInfo(context),

          // Request specific details
          _buildRequestDetails(context),

          // Date and time information
          _buildDateTimeInfo(context).marginOnly(top: 10),

          if (canEdit && request.reviewerUsers.isEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                const UImage(AppIcons.info, size: 25, color: AppColors.brown),
                Flexible(
                  child: Text(
                    s.assignReviewersToRequestInfoText,
                  ).bodyMedium(color: AppColors.brown).bold().marginOnly(top: 4),
                ),
              ],
            ).marginOnly(top: 6),

          // Reviewers Users
          _buildReviewers(context),
        ],
      ),
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showRequestingUser)
          WCircleAvatar(
            user: request.requestingUser,
            showFullName: true,
            maxLines: 2,
            size: 50,
          ).expanded(),
        WLabel(
          text: request.status?.getTitle() ?? '',
          color: request.status?.color,
        ),
      ],
    );
  }

  Widget _buildRequestInfo(final BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 10,
      minTileHeight: 40,
      leading: UImage(
        request.getIcon(),
        size: 25,
        color: context.theme.hintColor,
      ),
      title: Text(
        request.getTitle(),
        maxLines: 1,
      ).bodyMedium(overflow: TextOverflow.ellipsis, color: context.theme.hintColor),
      subtitle: (request.description ?? '') == ''
          ? null
          : Text(
              request.description ?? '',
              maxLines: 2,
            ).bodySmall(overflow: TextOverflow.ellipsis, color: context.theme.hintColor),
    );
  }

  Widget _buildRequestDetails(final BuildContext context) {
    return WCard(
      margin: EdgeInsets.zero,
      color: context.isDarkMode ? Colors.white10 : Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: _getRequestSpecificDetails(context),
      ),
    );
  }

  Widget _buildDateTimeInfo(final BuildContext context) {
    final startTime = _getStartDateTime();
    final endTime = _getEndDateTime();

    if (startTime.isEmpty && endTime.isEmpty) return const SizedBox.shrink();

    return WCard(
      color: context.isDarkMode ? Colors.white10 : Colors.grey.shade100,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          if (startTime.isNotEmpty)
            _buildDateTimeItem(
              context,
              s.start,
              _getStartDateTime(),
              AppIcons.calendarOutline,
            ),
          if (endTime.isNotEmpty)
            _buildDateTimeItem(
              context,
              s.end,
              _getEndDateTime(),
              AppIcons.calendarOutline,
            ),
        ],
      ),
    );
  }

  Widget _buildReviewers(final BuildContext context) {
    final List<UserReadDto> userList = request.reviewerUsers.map((final acceptor) => acceptor.user).whereType<UserReadDto>().toList();

    if (userList.isEmpty) {
      if(canEdit == false) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.only(top: addReviewersButton == null ? 0 : 10),
        child: addReviewersButton ?? const SizedBox.shrink(),
      );
    }

    return WCard(
      color: context.isDarkMode ? Colors.white10 : Colors.grey.shade100,
      margin: EdgeInsets.zero,
      verPadding: 0,
      child: WExpansionTile(
        title: '',
        startPadding: 0,
        titleWidget: Row(
          children: [
            Text(
              '${s.reviewers}:  ',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.hintColor,
              ),
            ),
            WOverlappingAvatarRow(
              users: userList,
              maxVisibleAvatars: 5,
            ).expanded(),
          ],
        ),
        child: WReviewersList(
          reviewers: request.reviewerUsers,
          currentReviewer: request.currentReviewer,
          canEdit: canEdit,
          onTapRequestCheckBox: (final value) => toggleRequestStatus(),
        ).marginOnly(bottom: 12),
        onChanged: (final value) {},
      ),
    ).marginOnly(top: 10);
  }

  Widget _buildDateTimeItem(
    final BuildContext context,
    final String label,
    final String value,
    final String icon,
  ) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          UImage(
            icon,
            size: 20,
            color: context.isDarkMode ? Colors.white54 : Colors.black38,
          ),
          Flexible(
            child: Text(
              "$label: $value".trim(),
              textAlign: TextAlign.justify,
            ).bodySmall(
              overflow: TextOverflow.ellipsis,
              color: context.isDarkMode ? Colors.white54 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getRequestSpecificDetails(final BuildContext context) {
    switch (request.categoryType) {
      case RequestCategoryType.employment:
        return _getEmploymentDetails(context);
      case RequestCategoryType.leave_attendance:
        return _getLeaveDetails(context);
      case RequestCategoryType.missions_work:
        return _getMissionDetails(context);
      case RequestCategoryType.welfare_financial:
        return _getWelfareDetails(context);
      case RequestCategoryType.support_logistics:
        return _getSupportDetails(context);
      case RequestCategoryType.general_requests:
        return _getGeneralDetails(context);
      case RequestCategoryType.overtime:
        return _getOvertimeDetails(context);
      default:
        return [];
    }
  }

  List<Widget> _getEmploymentDetails(final BuildContext context) {
    if (request is! EmploymentRequestEntity) return [];

    final employment = request as EmploymentRequestEntity;
    return [
      _buildDetailRow(context, s.category, employment.categoryType.getTitle()),
      _buildDetailRow(context, s.requestType, employment.cooperationType.getTitle()),
      if (employment.workloadType != null && employment.cooperationType != EmploymentCooperationType.outsourcing)
        _buildDetailRow(context, s.workload, employment.workloadType!.getTitle()),
      _buildDetailRow(context, s.organizationalUnit, employment.organizationalUnit.isNotEmpty ? employment.organizationalUnit : '- -'),
      _buildDetailRow(context, s.workLocation, employment.workLocation.getTitle()),
      _buildDetailRow(context, s.requiredPersonnelCount, employment.requiredPersonnelCount.toString()),
      _buildDetailRow(context, s.requiredEducation, employment.requiredEducation.getTitle()),
    ];
  }

  List<Widget> _getLeaveDetails(final BuildContext context) {
    if (request is! LeaveAttendanceRequestEntity) return [];
    final leave = request as LeaveAttendanceRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, leave.categoryType.getTitle()));
    if (leave.replacementEmployee != null && leave.replacementEmployee!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.replacementEmployee, leave.replacementEmployee!));
    }
    if (leave.hospitalName != null && leave.hospitalName!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.hospitalOrDoctor, leave.hospitalName!));
    }
    if (leave.occasionRelation != null && leave.occasionRelation!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.relationship, leave.occasionRelation!));
    }
    return details;
  }

  List<Widget> _getMissionDetails(final BuildContext context) {
    if (request is! MissionWorkRequestEntity) return [];

    final mission = request as MissionWorkRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, mission.categoryType.getTitle()));
    if (mission.destination != null && mission.destination!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.destination, mission.destination!));
    }
    if (mission.exactLocation != null && mission.exactLocation!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.exactLocation, mission.exactLocation!));
    }
    if (mission.companionNames != null && mission.companionNames!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.companions, mission.companionNames!));
    }
    if (mission.expenseAmount != null && mission.expenseAmount!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.amount, mission.expenseAmount!.toTomanMoney()));
    }
    return details;
  }

  List<Widget> _getWelfareDetails(final BuildContext context) {
    if (request is! WelfareFinancialRequestEntity) return [];

    final welfare = request as WelfareFinancialRequestEntity;
    final details = <Widget>[];
    details.add(_buildDetailRow(context, s.category, welfare.categoryType.getTitle()));
    if (welfare.amount != null && welfare.amount!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.amount, welfare.amount!.toTomanMoney()));
    }
    if (welfare.bankAccountNumber != null && welfare.bankAccountNumber!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.iban, welfare.bankAccountNumber!.ibanFormat()));
    }
    if (welfare.coveredPersonDetails != null && welfare.coveredPersonDetails!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.coveredPersons, welfare.coveredPersonDetails!));
    }
    if (welfare.date != null) {
      details.add(_buildDetailRow(context, s.requiredPaymentDate, welfare.date!));
    }
    return details;
  }

  List<Widget> _getSupportDetails(final BuildContext context) {
    if (request is! SupportProcurementRequestEntity) return [];

    final support = request as SupportProcurementRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, support.categoryType.getTitle()));
    if (support.equipmentType != null) {
      details.add(_buildDetailRow(context, s.equipmentType, support.equipmentType!.getTitle()));
    }
    if (support.quantity != null) {
      details.add(_buildDetailRow(context, s.quantity, support.quantity.toString()));
    }
    if (support.suggestedModel != null && support.suggestedModel!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.suggestedModel, support.suggestedModel!));
    }
    if (support.currentEquipment != null && support.currentEquipment!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.currentEquipment, support.currentEquipment!));
    }
    if (support.problemDescription != null && support.problemDescription!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.exactProblem, support.problemDescription!));
    }
    if (support.date != null && support.date!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.problemDate, support.date!));
    }
    return details;
  }

  List<Widget> _getGeneralDetails(final BuildContext context) {
    if (request is! GeneralRequestEntity) return [];

    final general = request as GeneralRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, general.categoryType.getTitle()));
    if (general.personalInfoType != null) {
      details.add(_buildDetailRow(context, s.informationType, general.personalInfoType!.getTitle()));
    }
    if (general.currentValue != null && general.currentValue!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.currentValue, general.currentValue!));
    }
    if (general.newValue != null && general.newValue!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.newValue, general.newValue!));
    }
    if (general.certificatePurpose != null && general.certificatePurpose!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.certificatePurpose, general.certificatePurpose!));
    }
    if (general.targetOrganizationName != null && general.targetOrganizationName!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.destinationOrganization, general.targetOrganizationName!));
    }
    if (general.introductionSubject != null && general.introductionSubject!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.introductionSubject, general.introductionSubject!));
    }
    if (general.date != null && general.date!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.requiredIssueDate, general.date!));
    }
    return details;
  }

  List<Widget> _getOvertimeDetails(final BuildContext context) {
    if (request is! OvertimeRequestEntity) return [];

    final overtime = request as OvertimeRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, overtime.categoryType.getTitle()));
    details.add(_buildDetailRow(context, s.requestType, overtime.overtimeType.getTitle()));
    if (overtime.date != null) {
      details.add(_buildDetailRow(context, s.date, overtime.date!));
    }
    if (overtime.startTime != null) {
      details.add(_buildDetailRow(context, s.startTime, overtime.startTime!));
    }
    if (overtime.endTime != null) {
      details.add(_buildDetailRow(context, s.endTime, overtime.endTime!));
    }
    return details;
  }

  Widget _buildDetailRow(final BuildContext context, final String label, final String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.hintColor,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.theme.hintColor,
            ),
          ),
        ),
      ],
    );
  }

  String _getStartDateTime() {
    switch (request.categoryType) {
      case RequestCategoryType.leave_attendance:
        if (request is LeaveAttendanceRequestEntity) {
          final leave = request as LeaveAttendanceRequestEntity;
          return '${leave.startDate ?? ''} ${leave.startTime ?? ''}'.trim();
        }
        return '';
      case RequestCategoryType.missions_work:
        if (request is MissionWorkRequestEntity) {
          final mission = request as MissionWorkRequestEntity;
          if (mission.missionType == MissionType.mission_expense_payment) {
            return '';
          }
          return '${mission.startDate ?? ''} ${mission.startTime ?? ''}'.trim();
        }
        return '';
      default:
        return '';
    }
  }

  String _getEndDateTime() {
    switch (request.categoryType) {
      case RequestCategoryType.leave_attendance:
        if (request is LeaveAttendanceRequestEntity) {
          final leave = request as LeaveAttendanceRequestEntity;
          return '${leave.endDate ?? ''} ${leave.endTime ?? ''}'.trim();
        }
        return '';
      case RequestCategoryType.missions_work:
        if (request is MissionWorkRequestEntity) {
          final mission = request as MissionWorkRequestEntity;
          return '${mission.endDate ?? ''} ${mission.endTime ?? ''}'.trim();
        }
        return '';
      default:
        return '';
    }
  }
}
