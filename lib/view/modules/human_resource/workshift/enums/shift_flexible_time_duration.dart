import 'package:u/utilities.dart';

import '../../../../../core/core.dart';

enum ShiftFlexibleTimeDuration {
  tenMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  twoHour;

  static ShiftFlexibleTimeDuration? fromString(final String? value) {
    switch (value) {
      case '00:10:00':
        return ShiftFlexibleTimeDuration.tenMinutes;
      case '00:15:00':
        return ShiftFlexibleTimeDuration.fifteenMinutes;
      case '00:30:00':
        return ShiftFlexibleTimeDuration.thirtyMinutes;
      case '01:00:00':
        return ShiftFlexibleTimeDuration.oneHour;
      case '02:00:00':
        return ShiftFlexibleTimeDuration.twoHour;
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case ShiftFlexibleTimeDuration.tenMinutes:
        return '00:10:00';
      case ShiftFlexibleTimeDuration.fifteenMinutes:
        return '00:15:00';
      case ShiftFlexibleTimeDuration.thirtyMinutes:
        return '00:30:00';
      case ShiftFlexibleTimeDuration.oneHour:
        return '01:00:00';
      case ShiftFlexibleTimeDuration.twoHour:
        return '02:00:00';
    }
  }

  String get title {
    switch(this) {
      case ShiftFlexibleTimeDuration.tenMinutes:
        return "10 ${s.minutes}";
      case ShiftFlexibleTimeDuration.fifteenMinutes:
        return "15 ${s.minutes}";
      case ShiftFlexibleTimeDuration.thirtyMinutes:
        return "30 ${s.minutes}";
      case ShiftFlexibleTimeDuration.oneHour:
        return "1 ${isPersianLang ? s.hours : s.hours.removeLast()}";
      case ShiftFlexibleTimeDuration.twoHour:
        return "2 ${s.hours}";
    }
  }
}
