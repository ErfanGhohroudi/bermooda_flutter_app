part of '../../../data.dart';

class TimesheetReadDto {
  TimesheetReadDto({
    this.membershipDate,
    this.totalAttendanceSecond,
    this.remainingAttendanceSecond,
    this.totalLeaveSecond,
    this.remainingLeaveSecond,
    this.totalAbsenceSecond,
    this.totalMissionSecond,
    this.totalTardinessSecond,
    this.totalOvertimeSecond,
  });

  Jalali? membershipDate;
  int? totalAttendanceSecond;
  int? remainingAttendanceSecond;
  int? totalLeaveSecond;
  int? remainingLeaveSecond;
  int? totalAbsenceSecond;
  int? totalMissionSecond;
  int? totalTardinessSecond;
  int? totalOvertimeSecond;

  factory TimesheetReadDto.fromJson(final String str) => TimesheetReadDto.fromMap(json.decode(str));

  factory TimesheetReadDto.fromMap(final Map<String, dynamic> json) => TimesheetReadDto(
        membershipDate: json["membership_date"]?.toString().toJalali(),
        totalAttendanceSecond: json["total_attendance_second"],
        remainingAttendanceSecond: json["remaining_activity"],
        totalLeaveSecond: json["total_leave_second"],
        remainingLeaveSecond: json["remaining_leave"],
        totalAbsenceSecond: json["total_absence_second"],
        totalMissionSecond: json["total_mission_second"],
        totalTardinessSecond: json["total_delay_time"],
        totalOvertimeSecond: json["total_overtime"],
      );
}
