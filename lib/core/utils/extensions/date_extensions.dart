import 'package:u/utilities.dart';
import 'package:intl/intl.dart' as intl;

import '../../core.dart';

const List<String> _monthNamesFa = [
  'فروردین',
  'اردیبهشت',
  'خرداد',
  'تیر',
  'مرداد',
  'شهریور',
  'مهر',
  'آبان',
  'آذر',
  'دی',
  'بهمن',
  'اسفند',
];

const List<String> _monthNamesEn = [
  'Farvardin',
  'Ordibehesht',
  'Khordad',
  'Tir',
  'Mordaad',
  'Shahrivar',
  'Mehr',
  'Aabaan',
  'Aazar',
  'Dey',
  'Bahman',
  'Esfand',
];

extension DateExtentions<T> on String? {
  String getJalaliMonthNameFaEn() {
    if (this == null) return '- -';
    if (!isPersianLang) {
      final index = _monthNamesFa.indexOf(this!);
      if (index != -1) {
        return _monthNamesEn[index];
      }
    }
    return this!;
  }

  /// must be 'yyyy/mm/dd' or 'yyyy-mm-dd' format
  Jalali? toJalali() {
    if (this == null || this?.trim() == '') return null;
    final containsSlash = this?.trim().contains('/') ?? false;
    final list = this!.trim().split(containsSlash ? '/' : '-');
    if (list.length == 3 && list.join('').isNumericOnly) {
      return Jalali(int.tryParse(list[0]) ?? 0, int.tryParse(list[1]) ?? 0, int.tryParse(list[2]) ?? 0);
    }
    return null;
  }
}

extension DateTimeExtentions<T> on DateTime? {
  /// Converts a nullable [DateTime] to a compact ISO-8601 date string.
  ///
  /// The returned string follows the `yyyy-MM-dd` format (e.g. `2025-12-02`).
  /// This format is commonly used for sending date values to Back-End services
  /// that expect an ISO-8601–compliant date representation **without time information**.
  ///
  /// Returns `null` if the [DateTime] instance is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2025, 12, 2);
  /// print(date.toCompactIso8601); // "2025-12-02"
  ///
  /// DateTime? nullDate;
  /// print(nullDate.toCompactIso8601); // null
  /// ```
  String? get toCompactIso8601 {
    if (this == null) return null;
    final formatter = intl.DateFormat('yyyy-MM-dd', 'en_US');
    final formattedDate = formatter.format(this!);
    return formattedDate;
  }

  /// Converts a nullable [DateTime] to a Jalali date-time string.
  ///
  /// The returned string follows the format `yyyy/MM/dd HH:mm`, where the
  /// date portion comes from the Jalali (Persian) calendar and the time portion
  /// is derived from the original [DateTime] object.
  ///
  /// Returns `null` if the [DateTime] instance is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2025, 3, 15, 14, 5); // 2025-03-15 14:05
  /// print(date.toJalaliDateTimeString); // "1403/12/24 14:05"
  ///
  /// DateTime? nullDate;
  /// print(nullDate.toJalaliDateTimeString); // null
  /// ```
  String get toJalaliDateTimeString {
    if (this == null) return '';
    final jalaliDate = Jalali.fromDateTime(this!);
    final f = jalaliDate.formatter;
    final hour = this!.hour.toString().padLeft(2, '0');
    final minute = this!.minute.toString().padLeft(2, '0');
    return '${f.yyyy}/${f.mm}/${f.dd} $hour:$minute';
  }

  /// Converts a nullable [DateTime] to a Jalali date string.
  ///
  /// The returned string follows the format `yyyy/MM/dd`, where the
  /// entire date is expressed in the Jalali (Persian) calendar.
  /// Unlike [toJalaliDateTimeString], this method does not include time information.
  ///
  /// Returns `null` if the [DateTime] instance is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2025, 3, 15); // 2025-03-15
  /// print(date.toJalaliDateString); // "1403/12/24"
  ///
  /// DateTime? nullDate;
  /// print(nullDate.toJalaliDateString); // null
  /// ```
  String? get toJalaliDateString {
    if (this == null) return null;
    final jalaliDate = Jalali.fromDateTime(this!);
    final formatter = jalaliDate.formatter;
    return '${formatter.yyyy}/${formatter.mm}/${formatter.dd}';
  }
}
