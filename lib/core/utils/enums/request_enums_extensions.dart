import 'package:u/utilities.dart';

import '../../core.dart';
import 'request_enums.dart';

extension RxLeaveTypeExtentions<T> on Rx<LeaveType> {
  bool isEntitledLeave() => value == LeaveType.entitlement_leave;

  bool isHourlyLeave() => value == LeaveType.hourly_leave;

  bool isSickLeave() => value == LeaveType.sick_leave;

  bool isUnpaidLeave() => value == LeaveType.unpaid_leave;

  bool isCeremonialLeave() => value == LeaveType.special_occasion_leave;
}

extension LeaveTypeExtentions<T> on LeaveType? {
  bool isEntitledLeave() => this == LeaveType.entitlement_leave;

  bool isHourlyLeave() => this == LeaveType.hourly_leave;

  bool isSickLeave() => this == LeaveType.sick_leave;

  bool isUnpaidLeave() => this == LeaveType.unpaid_leave;

  bool isCeremonialLeave() => this == LeaveType.special_occasion_leave;

  String getTitle({final String? str}) => this == null
      ? str ?? ''
      : (!isPersianLang ? this!.title : this!.titleTr1);
}

extension RequestTypeExtentions<T> on RequestCategoryType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension MissionTypeExtentions<T> on MissionType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension LeaveTypeExtentionsNew<T> on LeaveType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension SickLeaveTypeExtentions<T> on SickLeaveType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension HourlyLeaveReasonExtentions<T> on HourlyLeaveReason {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension CeremonialLeaveTypeExtentions<T> on CeremonialLeaveType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension MissionPurposeExtentions<T> on MissionPurpose {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension TransportationTypeExtentions<T> on TransportationType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension AccommodationTypeExtentions<T> on AccommodationType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension ExpenseTypeExtentions<T> on ExpenseType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension PaymentMethodExtentions<T> on PaymentMethod {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension LoanTypeExtentions<T> on LoanType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension RepaymentTypeExtentions<T> on RepaymentType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension InsuranceRequestTypeExtentions<T> on InsuranceRequestType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension AllowanceTypeExtentions<T> on AllowanceType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension AllowancePeriodExtentions<T> on AllowancePeriod {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension EquipmentTypeExtentions<T> on EquipmentType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension UrgencyLevelExtentions<T> on UrgencyLevel {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension RepairTypeExtentions<T> on RepairType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension PersonalInfoTypeExtentions<T> on PersonalInfoType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension CertificateLanguageExtentions<T> on CertificateLanguage {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension WelfareTypeExtentions<T> on WelfareType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension SupportTypeExtentions<T> on SupportType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension GeneralTypeExtentions<T> on GeneralType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension EmploymentCooperationTypeExtentions<T> on EmploymentCooperationType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension WorkloadTypeExtentions<T> on WorkloadType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension OvertimeTypeExtentions<T> on OvertimeType {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension EmploymentWorkLocationExtentions<T> on EmploymentWorkLocation {
  String getTitle() => !isPersianLang ? title : titleTr1;
}

extension StatusTypeExtentions<T> on StatusType {
  String getTitle() => !isPersianLang ? title : titleTr1;

  bool isPending() => this == StatusType.pending || this == StatusType.pending_to_users;

  bool isRejected() => this == StatusType.rejected;

  bool isApproved() => this == StatusType.approved;
}

extension StatusFilterExtentions<T> on StatusFilter {
  String getTitle() => !isPersianLang ? title : titleTr1;
}
