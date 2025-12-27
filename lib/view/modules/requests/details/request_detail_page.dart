import 'package:u/utilities.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/extensions/money_extensions.dart';
import '../../../../core/utils/extensions/request_extensions.dart';
import '../../../../core/widgets/image_files.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../core/events/request_event_bus.dart';
import '../../../../data/data.dart';
import '../widgets/reviewers_list.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({
    required this.request,
    required this.onTapRequestCheckBox,
    this.showRequestingUser = false,
    this.canEdit = true,
    super.key,
  });

  final IRequestReadDto request;
  final ValueChanged<bool> onTapRequestCheckBox;
  final bool showRequestingUser;
  final bool canEdit;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late IRequestReadDto _currentRequest;
  late StreamSubscription<IRequestReadDto> _requestSubscription;

  @override
  void initState() {
    super.initState();
    _currentRequest = widget.request;

    // اطمینان از باز بودن Event Bus
    final eventBus = RequestEventBus();
    if (eventBus.isClosed) {
      eventBus.restart();
    }

    // گوش دادن به Event Bus
    _requestSubscription = eventBus.requestUpdatedStream.listen((final updatedRequest) {
      // بررسی اینکه آیا request به‌روزرسانی شده همان request فعلی است
      if (updatedRequest.slug == _currentRequest.slug) {
        setState(() {
          _currentRequest = updatedRequest;
        });
      }
    });
  }

  @override
  void dispose() {
    _requestSubscription.cancel();
    RequestEventBus().dispose();
    super.dispose();
  }

  bool get showReviewers => _currentRequest.reviewerUsers.isNotEmpty;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentRequest.getTitle())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            // Status Card
            _buildStatusCard(context),

            // Reviewers Card
            if (showReviewers) _buildReviewersCard(context),

            // Request Type Card
            _buildRequestTypeCard(context),

            // Requesting User
            if (widget.showRequestingUser) _buildRequestingUser(context),

            // Description Card
            if (_currentRequest.description != null && _currentRequest.description!.isNotEmpty) _buildDescriptionCard(context),

            // Request Specific Details
            _buildRequestSpecificDetails(context),

            // Date and Time Information
            _buildDateTimeCard(context),

            // Files Card
            _buildFilesCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestingUser(final BuildContext context) {
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(s.applicant).titleMedium().bold(),
          WCircleAvatar(
            user: _currentRequest.requestingUser,
            showFullName: true,
            size: 35,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(final BuildContext context) {
    return WCard(
      child: Row(
        spacing: 12,
        children: [
          UImage(
            AppIcons.info,
            color: _currentRequest.status?.color ?? context.theme.hintColor,
            size: 25,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(s.status).titleMedium().bold(),
                Text(
                  _currentRequest.status?.getTitle() ?? s.noData,
                ).bodyMedium(color: _currentRequest.status?.color ?? context.theme.hintColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewersCard(final BuildContext context) {
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(s.reviewers).titleMedium().bold(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: WReviewersList(
              reviewers: _currentRequest.reviewerUsers,
              currentReviewer: _currentRequest.currentReviewer,
              onTapRequestCheckBox: widget.onTapRequestCheckBox,
              canEdit: widget.canEdit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTypeCard(final BuildContext context) {
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 12,
            children: [
              UImage(
                _currentRequest.getIcon(),
                size: 24,
                color: context.theme.hintColor,
              ),
              Text(s.requestType).titleMedium().bold(),
            ],
          ),
          Text(_currentRequest.getTitle()).titleMedium(),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(final BuildContext context) {
    return WCard(
      child: SizedBox(
        width: context.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(s.description).titleMedium().bold(),
            Text(_currentRequest.description!).bodyMedium(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestSpecificDetails(final BuildContext context) {
    final details = _getRequestSpecificDetails(context);
    if (details.isEmpty) return const SizedBox.shrink();

    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(s.details).titleMedium().bold(),
          ...details,
        ],
      ),
    );
  }

  Widget _buildDateTimeCard(final BuildContext context) {
    final startDateTime = _getStartDateTime();
    final endDateTime = _getEndDateTime();

    if (startDateTime.isEmpty && endDateTime.isEmpty) {
      return const SizedBox.shrink();
    }

    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.scheduling).titleMedium().bold(),
          const SizedBox(height: 16),
          if (startDateTime.isNotEmpty) _buildDateTimeRow(context, _getDateTitle(), startDateTime, Icons.play_arrow_rounded),
          if (startDateTime.isNotEmpty && endDateTime.isNotEmpty) const SizedBox(height: 12),
          if (endDateTime.isNotEmpty) _buildDateTimeRow(context, s.end, endDateTime, Icons.stop_rounded),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow(final BuildContext context, final String label, final String value, final IconData icon) {
    return Row(
      spacing: 12,
      children: [
        Icon(
          icon,
          size: 20,
          color: context.theme.hintColor,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label).bodySmall(color: context.theme.hintColor),
              Text(value).bodyMedium(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilesCard(final BuildContext context) {
    final files = _getRequestFiles();
    if (files.isEmpty) return const SizedBox.shrink();

    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(s.attachments).titleMedium().bold(),
          WImageFiles(
            files: files,
            showUploadWidget: false,
            removable: false,
            onFilesUpdated: (final uploadedFiles) {},
            uploadingFileStatus: (final value) {},
          ),
        ],
      ),
    );
  }

  List<Widget> _getRequestSpecificDetails(final BuildContext context) {
    switch (_currentRequest.categoryType) {
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
    if (_currentRequest is! EmploymentRequestEntity) return [];

    final employment = _currentRequest as EmploymentRequestEntity;
    return [
      _buildDetailRow(context, s.category, employment.categoryType.getTitle()),
      _buildDetailRow(context, s.requestType, employment.cooperationType.getTitle()),
      if (employment.workloadType != null && employment.cooperationType != EmploymentCooperationType.outsourcing)
        _buildDetailRow(context, s.workload, employment.workloadType!.getTitle()),
      _buildDetailRow(context, s.jobTitle, employment.jobTitle),
      _buildDetailRow(context, s.jobSummary, employment.jobSummary),
      _buildDetailRow(context, s.mainResponsibilities, employment.mainResponsibilities.join(', ')),
      _buildDetailRow(context, s.organizationalUnit, employment.organizationalUnit),
      _buildDetailRow(context, s.reportsTo, employment.reportsTo),
      _buildDetailRow(context, s.workLocation, employment.workLocation.getTitle()),
      _buildDetailRow(context, s.requiredPersonnelCount, employment.requiredPersonnelCount.toString()),
      _buildDetailRow(context, s.requiredEducation, employment.requiredEducation.getTitle()),
      if (employment.preferredFieldOfStudy != null && employment.preferredFieldOfStudy!.isNotEmpty)
        _buildDetailRow(context, s.preferredFieldOfStudy, employment.preferredFieldOfStudy!),
      if (employment.minimumExperience != null) _buildDetailRow(context, s.minimumWorkExperience, employment.minimumExperience.toString()),
      if (employment.technicalSkills != null && employment.technicalSkills!.isNotEmpty)
        _buildDetailRow(context, s.technicalSkills, employment.technicalSkills!.join(', ')),
      if (employment.softSkills != null && employment.softSkills!.isNotEmpty) _buildDetailRow(context, s.softSkills, employment.softSkills!.join(', ')),
      if (employment.requiredLanguages != null && employment.requiredLanguages!.isNotEmpty)
        _buildDetailRow(context, s.requiredLanguage, employment.requiredLanguages!.join(', ')),
    ];
  }

  List<Widget> _getLeaveDetails(final BuildContext context) {
    if (_currentRequest is! LeaveAttendanceRequestEntity) return [];

    final leave = _currentRequest as LeaveAttendanceRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, leave.categoryType.getTitle()));
    details.add(_buildDetailRow(context, s.requestType, leave.leaveType.getTitle()));
    if (leave.sickLeaveType != null) {
      details.add(_buildDetailRow(context, s.diseaseType, leave.sickLeaveType?.getTitle() ?? ''));
    }
    if (leave.occasionType != null) {
      details.add(_buildDetailRow(context, s.occasionType, leave.occasionType?.getTitle() ?? ''));
    }
    if (leave.leaveReason != null) {
      details.add(_buildDetailRow(context, s.requestReason, leave.leaveReason?.getTitle() ?? ''));
    }
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
    if (_currentRequest is! MissionWorkRequestEntity) return [];

    final mission = _currentRequest as MissionWorkRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, mission.categoryType.getTitle()));
    details.add(_buildDetailRow(context, s.requestType, mission.missionType.getTitle()));
    if (mission.destination != null && mission.destination!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.destination, mission.destination!));
    }
    if (mission.exactLocation != null && mission.exactLocation!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.exactLocation, mission.exactLocation!));
    }
    if (mission.missionPurpose != null) {
      details.add(_buildDetailRow(context, s.missionPurpose, mission.missionPurpose?.getTitle() ?? ''));
    }
    if (mission.transportationType != null) {
      details.add(_buildDetailRow(context, s.transportationType, mission.transportationType?.getTitle() ?? ''));
    }
    if (mission.needsAccommodation != null) {
      details.add(_buildDetailRow(context, s.needsAccommodation, mission.needsAccommodation == true ? s.yes : s.no));
    }
    if (mission.needsAccommodation == true && mission.accommodationType != null) {
      details.add(_buildDetailRow(context, s.accommodationType, mission.accommodationType?.getTitle() ?? ''));
    }
    if (mission.companionNames != null && mission.companionNames!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.companions, mission.companionNames!));
    }
    // MissionType.mission_expense_payment
    if (mission.relatedMissionNumber != null && mission.relatedMissionNumber!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.relatedMissionNumber, mission.relatedMissionNumber!));
    }
    if (mission.expenseType != null) {
      details.add(_buildDetailRow(context, s.expenseType, mission.expenseType?.getTitle() ?? ''));
    }
    if (mission.startDate != null && mission.startDate!.isNotEmpty && mission.missionType == MissionType.mission_expense_payment) {
      details.add(_buildDetailRow(context, s.expenseDate, mission.startDate!));
    }
    if (mission.expenseAmount != null && mission.expenseAmount!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.amount, mission.expenseAmount!.toTomanMoney()));
    }
    if (mission.paymentMethod != null) {
      details.add(_buildDetailRow(context, s.paymentMethod, mission.paymentMethod?.getTitle() ?? ''));
    }
    return details;
  }

  List<Widget> _getWelfareDetails(final BuildContext context) {
    if (_currentRequest is! WelfareFinancialRequestEntity) return [];

    final welfare = _currentRequest as WelfareFinancialRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, welfare.categoryType.getTitle()));
    details.add(_buildDetailRow(context, s.welfareType, welfare.welfareType.getTitle()));
    if (welfare.requestTypeFinancial != null) {
      details.add(_buildDetailRow(context, s.requestType, welfare.requestTypeFinancial?.getTitle() ?? ''));
    }
    if (welfare.insuranceRequestType != null) {
      details.add(_buildDetailRow(context, s.requestType, welfare.insuranceRequestType?.getTitle() ?? ''));
    }
    if (welfare.allowanceType != null) {
      details.add(_buildDetailRow(context, s.allowanceType, welfare.allowanceType?.getTitle() ?? ''));
    }
    if (welfare.allowancePeriod != null) {
      details.add(_buildDetailRow(context, s.period, welfare.allowancePeriod?.getTitle() ?? ''));
    }
    if (welfare.amount != null && welfare.amount!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.amount, welfare.amount!.toTomanMoney()));
    }
    if (welfare.bankAccountNumber != null && welfare.bankAccountNumber!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.iban, welfare.bankAccountNumber!.ibanFormat()));
    }
    if (welfare.repaymentMethod != null) {
      details.add(_buildDetailRow(context, s.repaymentConditions, welfare.repaymentMethod?.getTitle() ?? ''));
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
    if (_currentRequest is! SupportProcurementRequestEntity) return [];

    final support = _currentRequest as SupportProcurementRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, support.categoryType.getTitle()));
    details.add(_buildDetailRow(context, s.requestType, support.supportType.getTitle()));
    if (support.equipmentType != null) {
      details.add(_buildDetailRow(context, s.equipmentType, support.equipmentType!.getTitle()));
    }
    if (support.supplyType != null && support.supplyType!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.itemType, support.supplyType!));
    }
    if (support.quantity != null) {
      details.add(_buildDetailRow(context, s.quantity, support.quantity.toString()));
    }
    if (support.suggestedModel != null && support.suggestedModel!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.suggestedModel, support.suggestedModel!));
    }
    if (support.urgencyLevel != null) {
      details.add(_buildDetailRow(context, s.urgency, support.urgencyLevel?.getTitle() ?? ''));
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
    if (_currentRequest is! GeneralRequestEntity) return [];

    final general = _currentRequest as GeneralRequestEntity;
    final details = <Widget>[];

    details.add(_buildDetailRow(context, s.category, general.categoryType.getTitle()));
    details.add(_buildDetailRow(context, s.requestType, general.generalType.getTitle()));
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
    if (general.certificateLanguage != null) {
      details.add(_buildDetailRow(context, s.requiredLanguage, general.certificateLanguage?.getTitle() ?? ''));
    }
    if (general.targetOrganizationName != null && general.targetOrganizationName!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.destinationOrganization, general.targetOrganizationName!));
    }
    if (general.targetOrganizationAddress != null && general.targetOrganizationAddress!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.organizationAddress, general.targetOrganizationAddress!));
    }
    if (general.introductionSubject != null && general.introductionSubject!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.introductionSubject, general.introductionSubject!));
    }
    if (general.date != null && general.date!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.requiredIssueDate, general.date!));
    }
    if (general.includeSalary != null) {
      details.add(_buildDetailRow(context, s.includeSalary, general.includeSalary == true ? s.yes : s.no));
    }
    if (general.includePosition != null) {
      details.add(_buildDetailRow(context, s.includePosition, general.includePosition == true ? s.yes : s.no));
    }
    if (general.specialDetails != null && general.specialDetails!.isNotEmpty) {
      details.add(_buildDetailRow(context, s.specialSpecifications, general.specialDetails!));
    }
    return details;
  }

  List<Widget> _getOvertimeDetails(final BuildContext context) {
    if (_currentRequest is! OvertimeRequestEntity) return [];

    final overtime = _currentRequest as OvertimeRequestEntity;
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
      spacing: 5,
      children: [
        Expanded(
          flex: 2,
          child: Text('$label:').bodyMedium(color: context.theme.hintColor).bold(),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: context.textTheme.bodyMedium,
          ).bodyMedium(),
        ),
      ],
    );
  }

  String _getDateTitle() {
    switch (_currentRequest.categoryType) {
      case RequestCategoryType.leave_attendance:
        if (_currentRequest is LeaveAttendanceRequestEntity) {
          return s.start;
        }
        return s.start;
      case RequestCategoryType.missions_work:
        if (_currentRequest is MissionWorkRequestEntity) {
          final mission = _currentRequest as MissionWorkRequestEntity;
          if (mission.missionType == MissionType.mission_expense_payment) {
            return s.expenseDate;
          }
          return s.start;
        }
        return s.start;
      case RequestCategoryType.welfare_financial:
        if (_currentRequest is WelfareFinancialRequestEntity) {
          return s.requiredPaymentDate;
        }
        return s.start;
      case RequestCategoryType.support_logistics:
        if (_currentRequest is SupportProcurementRequestEntity) {
          return s.problemDate;
        }
        return s.start;
      case RequestCategoryType.general_requests:
        if (_currentRequest is GeneralRequestEntity) {
          return s.requiredIssueDate;
        }
        return s.start;
      default:
        return s.start;
    }
  }

  String _getStartDateTime() {
    switch (_currentRequest.categoryType) {
      case RequestCategoryType.leave_attendance:
        if (_currentRequest is LeaveAttendanceRequestEntity) {
          final leave = _currentRequest as LeaveAttendanceRequestEntity;
          return '${leave.startDate ?? ''} ${leave.startTime ?? ''}'.trim();
        }
        return '';
      case RequestCategoryType.missions_work:
        if (_currentRequest is MissionWorkRequestEntity) {
          final mission = _currentRequest as MissionWorkRequestEntity;
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
    switch (_currentRequest.categoryType) {
      case RequestCategoryType.leave_attendance:
        if (_currentRequest is LeaveAttendanceRequestEntity) {
          final leave = _currentRequest as LeaveAttendanceRequestEntity;
          return '${leave.endDate ?? ''} ${leave.endTime ?? ''}'.trim();
        }
        return '';
      case RequestCategoryType.missions_work:
        if (_currentRequest is MissionWorkRequestEntity) {
          final mission = _currentRequest as MissionWorkRequestEntity;
          if (mission.missionType == MissionType.mission_expense_payment) {
            return '';
          }
          return '${mission.endDate ?? ''} ${mission.endTime ?? ''}'.trim();
        }
        return '';
      default:
        return '';
    }
  }

  List<MainFileReadDto> _getRequestFiles() {
    switch (_currentRequest.categoryType) {
      case RequestCategoryType.leave_attendance:
        if (_currentRequest is LeaveAttendanceRequestEntity) {
          return (_currentRequest as LeaveAttendanceRequestEntity).files ?? [];
        }
        return [];
      case RequestCategoryType.missions_work:
        if (_currentRequest is MissionWorkRequestEntity) {
          return (_currentRequest as MissionWorkRequestEntity).files ?? [];
        }
        return [];
      case RequestCategoryType.welfare_financial:
        if (_currentRequest is WelfareFinancialRequestEntity) {
          return (_currentRequest as WelfareFinancialRequestEntity).files ?? [];
        }
        return [];
      case RequestCategoryType.support_logistics:
        if (_currentRequest is SupportProcurementRequestEntity) {
          return (_currentRequest as SupportProcurementRequestEntity).files ?? [];
        }
        return [];
      case RequestCategoryType.general_requests:
        if (_currentRequest is GeneralRequestEntity) {
          return (_currentRequest as GeneralRequestEntity).files ?? [];
        }
        return [];
      default:
        return [];
    }
  }
}
