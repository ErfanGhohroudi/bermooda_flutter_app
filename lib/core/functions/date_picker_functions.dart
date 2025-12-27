import 'package:u/utilities.dart';

import '../widgets/widgets.dart' show WDatePicker, WRangeDatePicker;
import '../widgets/fields/fields.dart';

abstract class DateAndTimeFunctions {
  static Future<Jalali?> showCustomPersianDatePicker({
    final bool barrierDismissible = true,
    final Color? barrierColor,
    final Jalali? startDate,
    Jalali? initialDate,
    final VoidCallback? onDismissed,
    final bool showYearSelector = false,
    final bool enableClearButton = true,
  }) async {
    if (initialDate != null && startDate != null && initialDate.isBefore(startDate)) {
      initialDate = null;
    }

    final result = await showDialog<Jalali>(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (final context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: WDatePicker(
          startDate: startDate,
          initialDate: initialDate,
          showYearSelector: showYearSelector,
          enableClearButton: enableClearButton,
          onConfirm: (final date) {
            final finalDate = date != null ? Jalali(date.year, date.month, date.day) : null;
            Navigator.of(context).pop(finalDate); // مقدار انتخاب‌شده رو برمی‌گردونه
          },
        ),
      ),
    );

    if (onDismissed != null) onDismissed();
    return result;
  }

  static Future<RangeDatePickerViewModel?> showCustomPersianRangDatePicker({
    final bool barrierDismissible = true,
    final Color? barrierColor,
    final Jalali? startDate,
    final RangeDatePickerViewModel? initialDate,
    final VoidCallback? onDismissed,
    final bool showYearSelector = false,
    final bool enableClearButton = true,
  }) async {
    final result = await showDialog<RangeDatePickerViewModel>(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (final context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: WRangeDatePicker(
          startDate: startDate,
          initialDate: initialDate,
          showYearSelector: showYearSelector,
          enableClearButton: enableClearButton,
          onConfirm: (final model) {
            Navigator.of(context).pop(model); // مقدار انتخاب‌شده رو برمی‌گردونه
          },
        ),
      ),
    );

    if (onDismissed != null) onDismissed();
    return result;
  }

  static List<String> generateTimeSlots({
    final int startHour = 7,
    final int endHour = 7,
    final int intervalInMinutes = 30,
  }) {
    final List<String> slots = [];
    String formatter(final DateTime date) =>
        "${date.hour.toString().numericOnly().padLeft(2, '0')}:${date.minute.toString().numericOnly().padLeft(2, '0')}";

    final now = DateTime(2025, 1, 1);
    DateTime currentTime = now.copyWith(hour: startHour, minute: 0);
    DateTime endTime = now.copyWith(hour: endHour, minute: 0);

    // اگر ساعت پایان از ساعت شروع کمتر بود، یعنی بازه ما شبانه است
    // و باید یک روز به تاریخ پایان اضافه کنیم.
    if (endHour < startHour || endHour == startHour) {
      endTime = endTime.add(const Duration(days: 1));
    }

    // تا زمانی که به ساعت پایان نرسیده‌ایم، به حلقه ادامه بده
    while (currentTime.isBefore(endTime) || currentTime.isAtSameMomentAs(endTime)) {
      if (slots.contains(formatter(currentTime))) break;
      slots.add(formatter(currentTime));
      // به زمان فعلی، بازه زمانی را اضافه کن تا زمان بعدی به دست آید
      currentTime = currentTime.add(Duration(minutes: intervalInMinutes));
    }

    return slots;
  }
}
