part of '../../../data.dart';

class WorkShiftReadDto extends Equatable {
  final int? id;
  final String slug;
  final String title;
  final List<YearShiftReadDto> years;
  final int? allowedOvertimeHoursNumber;
  final int? allowedLeaveHoursNumber;
  final int? allowedMissionHoursNumber;
  final int? allowedLeaveEarlyHoursNumber;
  final int? allowedOverdueHoursNumber;

  const WorkShiftReadDto({
    this.id,
    required this.slug,
    required this.title,
    required this.years,
    this.allowedOvertimeHoursNumber,
    this.allowedLeaveHoursNumber,
    this.allowedMissionHoursNumber,
    this.allowedLeaveEarlyHoursNumber,
    this.allowedOverdueHoursNumber,
  });

  WorkShiftReadDto copyWith({
    final String? title,
    final List<YearShiftReadDto>? years,
    final int? allowedOvertimeHoursNumber,
    final int? allowedLeaveHoursNumber,
    final int? allowedMissionHoursNumber,
    final int? allowedLeaveEarlyHoursNumber,
    final int? allowedOverdueHoursNumber,
}) {
    return WorkShiftReadDto(
      id: id,
      slug: slug,
      title: title ?? this.title,
      years: years ?? this.years,
      allowedOvertimeHoursNumber: allowedOvertimeHoursNumber ?? this.allowedOvertimeHoursNumber,
      allowedLeaveHoursNumber: allowedLeaveHoursNumber ?? this.allowedLeaveHoursNumber,
      allowedMissionHoursNumber: allowedMissionHoursNumber ?? this.allowedMissionHoursNumber,
      allowedLeaveEarlyHoursNumber: allowedLeaveEarlyHoursNumber ?? this.allowedLeaveEarlyHoursNumber,
      allowedOverdueHoursNumber: allowedOverdueHoursNumber ?? this.allowedOverdueHoursNumber,
    );
  }

  factory WorkShiftReadDto.fromMap(final Map<String, dynamic> json) {
    return WorkShiftReadDto(
      id: json["id"],
      slug: json["slug"] ?? '',
      title: json["title"] ?? '',
      years: json["years"] == null ? [] : List<YearShiftReadDto>.from(json["years"]!.map((final x) => YearShiftReadDto.fromMap(x))),
      allowedOvertimeHoursNumber: json["allowed_overtime_hours_number"],
      allowedLeaveHoursNumber: json["allowed_leave_hours_number"],
      allowedMissionHoursNumber: json["allowed_mission_hours_number"],
      allowedLeaveEarlyHoursNumber: json["allowed_leave_early_hours_number"],
      allowedOverdueHoursNumber: json["allowed_overdue_hours_number"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        slug,
        title,
        years,
        allowedOvertimeHoursNumber,
        allowedLeaveHoursNumber,
        allowedMissionHoursNumber,
        allowedLeaveEarlyHoursNumber,
        allowedOverdueHoursNumber,
      ];
}
