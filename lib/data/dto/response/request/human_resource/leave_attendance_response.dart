part of '../../../../data.dart';

/// Leave and Attendance Response Parameters
class LeaveAttendanceRequestEntity extends BaseResponseParams {
  LeaveAttendanceRequestEntity({
    super.slug,
    super.currentReviewer,
    super.requestingUser,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
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

  factory LeaveAttendanceRequestEntity.fromJson(final String str) => LeaveAttendanceRequestEntity.fromMap(json.decode(str));

  factory LeaveAttendanceRequestEntity.fromMap(final Map<String, dynamic> json) => LeaveAttendanceRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers:
            json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.leave_attendance,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        leaveType: LeaveType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? LeaveType.entitlement_leave,
        startDate: json["leave_start_date"] ?? json["leave_date"] ?? json["hourly_leave_date"],
        endDate: json["leave_end_date"],
        startTime: json["hourly_start_time"],
        endTime: json["hourly_end_time"],
        replacementEmployee: json["replacement_employee"] ?? json["unpaid_replacement_employee"],
        sickLeaveType: json["sick_leave_type"] == null ? null : SickLeaveType.values.firstWhereOrNull((final e) => e.name == json["sick_leave_type"]),
        hospitalName: json["hospital_or_doctor"],
        occasionType: json["special_occasion_type"] == null ? null : CeremonialLeaveType.values.firstWhereOrNull((final e) => e.name == json["special_occasion_type"]),
        occasionRelation: json["occasion_relationship"],
        leaveReason: json["hourly_reason"] == null ? null : HourlyLeaveReason.values.firstWhereOrNull((final e) => e.name == json["hourly_reason"]),
        files: _extractFiles(json),
      );

  static List<MainFileReadDto>? _extractFiles(final Map<String, dynamic> json) {
    if (json["doctor_certificate"] != null && json["doctor_certificate"] != []) {
      return List<MainFileReadDto>.from(json["doctor_certificate"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    if (json["proof_document"] != null && json["proof_document"] != []) {
      return List<MainFileReadDto>.from(json["proof_document"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    return null;
  }

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
