part of '../../../data.dart';

/// Leave and Attendance Request Parameters
class LeaveAttendanceRequestParams extends BaseRequestParams {
  const LeaveAttendanceRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
    required this.leaveType,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.replacementEmployee,
    this.sickLeaveType,
    this.hospitalName,
    this.occasionType,
    this.occasionRelation,
    this.leaveReason,
    this.files,
  });

  final LeaveType leaveType;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final String? replacementEmployee;
  final SickLeaveType? sickLeaveType;
  final String? hospitalName;
  final CeremonialLeaveType? occasionType;
  final String? occasionRelation;
  final HourlyLeaveReason? leaveReason;
  final List<MainFileReadDto>? files;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.leave_attendance;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    final fileIds = files?.map((final e) => e.fileId).whereType<int>().toList();

    switch (leaveType) {
      case LeaveType.entitlement_leave:
        return {
          ...baseMap,
          'subcategory': leaveType.name,
          'leave_start_date': startDate,
          'leave_end_date': endDate,
          'replacement_employee': replacementEmployee,
        };

      case LeaveType.sick_leave:
        return {
          ...baseMap,
          'subcategory': leaveType.name,
          'leave_start_date': startDate,
          'leave_end_date': endDate,
          'sick_leave_type': sickLeaveType?.name,
          'hospital_or_doctor': hospitalName,
          'doctor_certificate_id_list': fileIds,
        };

      case LeaveType.unpaid_leave:
        return {
          ...baseMap,
          'subcategory': leaveType.name,
          'leave_start_date': startDate,
          'leave_end_date': endDate,
          'unpaid_replacement_employee': replacementEmployee,
        };

      case LeaveType.hourly_leave:
        return {
          ...baseMap,
          'subcategory': leaveType.name,
          'hourly_leave_date': startDate,
          'hourly_start_time': startTime,
          'hourly_end_time': endTime,
          'hourly_reason': leaveReason?.name,
        };

      case LeaveType.special_occasion_leave:
        return {
          ...baseMap,
          'subcategory': leaveType.name,
          'leave_date': startDate,
          'special_occasion_type': occasionType?.name,
          'leave_start_date': startDate,
          'leave_end_date': endDate,
          'occasion_relationship': occasionRelation,
          'proof_document_id_list': fileIds,
        };
    }
  }
}
