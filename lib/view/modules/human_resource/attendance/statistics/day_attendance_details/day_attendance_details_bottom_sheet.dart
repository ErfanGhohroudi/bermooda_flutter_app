import 'package:u/utilities.dart';

import '../../../../../../core/utils/extensions/time_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';
import '../../../../requests/widgets/request_card.dart';
import '../../attendance/widgets/attendance_report_item/attendance_report_card.dart';
import '../helpers/determine_day_status.dart';

void showDayAttendanceDetails(
  final Jalali date,
  final DayAttendanceDataDto? dayData,
) {
  bottomSheet(
    title: date.formatToDDmNYYYY,
    childBuilder: (final context) => SingleChildScrollView(
      child: dayData != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusSection(dayData),
                if (dayData.attendances != null && dayData.attendances!.isNotEmpty) _buildAttendancesSection(date, dayData.attendances!),
                if (dayData.attendanceReports != null && dayData.attendanceReports!.isNotEmpty) _buildReportsSection(dayData.attendanceReports!),
                if (dayData.requests != null && dayData.requests!.isNotEmpty) _buildRequestsSection(dayData.requests!),
              ],
            )
          : Text(s.noData),
    ),
  );
}

Widget _buildStatusSection(final DayAttendanceDataDto dayData) {
  final status = determineDayStatus(dayData);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(s.status).bodyLarge(fontWeight: FontWeight.bold),
      const SizedBox(height: 8),
      Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: status.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(status.title),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget _buildAttendancesSection(
  final Jalali date,
  final List<AttendanceDto> attendances,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(s.attendance).bodyLarge(fontWeight: FontWeight.bold),
      const SizedBox(height: 8),
      ...attendances.map((final attendance) => _buildAttendanceCard(date, attendance)),
      const SizedBox(height: 16),
    ],
  );
}

Widget _buildAttendanceCard(
  final Jalali date,
  final AttendanceDto attendance,
) {
  return WCard(
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attendance.startDate != null && attendance.startTime != null)
          Builder(builder: (final context) {
            final isThisDay = attendance.startDate!.toJalali().formatCompactDate().numericOnly().toInt() == date.formatCompactDate().numericOnly().toInt();
            final time = isThisDay ? attendance.startTime! : '${attendance.startDate!.toJalali().formatCompactDate()} ${attendance.startTime}';
            return _buildDetailRow(s.checkIn, time, textDirection: TextDirection.ltr);
          }),
        if (attendance.endDate != null && attendance.endTime != null)
          Builder(builder: (final context) {
            final isThisDay = attendance.endDate!.toJalali().formatCompactDate().numericOnly().toInt() == date.formatCompactDate().numericOnly().toInt();
            final time = isThisDay ? attendance.endTime! : '${attendance.endDate!.toJalali().formatCompactDate()} ${attendance.endTime}';
            return _buildDetailRow(s.checkOut, time, textDirection: TextDirection.ltr);
          }),
        if (attendance.overtime != null) _buildDetailRow(s.overtime, attendance.overtime!),
      ],
    ),
  );
}

Widget _buildReportsSection(final List<AttendanceReportDto> reports) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(s.reports).bodyLarge(fontWeight: FontWeight.bold),
      const SizedBox(height: 8),
      ...reports.map((final report) => WAttendanceReportCard(report: report)),
      const SizedBox(height: 16),
    ],
  );
}

Widget _buildRequestsSection(final List<IRequestReadDto> requests) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(s.requests).bodyLarge(fontWeight: FontWeight.bold),
      const SizedBox(height: 8),
      ...requests.map(
        (final request) => WRequestCard(
          request: request,
          canEdit: false,
          showRequestingUser: false,
          onSelectedNewStatus: (final value) {},
        ),
      ),
    ],
  );
}

Widget _buildDetailRow(final String label, final String value, {final TextDirection? textDirection}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            maxLines: 2,
          ).bodyMedium(fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(value, textDirection: textDirection).bodyMedium(),
        ),
      ],
    ),
  );
}
