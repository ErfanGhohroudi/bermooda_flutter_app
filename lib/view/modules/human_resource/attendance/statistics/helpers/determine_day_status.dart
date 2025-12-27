import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/enums/request_enums.dart';
import '../../../../../../data/data.dart';

AttendanceStatus determineDayStatus(final DayAttendanceDataDto? dayData) {
  if (dayData == null) {
    return AttendanceStatus.empty;
  }

  // Check is_absent first
  if (dayData.isAbsent == true) {
    return AttendanceStatus.absent;
  }

  // Check requests for leave
  if (dayData.requests != null && dayData.requests!.isNotEmpty) {
    for (final request in dayData.requests!) {
      if (request.categoryType == RequestCategoryType.leave_attendance) {
        return AttendanceStatus.leave;
      }
      if (request.categoryType == RequestCategoryType.missions_work) {
        return AttendanceStatus.mission;
      }
    }
  }

  // Check attendances
  if (dayData.attendances != null && dayData.attendances!.isNotEmpty) {
    return AttendanceStatus.present;
  }

  return AttendanceStatus.empty;
}
