part of '../../data.dart';

/// مدل پایه‌ای برای تمام حالت‌های پاسخ API بررسی وضعیت شیفت
sealed class ShiftStatusReadDto {
  // فیلدهای مشترک
  final bool shouldOpenModal;
  final AttendanceModalType? modalType;
  final String? message;
  final String uuid;

  final List<AttendanceMethod> allowedMethods;

  bool get isCheckIn => modalType == AttendanceModalType.check_in;

  bool get isCheckOut => modalType == AttendanceModalType.check_out;

  bool get isCheckInOrCheckOut => isCheckIn || isCheckOut;

  const ShiftStatusReadDto({
    required this.shouldOpenModal,
    this.modalType,
    this.message,
    required this.allowedMethods,
    required this.uuid,
  });

  factory ShiftStatusReadDto.fromJson(final String str) => ShiftStatusReadDto.fromMap(json.decode(str));

  factory ShiftStatusReadDto.fromMap(final dynamic json) {
    final modalType = json['modal_type'] == null ? null : AttendanceModalType.values.firstWhereOrNull((final e) => e.name == json['modal_type']);
    final message = json['message'];
    final shouldOpenModal = json['should_open_modal'] ?? false;
    final uuid = json['member_uuid'] ?? '';

    final shiftInfo = json['shift_info'] != null ? ShiftInfo.fromMap(json['shift_info']) : null;

    final List<AttendanceMethod> allowedMethods = json['allowed_check_in_methods'] != null ? (json['allowed_check_in_methods'] as List)
        .map((final item) => AttendanceMethod.values.firstWhereOrNull((final e) => e.name == item))
        .whereType<AttendanceMethod>()
        .toList() : [];

    if (modalType == AttendanceModalType.check_in) {
      return CheckInModal(
        shouldOpenModal: shouldOpenModal,
        modalType: modalType,
        message: message,
        uuid: uuid,
        shiftInfo: shiftInfo,
        timeStatus: json['time_status'] != null ? AttendanceTimeStatus.values.firstWhereOrNull((final e) => e.name == json['time_status']) : null,
        minutesDifference: json['minutes_difference'],
        lateMinutesTotal: json['late_minutes_total'],
        lateMinutesBillable: json['late_minutes_billable'],
        flexMinutesUsed: json['flex_minutes_used'],
        allowedMethods: allowedMethods,
      );
    }

    // حالت: خروج
    if (modalType == AttendanceModalType.check_out) {
      return CheckOutModal(
        shouldOpenModal: shouldOpenModal,
        modalType: modalType,
        message: message,
        uuid: uuid,
        shiftInfo: shiftInfo,
        activeAttendance: json['has_active_session'] == true && json['active_attendance'] != null ? ActiveAttendance.fromMap(json['active_attendance']) : null,
        allowedMethods: allowedMethods,
      );
    }

    return NoData(
      message: message,
      uuid: uuid,
    );
  }
}

/// No Data
class NoData extends ShiftStatusReadDto {
  NoData({required super.message, required super.uuid})
      : super(
    shouldOpenModal: false,
    allowedMethods: [],
  );
}

/// Check-in
class CheckInModal extends ShiftStatusReadDto {
  final ShiftInfo? shiftInfo;
  final AttendanceTimeStatus? timeStatus;
  final int? minutesDifference;
  final int? lateMinutesTotal;
  final int? lateMinutesBillable;
  final int? flexMinutesUsed;

  CheckInModal({
    required super.shouldOpenModal,
    required super.modalType,
    super.message,
    required super.uuid,
    required super.allowedMethods,
    this.shiftInfo,
    this.timeStatus,
    this.minutesDifference,
    this.lateMinutesTotal,
    this.lateMinutesBillable,
    this.flexMinutesUsed,
  });
}

/// Check-out
class CheckOutModal extends ShiftStatusReadDto {
  final ActiveAttendance? activeAttendance;
  final ShiftInfo? shiftInfo;

  CheckOutModal({
    required super.shouldOpenModal,
    required super.modalType,
    super.message,
    required super.uuid,
    required super.allowedMethods,
    this.activeAttendance,
    this.shiftInfo,
  });
}

//
// مدل‌های مشترک
//
class ShiftInfo {
  final int id;
  final String slug;
  final String title;
  final String? startTime;
  final String? endTime;
  final String? breakStart;
  final String? breakEnd;
  final int flexibleStartMinutes;
  final int flexibleEndMinutes;
  final double dailyOvertimeHours;
  final bool hasOffShiftAccess;
  final bool isHoliday;
  final ShiftDay? shiftDay;

  ShiftInfo({
    required this.id,
    required this.slug,
    required this.title,
    this.startTime,
    this.endTime,
    this.breakStart,
    this.breakEnd,
    required this.flexibleStartMinutes,
    required this.flexibleEndMinutes,
    required this.dailyOvertimeHours,
    required this.hasOffShiftAccess,
    required this.isHoliday,
    this.shiftDay,
  });

  factory ShiftInfo.fromMap(final Map<String, dynamic> json) =>
      ShiftInfo(
        id: json['id'] ?? 0,
        slug: json['slug'] ?? '',
        title: json['title'] ?? '',
        startTime: json['start_time'],
        endTime: json['end_time'],
        breakStart: json['break_start'],
        breakEnd: json['break_end'],
        flexibleStartMinutes: json['flexible_start_minutes'] ?? 0,
        flexibleEndMinutes: json['flexible_end_minutes'] ?? 0,
        dailyOvertimeHours: (json['daily_overtime_hours'] as num?)?.toDouble() ?? 0,
        hasOffShiftAccess: json['has_off_shift_access'] ?? false,
        isHoliday: json['is_holiday'] ?? false,
        shiftDay: json['shift_day'] != null ? ShiftDay.fromMap(json['shift_day']) : null,
      );
}

class ShiftDay {
  final int id;
  final String slug;
  final String date;
  final bool isHoliday;

  ShiftDay({
    required this.id,
    required this.slug,
    required this.date,
    required this.isHoliday,
  });

  factory ShiftDay.fromMap(final Map<String, dynamic> json) =>
      ShiftDay(
        id: json['id'] ?? 0,
        slug: json['slug'] ?? '',
        date: json['date'] ?? '',
        isHoliday: json['is_holiday'] ?? false,
      );
}

class ActiveAttendance {
  final int id;
  final DateTime? checkInTime;
  final String? checkInTimeDisplay;
  final int elapsedSeconds;
  final double elapsedHours;
  final double workHours;
  final String status;
  final String mainStatus;
  final int shiftId;
  final int? shiftDayId;

  ActiveAttendance({
    required this.id,
    this.checkInTime,
    this.checkInTimeDisplay,
    required this.elapsedSeconds,
    required this.elapsedHours,
    required this.workHours,
    required this.status,
    required this.mainStatus,
    required this.shiftId,
    this.shiftDayId,
  });

  factory ActiveAttendance.fromMap(final Map<String, dynamic> json) =>
      ActiveAttendance(
        id: json['id'],
        checkInTime: json['check_in_time'] == null ? null : DateTime.tryParse(json['check_in_time']),
        checkInTimeDisplay: json['check_in_time_display'],
        elapsedSeconds: json['elapsed_seconds'] ?? 0,
        elapsedHours: (json['elapsed_hours'] as num?)?.toDouble() ?? 0,
        workHours: (json['work_hours'] as num?)?.toDouble() ?? 0,
        status: json['status'] ?? '',
        mainStatus: json['main_status'] ?? '',
        shiftId: json['shift_id'] ?? 0,
        shiftDayId: json['shift_day_id'],
      );
}
