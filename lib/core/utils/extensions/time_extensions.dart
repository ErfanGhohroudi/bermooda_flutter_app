import 'package:bermooda_business/core/utils/extensions/date_extensions.dart';
import 'package:u/utilities.dart';

extension ConvertSecondsExtentions<T> on int {
  /// Example:
  /// ```dart
  /// print("60".toHoursMinutesSecondsFormat); // "00:01:00"
  /// ```
  String get toHoursMinutesSecondsFormat {
    final d = Duration(seconds: this);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = _twoDigits(d.inMinutes % 60);
    final s = _twoDigits(d.inSeconds % 60);
    return "$h:$m:$s";
  }
}

extension ConvertHoursDoubleExtentions<T> on double {
  /// Example:
  /// ```dart
  /// print((5.5).formatHoursToHHMM); // "05:30"
  /// ```
  String get formatHoursToHHMM {
    // تبدیل به دقیقه کل
    int totalMinutes = (this * 60).round();

    // محاسبه ساعت و دقیقه
    int hourPart = totalMinutes ~/ 60;
    int minutePart = totalMinutes % 60;

    // فرمت دو رقمی
    String formattedHour = _twoDigits(hourPart);
    String formattedMinute = _twoDigits(minutePart);

    return '$formattedHour:$formattedMinute';
  }
}

extension ConvertJalaliExtentions<T> on Jalali {
  /// Example:
  /// ```dart
  /// print(Jalali.now().formatToHHMM); // "05:30"
  /// ```
  String get formatToHHMM {
    String formattedHour = _twoDigits(hour);
    String formattedMinute = _twoDigits(minute);

    return '$formattedHour:$formattedMinute';
  }

  /// Example:
  /// ```dart
  /// print(Jalali.now().formatToHHMM); // "5 january 1404"
  /// ```
  String get formatToDDmNYYYY {
    return '$day ${formatter.mN.getJalaliMonthNameFaEn()} $year';
  }
}

String _twoDigits(final int n) {
  return '$n'.padLeft(2, '0');
}
