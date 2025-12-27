import '../../theme.dart';
import '../enums/request_enums_extensions.dart';
import '../../../data/data.dart';
import '../enums/request_enums.dart';

extension RequestExtensions on IRequestReadDto {
  String getTitle() {
    switch (categoryType) {
      case RequestCategoryType.leave_attendance:
        if (this is LeaveAttendanceRequestEntity) {
          return (this as LeaveAttendanceRequestEntity).leaveType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      case RequestCategoryType.missions_work:
        if (this is MissionWorkRequestEntity) {
          return (this as MissionWorkRequestEntity).missionType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      case RequestCategoryType.employment:
        if (this is EmploymentRequestEntity) {
          return (this as EmploymentRequestEntity).cooperationType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      case RequestCategoryType.welfare_financial:
        if (this is WelfareFinancialRequestEntity) {
          return (this as WelfareFinancialRequestEntity).welfareType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      case RequestCategoryType.support_logistics:
        if (this is SupportProcurementRequestEntity) {
          return (this as SupportProcurementRequestEntity).supportType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      case RequestCategoryType.general_requests:
        if (this is GeneralRequestEntity) {
          return (this as GeneralRequestEntity).generalType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      case RequestCategoryType.overtime:
        if (this is OvertimeRequestEntity) {
          return (this as OvertimeRequestEntity).overtimeType.getTitle();
        }
        return categoryType?.getTitle() ?? '';
      default:
        return categoryType?.getTitle() ?? '';
    }
  }

  String getIcon() {
    switch (categoryType) {
      case RequestCategoryType.leave_attendance:
        return AppIcons.leaveOutline;
      case RequestCategoryType.missions_work:
        return AppIcons.missionOutline;
      case RequestCategoryType.employment:
        return AppIcons.userOutline;
      case RequestCategoryType.overtime:
        return AppIcons.timerOutline;
      case RequestCategoryType.welfare_financial:
        return AppIcons.dollarOutline;
      case RequestCategoryType.support_logistics:
        return AppIcons.briefcaseOutline;
      case RequestCategoryType.general_requests:
        return AppIcons.fileOutline;
      default:
        return AppIcons.fileOutline;
    }
  }
}