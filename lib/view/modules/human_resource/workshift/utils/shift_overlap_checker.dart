import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';

/// اطلاعات مربوط به تداخل یک شیفت در یک روز خاص
///
/// این کلاس جزئیات تداخل بین یک شیفت جدید و یک شیفت موجود را نگهداری می‌کند.
/// برای هر تداخل، یک نمونه از این کلاس ایجاد می‌شود که شامل اطلاعات روز،
/// عنوان و بازه زمانی شیفت متداخل و بازه زمانی شیفت جدید است.
///
/// مثال:
/// ```dart
/// ShiftOverlapInfo(
///   dayKey: '1403-01-15',
///   conflictingShiftTitle: 'شیفت صبح',
///   conflictingTimeRange: '08:00 - 17:00',
///   newShiftTimeRange: '09:00 - 18:00',
/// )
/// ```
class ShiftOverlapInfo {
  /// ایجاد یک نمونه از اطلاعات تداخل شیفت
  ///
  /// [dayKey]: کلید روز به فرمت yyyy-MM-dd شمسی (مثلا '1403-01-15')
  /// [conflictingShiftTitle]: عنوان شیفت موجود که با شیفت جدید تداخل دارد
  /// [conflictingTimeRange]: بازه زمانی شیفت موجود به فرمت 'HH:MM - HH:MM'
  /// [newShiftTimeRange]: بازه زمانی شیفت جدید به فرمت 'HH:MM - HH:MM'
  const ShiftOverlapInfo({
    required this.dayKey,
    required this.conflictingShiftTitle,
    required this.conflictingTimeRange,
    required this.newShiftTimeRange,
  });

  /// کلید روز به فرمت yyyy-MM-dd شمسی
  ///
  /// این کلید برای شناسایی روزی که تداخل در آن رخ داده است استفاده می‌شود.
  /// فرمت: 'yyyy-MM-dd' (مثلا '1403-01-15')
  final String dayKey;

  /// عنوان شیفت موجود که با شیفت جدید تداخل دارد
  ///
  /// این عنوان از [ShiftTypeReadDto.title] گرفته می‌شود و برای نمایش
  /// به کاربر استفاده می‌شود.
  final String conflictingShiftTitle;

  /// بازه زمانی شیفت متداخل به فرمت 'HH:MM - HH:MM'
  ///
  /// این بازه زمانی از [ShiftTypeReadDto.startTime] و [ShiftTypeReadDto.endTime]
  /// ساخته می‌شود و برای نمایش به کاربر استفاده می‌شود.
  /// مثال: '08:00 - 17:00'
  final String conflictingTimeRange;

  /// بازه زمانی شیفت جدید به فرمت 'HH:MM - HH:MM'
  ///
  /// این بازه زمانی از پارامترهای [newShiftStartTime] و [newShiftEndTime]
  /// که به [checkShiftOverlaps] داده شده است ساخته می‌شود.
  /// مثال: '09:00 - 18:00'
  final String newShiftTimeRange;
}

/// نتیجه کلی بررسی تداخل‌های شیفت‌ها
///
/// این کلاس نتیجه بررسی تداخل یک شیفت جدید با شیفت‌های موجود را نگهداری می‌کند.
/// شامل لیست روزهای متداخل، روزهای معتبر و اطلاعات جزئی هر تداخل است.
///
/// استفاده:
/// ```dart
/// final result = ShiftOverlapChecker.checkShiftOverlaps(...);
/// if (result.hasOverlap) {
///   // نمایش هشدار به کاربر
///   ShiftOverlapChecker.showOverlapReportDialog(result: result, ...);
/// } else {
///   // اعمال شیفت در تمام روزها
///   applyShiftToDays(result.validDays);
/// }
/// ```
class ShiftOverlapResult {
  /// ایجاد یک نمونه از نتیجه بررسی تداخل
  ///
  /// [overlappingDays]: لیست روزهایی که شیفت جدید با شیفت‌های موجود تداخل دارد
  /// [validDays]: لیست روزهایی که بدون تداخل هستند و می‌توان شیفت جدید را اعمال کرد
  /// [overlapInfoList]: اطلاعات جزئی هر تداخل شامل عنوان و بازه زمانی شیفت‌های متداخل
  const ShiftOverlapResult({
    required this.overlappingDays,
    required this.validDays,
    required this.overlapInfoList,
  });

  /// لیست روزهایی که شیفت جدید با شیفت‌های موجود تداخل دارد
  ///
  /// این روزها از [targetDays] که به [checkShiftOverlaps] داده شده است
  /// گرفته می‌شوند و نشان می‌دهند که در این روزها نمی‌توان شیفت جدید را اعمال کرد.
  final List<DailyShiftParams> overlappingDays;

  /// لیست روزهایی که بدون تداخل هستند و می‌توان شیفت جدید را اعمال کرد
  ///
  /// این روزها از [targetDays] که به [checkShiftOverlaps] داده شده است
  /// گرفته می‌شوند و نشان می‌دهند که در این روزها می‌توان شیفت جدید را اعمال کرد.
  final List<DailyShiftParams> validDays;

  /// اطلاعات کامل و جزئی هر تداخل
  ///
  /// برای هر تداخل، یک [ShiftOverlapInfo] شامل اطلاعات روز، عنوان و بازه زمانی
  /// شیفت متداخل و بازه زمانی شیفت جدید در این لیست قرار می‌گیرد.
  /// این اطلاعات برای نمایش گزارش تداخل به کاربر استفاده می‌شود.
  final List<ShiftOverlapInfo> overlapInfoList;

  /// بررسی می‌کند که آیا حداقل یک تداخل وجود دارد یا نه
  ///
  /// Returns `true` اگر [overlappingDays] خالی نباشد، در غیر این صورت `false`.
  bool get hasOverlap => overlappingDays.isNotEmpty;

  /// بررسی می‌کند که آیا همه روزهای انتخاب شده تداخل دارند یا نه
  ///
  /// Returns `true` اگر [validDays] خالی باشد و [overlappingDays] خالی نباشد،
  /// در غیر این صورت `false`.
  ///
  /// این وضعیت زمانی رخ می‌دهد که شیفت جدید با تمام روزهای انتخاب شده تداخل دارد
  /// و نمی‌توان آن را در هیچ روزی اعمال کرد.
  bool get allDaysOverlap => validDays.isEmpty && overlappingDays.isNotEmpty;

  /// تعداد روزهایی که تداخل دارند
  ///
  /// این مقدار برابر با طول [overlappingDays] است.
  int get overlapCount => overlappingDays.length;

  /// تعداد روزهایی که بدون تداخل هستند و می‌توان شیفت جدید را اعمال کرد
  ///
  /// این مقدار برابر با طول [validDays] است.
  int get validCount => validDays.length;
}

/// کلاس ابزاری برای بررسی تداخل شیفت‌ها
///
/// این کلاس شامل متدهای استاتیک برای بررسی تداخل زمانی بین شیفت‌های مختلف است.
/// از این کلاس برای اطمینان از اینکه شیفت‌های جدید با شیفت‌های موجود تداخل ندارند
/// استفاده می‌شود.
///
/// ویژگی‌های کلیدی:
/// - پشتیبانی از شیفت‌های شب (night shifts) که از یک روز به روز بعد ادامه دارند
/// - بررسی تداخل برای کل سال به صورت یکجا
/// - پشتیبانی از draft shifts (شیفت‌های پیش‌نویس) و remote shifts (شیفت‌های ذخیره شده)
/// - امکان نادیده گرفتن یک شیفت خاص در بررسی تداخل (برای فلو edit)
///
/// مثال استفاده:
/// ```dart
/// // ساخت Map شیفت‌های سال
/// final assignments = ShiftOverlapChecker.buildYearAssignmentsMap(
///   yearMonths: yearShift.months,
///   draftShifts: controller.draftShifts,
/// );
///
/// // بررسی تداخل
/// final result = ShiftOverlapChecker.checkShiftOverlaps(
///   targetDays: selectedDays,
///   newShiftStartTime: '09:00',
///   newShiftEndTime: '18:00',
///   isNightShift: false,
///   assignmentsByDate: assignments,
///   shiftTypeRegistry: controller.shiftTypeRegistry,
/// );
///
/// // نمایش نتیجه
/// if (result.hasOverlap) {
///   await ShiftOverlapChecker.showOverlapReportDialog(
///     result: result,
///     newShiftTitle: 'شیفت جدید',
///   );
/// }
/// ```
abstract class ShiftOverlapChecker {
  /// ساخت Map شیفت‌های کل سال از داده‌های remote و draft
  ///
  /// این تابع شیفت‌های remote از کل ماه‌های سال و همچنین draftShifts را
  /// در یک Map ترکیب می‌کند تا بتوان تداخل را برای کل سال بررسی کرد.
  ///
  /// ساختار Map:
  /// - کلید: کلید روز به فرمت yyyy-MM-dd شمسی (مثلا '1403-01-15')
  /// - مقدار: Set از slugهای شیفت تایپ‌هایی که در آن روز اعمال شده‌اند
  ///
  /// ترتیب پردازش:
  /// 1. ابتدا شیفت‌های remote از تمام ماه‌های سال پردازش می‌شوند
  /// 2. سپس draftShifts با شیفت‌های remote ادغام می‌شوند
  ///    (اگر یک روز هم در remote و هم در draft وجود داشته باشد، هر دو اضافه می‌شوند)
  ///
  /// [yearMonths]: لیست ماه‌های سال از [YearShiftReadDto.months]
  ///               می‌تواند null باشد که در این صورت فقط draftShifts پردازش می‌شوند
  /// [draftShifts]: Set از شیفت‌های پیش‌نویس که هنوز ذخیره نشده‌اند
  ///
  /// Returns یک Map که کلید آن کلید روز (yyyy-MM-dd شمسی) و مقدار آن
  ///         Set از slugهای شیفت تایپ‌های آن روز است.
  ///
  /// مثال:
  /// ```dart
  /// {
  ///   '1403-01-15': {'shift-morning', 'shift-evening'},
  ///   '1403-01-16': {'shift-morning'},
  ///   ...
  /// }
  /// ```
  static Map<String, Set<String>> buildYearAssignmentsMap({
    required final List<MonthShiftReadDto>? yearMonths,
    required final Set<DailyShiftParams> draftShifts,
  }) {
    final Map<String, Set<String>> result = {};

    // 1. از شیفت‌های remote (کل ماه‌های سال)
    for (final month in yearMonths ?? <MonthShiftReadDto>[]) {
      for (final day in month.days ?? <DailyShiftReadDto>[]) {
        final dayKey = _normalizeDayKey(day.dayDate);
        result.putIfAbsent(dayKey, () => <String>{});
        result[dayKey]!.addAll(day.shiftTypes.map((final e) => e.slug));
      }
    }

    // 2. merge با draftShifts
    for (final draft in draftShifts) {
      final dayKey = _normalizeDayKey(draft.dayDate);
      result.putIfAbsent(dayKey, () => <String>{});
      result[dayKey]!.addAll(draft.shiftTypeSlugList ?? <String>[]);
    }

    return result;
  }

  /// بررسی تداخل شیفت جدید با شیفت‌های موجود
  ///
  /// این تابع برای هر روز در [targetDays] بررسی می‌کند که آیا شیفت جدید
  /// با شیفت‌های موجود در آن روز تداخل دارد یا نه. همچنین شیفت‌های شب روز قبل
  /// که ممکن است با شیفت جدید تداخل داشته باشند نیز بررسی می‌شوند.
  ///
  /// الگوریتم بررسی:
  /// 1. برای هر روز در [targetDays]:
  ///    - تمام شیفت‌های موجود در آن روز را بررسی می‌کند
  ///    - اگر [targetSlug] مشخص شده باشد، شیفت با آن slug نادیده گرفته می‌شود
  ///      (این برای فلو edit استفاده می‌شود تا بتوان شیفت را ویرایش کرد)
  ///    - بازه زمانی هر شیفت موجود با بازه زمانی شیفت جدید مقایسه می‌شود
  ///    - اگر تداخل وجود داشته باشد، روز به [overlappingDays] اضافه می‌شود
  /// 2. برای هر روز، شیفت‌های شب روز قبل نیز بررسی می‌شوند:
  ///    - اگر روز قبل شیفت شب داشته باشد که تا روز جاری ادامه دارد
  ///    - بازه زمانی بخش دوم آن شیفت (00:00 تا endTime) با شیفت جدید مقایسه می‌شود
  ///
  /// پشتیبانی از شیفت شب:
  /// - شیفت شب: شیفتی که startTime > endTime است (مثلا 22:00 تا 06:00)
  /// - شیفت شب به دو بخش تقسیم می‌شود:
  ///   - بخش اول: از startTime تا 24:00 (نیمه شب)
  ///   - بخش دوم: از 00:00 تا endTime (روز بعد)
  ///
  /// [targetDays]: لیست روزهایی که شیفت جدید قرار است اعمال شود.
  ///               این روزها باید از [DailyShiftParams] باشند و [dayDate] آن‌ها
  ///               به فرمت yyyy-MM-dd (میلادی یا شمسی) باشد.
  ///
  /// [newShiftStartTime]: زمان شروع شیفت جدید به فرمت HH:MM (مثلا '09:00')
  ///
  /// [newShiftEndTime]: زمان پایان شیفت جدید به فرمت HH:MM (مثلا '18:00')
  ///
  /// [isNightShift]: آیا شیفت جدید یک شیفت شب است یا نه.
  ///                 اگر `true` باشد، شیفت از [newShiftStartTime] شروع می‌شود
  ///                 و تا [newShiftEndTime] روز بعد ادامه دارد.
  ///                 اگر `false` باشد، شیفت در همان روز شروع و پایان می‌یابد.
  ///
  /// [assignmentsByDate]: Map از شیفت‌های موجود به تفکیک روز.
  ///                     این Map باید از [buildYearAssignmentsMap] ساخته شده باشد.
  ///                     کلید: کلید روز به فرمت yyyy-MM-dd شمسی
  ///                     مقدار: Set از slugهای شیفت تایپ‌های آن روز
  ///
  /// [shiftTypeRegistry]: Map از تمام شیفت تایپ‌ها برای دسترسی به اطلاعات آن‌ها.
  ///                     کلید: slug شیفت تایپ
  ///                     مقدار: [ShiftTypeReadDto] شامل اطلاعات کامل شیفت تایپ
  ///
  /// [targetSlug]: (اختیاری) اگر مشخص شود، شیفت با این slug در بررسی تداخل
  ///               نادیده گرفته می‌شود. این برای فلو edit استفاده می‌شود تا
  ///               بتوان شیفت را ویرایش کرد بدون اینکه با خودش تداخل داشته باشد.
  ///               اگر `null` باشد، تمام شیفت‌های موجود بررسی می‌شوند.
  ///
  /// Returns یک [ShiftOverlapResult] شامل:
  ///         - [overlappingDays]: روزهایی که تداخل دارند
  ///         - [validDays]: روزهایی که بدون تداخل هستند
  ///         - [overlapInfoList]: اطلاعات جزئی هر تداخل
  ///
  /// مثال:
  /// ```dart
  /// final result = ShiftOverlapChecker.checkShiftOverlaps(
  ///   targetDays: [
  ///     DailyShiftParams(dayDate: '2024-01-15', ...),
  ///     DailyShiftParams(dayDate: '2024-01-16', ...),
  ///   ],
  ///   newShiftStartTime: '09:00',
  ///   newShiftEndTime: '18:00',
  ///   isNightShift: false,
  ///   assignmentsByDate: yearAssignments,
  ///   shiftTypeRegistry: controller.shiftTypeRegistry,
  ///   targetSlug: 'shift-morning', // برای edit
  /// );
  ///
  /// if (result.hasOverlap) {
  ///   // نمایش هشدار
  /// } else {
  ///   // اعمال شیفت
  /// }
  /// ```
  static ShiftOverlapResult checkShiftOverlaps({
    required final List<DailyShiftParams> targetDays,
    required final String newShiftStartTime,
    required final String newShiftEndTime,
    required final bool isNightShift,
    required final Map<String, Set<String>> assignmentsByDate,
    required final Map<String, ShiftTypeReadDto> shiftTypeRegistry,
    final String? targetSlug,
  }) {
    final overlappingDays = <DailyShiftParams>[];
    final validDays = <DailyShiftParams>[];
    final overlapInfoList = <ShiftOverlapInfo>[];

    final newStartMinutes = _timeToMinutes(newShiftStartTime);
    final newEndMinutes = _timeToMinutes(newShiftEndTime);
    final newTimeRange = '$newShiftStartTime - $newShiftEndTime';

    for (final day in targetDays) {
      final dayKey = _normalizeDayKey(day.dayDate);
      final existingSlugs = assignmentsByDate[dayKey] ?? <String>{};

      bool hasOverlapForThisDay = false;

      for (final slug in existingSlugs) {
        // اگر targetSlug مشخص شده و این slug همان targetSlug است، آن را نادیده بگیر (برای فلو edit)
        if (targetSlug != null && slug == targetSlug) continue;

        final existingShift = shiftTypeRegistry[slug];
        if (existingShift == null) continue;

        final existingStartMinutes = _timeToMinutes(existingShift.startTime);
        final existingEndMinutes = _timeToMinutes(existingShift.endTime);
        final existingIsNightShift = existingShift.isNightShift || existingEndMinutes <= existingStartMinutes;

        if (_doTimeRangesOverlap(
          newStart: newStartMinutes,
          newEnd: newEndMinutes,
          newIsNight: isNightShift,
          existingStart: existingStartMinutes,
          existingEnd: existingEndMinutes,
          existingIsNight: existingIsNightShift,
        )) {
          hasOverlapForThisDay = true;
          overlapInfoList.add(
            ShiftOverlapInfo(
              dayKey: dayKey,
              conflictingShiftTitle: existingShift.title,
              conflictingTimeRange: '${existingShift.startTime} - ${existingShift.endTime}',
              newShiftTimeRange: newTimeRange,
            ),
          );
        }
      }

      // همچنین باید شیفت‌های روز قبل که شیفت شب هستند را بررسی کنیم
      final previousDayKey = _getPreviousDayKey(dayKey);
      final previousDaySlugs = assignmentsByDate[previousDayKey] ?? <String>{};

      for (final slug in previousDaySlugs) {
        // اگر targetSlug مشخص شده و این slug همان targetSlug است، آن را نادیده بگیر (برای فلو edit)
        if (targetSlug != null && slug == targetSlug) continue;

        final existingShift = shiftTypeRegistry[slug];
        if (existingShift == null) continue;

        final existingStartMinutes = _timeToMinutes(existingShift.startTime);
        final existingEndMinutes = _timeToMinutes(existingShift.endTime);
        final existingIsNightShift = existingShift.isNightShift || existingEndMinutes <= existingStartMinutes;

        // فقط شیفت‌های شب روز قبل را بررسی می‌کنیم
        if (!existingIsNightShift) continue;

        if (_doNightShiftOverlapWithNextDay(
          nightShiftEnd: existingEndMinutes,
          newStart: newStartMinutes,
          newEnd: newEndMinutes,
          newIsNight: isNightShift,
        )) {
          hasOverlapForThisDay = true;
          overlapInfoList.add(
            ShiftOverlapInfo(
              dayKey: dayKey,
              conflictingShiftTitle: '${existingShift.title} (${s.previousDay})',
              conflictingTimeRange: '${existingShift.startTime} - ${existingShift.endTime}',
              newShiftTimeRange: newTimeRange,
            ),
          );
        }
      }

      if (hasOverlapForThisDay) {
        overlappingDays.add(day);
      } else {
        validDays.add(day);
      }
    }

    return ShiftOverlapResult(
      overlappingDays: overlappingDays,
      validDays: validDays,
      overlapInfoList: overlapInfoList,
    );
  }

  /// نمایش خطای تداخل کامل (وقتی همه روزها تداخل دارند)
  ///
  /// این تابع یک Snackbar قرمز نمایش می‌دهد که به کاربر اطلاع می‌دهد
  /// شیفت جدید با تمام روزهای انتخاب شده تداخل دارد و نمی‌توان آن را اعمال کرد.
  ///
  /// این تابع زمانی فراخوانی می‌شود که [ShiftOverlapResult.allDaysOverlap] برابر `true` باشد.
  ///
  /// [newShiftTitle]: عنوان شیفت جدید که برای نمایش در پیام خطا استفاده می‌شود.
  ///
  /// مثال:
  /// ```dart
  /// if (result.allDaysOverlap) {
  ///   ShiftOverlapChecker.showAllDaysOverlapError(
  ///     newShiftTitle: 'شیفت صبح',
  ///   );
  /// }
  /// ```
  static void showAllDaysOverlapError({required final String newShiftTitle}) {
    AppNavigator.snackbarRed(
      title: s.error,
      subtitle: s.shiftConflictsWithAllSelectedDays(newShiftTitle),
    );
  }

  /// نمایش دیالوگ گزارش تداخل‌ها
  ///
  /// این تابع یک دیالوگ جامع نمایش می‌دهد که شامل:
  /// - خلاصه: تعداد روزهای متداخل و تعداد روزهای معتبر
  /// - جزئیات: لیست تمام شیفت‌های متداخل با بازه زمانی و تعداد روزهای متداخل
  ///
  /// این دیالوگ برای اطلاع‌رسانی به کاربر استفاده می‌شود تا بداند
  /// در کدام روزها نمی‌توان شیفت جدید را اعمال کرد و چرا.
  ///
  /// ویژگی‌های دیالوگ:
  /// - غیرقابل بستن با کلیک روی backdrop (barrierDismissible: false)
  /// - گروه‌بندی تداخل‌ها بر اساس عنوان و بازه زمانی شیفت متداخل
  /// - نمایش تعداد روزهای متداخل برای هر شیفت
  /// - دکمه OK برای بستن دیالوگ
  ///
  /// [result]: نتیجه بررسی تداخل از [checkShiftOverlaps]
  ///           که شامل اطلاعات روزهای متداخل و معتبر است
  ///
  /// [newShiftTitle]: عنوان شیفت جدید که برای نمایش در دیالوگ استفاده می‌شود
  ///
  /// Returns یک Future که وقتی دیالوگ بسته شود complete می‌شود.
  ///
  /// مثال:
  /// ```dart
  /// if (result.hasOverlap && !result.allDaysOverlap) {
  ///   await ShiftOverlapChecker.showOverlapReportDialog(
  ///     result: result,
  ///     newShiftTitle: 'شیفت صبح',
  ///   );
  ///   // بعد از بستن دیالوگ، روزهای معتبر را اعمال کن
  ///   applyShiftToDays(result.validDays);
  /// }
  /// ```
  static Future<void> showOverlapReportDialog({
    required final ShiftOverlapResult result,
    required final String newShiftTitle,
  }) async {
    // گروه‌بندی تداخل‌ها بر اساس شیفت متداخل
    final Map<String, List<ShiftOverlapInfo>> groupedByShift = {};
    for (final info in result.overlapInfoList) {
      final key = '${info.conflictingShiftTitle}|${info.conflictingTimeRange}';
      groupedByShift.putIfAbsent(key, () => []).add(info);
    }

    await showAppDialog<void>(
      barrierDismissible: false,
      Builder(
        builder: (final ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Row(
              spacing: 8,
              children: [
                const UImage(AppIcons.warningOutline, color: AppColors.orange, size: 25),
                Text(s.shiftOverlapReport).titleMedium().expanded(),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // خلاصه
                      WCard(
                        color: AppColors.orange.withValues(alpha: 0.05),
                        showBorder: true,
                        borderColor: AppColors.orange.withValues(alpha: 0.2),
                        margin: EdgeInsets.zero,
                        child: SizedBox(
                          width: ctx.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                s.shiftConflictsWithDays(newShiftTitle, '${result.overlapCount}'),
                              ).bodyMedium().bold(),
                              Text(
                                s.daysWithoutConflictWillBeApplied('${result.validCount}'),
                              ).bodyMedium(color: AppColors.green),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // جزئیات تداخل‌ها
                      Text('${s.details}:').bodyMedium().bold(),
                      const SizedBox(height: 8),

                      ...groupedByShift.entries.map((final entry) {
                        final parts = entry.key.split('|');
                        final shiftTitle = parts[0];
                        final timeRange = parts.length > 1 ? parts[1] : '';
                        final days = entry.value;

                        return WCard(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: 10,
                          showBorder: true,
                          borderWidth: 1,
                          borderColor: ctx.theme.dividerColor.withValues(alpha: 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  UImage(AppIcons.clockOutline, size: 20, color: ctx.theme.hintColor),
                                  Expanded(
                                    child: Text(shiftTitle).bodyMedium().bold(),
                                  ),
                                ],
                              ),
                              Text('${s.time}: $timeRange').bodySmall(color: ctx.theme.hintColor),
                              Text('${s.conflictingDays}: ${days.length}').bodySmall(),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                UElevatedButton(
                  width: ctx.width,
                  title: s.ok,
                  onTap: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// تبدیل زمان HH:MM به دقیقه از ابتدای روز
///
/// این تابع یک زمان به فرمت HH:MM را به تعداد دقیقه از ابتدای روز (00:00) تبدیل می‌کند.
/// این تبدیل برای محاسبات تداخل زمانی استفاده می‌شود.
///
/// فرمت ورودی: 'HH:MM' (مثلا '09:30', '22:00')
///
/// [time]: زمان به فرمت HH:MM
///
/// Returns تعداد دقیقه از ابتدای روز (0 تا 1439).
///         اگر فرمت ورودی نامعتبر باشد، 0 برمی‌گرداند.
///
/// مثال:
/// ```dart
/// _timeToMinutes('09:30') // 570 (9 * 60 + 30)
/// _timeToMinutes('00:00') // 0
/// _timeToMinutes('23:59') // 1439
/// ```
int _timeToMinutes(final String time) {
  final parts = time.split(':');
  if (parts.length != 2) return 0;
  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;
  return hours * 60 + minutes;
}

/// بررسی تداخل دو بازه زمانی با در نظر گرفتن شیفت شب
///
/// این تابع بررسی می‌کند که آیا دو بازه زمانی با هم تداخل دارند یا نه.
/// این تابع از پشتیبانی کامل از شیفت‌های شب برخوردار است که از یک روز
/// به روز بعد ادامه دارند.
///
/// انواع حالت‌های بررسی:
/// 1. هر دو شیفت معمولی (نه شب): بررسی تداخل ساده در همان روز
/// 2. شیفت جدید شب، شیفت موجود معمولی: بررسی بخش اول شیفت جدید (تا 24:00)
/// 3. شیفت جدید معمولی، شیفت موجود شب: بررسی بخش اول شیفت موجود (تا 24:00)
/// 4. هر دو شیفت شب: بررسی هر دو بخش (تا 24:00 و از 00:00)
///
/// [newStart]: زمان شروع شیفت جدید به دقیقه از ابتدای روز (0-1439)
///
/// [newEnd]: زمان پایان شیفت جدید به دقیقه از ابتدای روز (0-1439)
///           برای شیفت شب، این زمان مربوط به روز بعد است
///
/// [newIsNight]: آیا شیفت جدید یک شیفت شب است یا نه.
///               اگر `true` باشد، شیفت از [newStart] شروع می‌شود و تا [newEnd] روز بعد ادامه دارد.
///
/// [existingStart]: زمان شروع شیفت موجود به دقیقه از ابتدای روز (0-1439)
///
/// [existingEnd]: زمان پایان شیفت موجود به دقیقه از ابتدای روز (0-1439)
///                برای شیفت شب، این زمان مربوط به روز بعد است
///
/// [existingIsNight]: آیا شیفت موجود یک شیفت شب است یا نه.
///
/// Returns `true` اگر دو بازه زمانی با هم تداخل داشته باشند، در غیر این صورت `false`.
///
/// مثال:
/// ```dart
/// // دو شیفت معمولی که تداخل دارند
/// _doTimeRangesOverlap(
///   newStart: 540,      // 09:00
///   newEnd: 1080,       // 18:00
///   newIsNight: false,
///   existingStart: 480, // 08:00
///   existingEnd: 1020,  // 17:00
///   existingIsNight: false,
/// ) // true (تداخل دارند: 09:00-17:00)
///
/// // شیفت شب و شیفت معمولی
/// _doTimeRangesOverlap(
///   newStart: 1320,     // 22:00
///   newEnd: 360,        // 06:00 (روز بعد)
///   newIsNight: true,
///   existingStart: 480, // 08:00
///   existingEnd: 1020,  // 17:00
///   existingIsNight: false,
/// ) // false (تداخل ندارند)
/// ```
bool _doTimeRangesOverlap({
  required final int newStart,
  required final int newEnd,
  required final bool newIsNight,
  required final int existingStart,
  required final int existingEnd,
  required final bool existingIsNight,
}) {
  // شیفت معمولی: start < end
  // شیفت شب: start > end (مثلا 22:00 تا 06:00)

  // اگر هیچکدام شیفت شب نیستند
  if (!newIsNight && !existingIsNight) {
    return _simpleOverlap(newStart, newEnd, existingStart, existingEnd);
  }

  // اگر شیفت جدید شب است
  if (newIsNight && !existingIsNight) {
    // بخش اول شیفت جدید: newStart تا 24:00
    if (_simpleOverlap(newStart, 24 * 60, existingStart, existingEnd)) {
      return true;
    }
    return false;
  }

  // اگر شیفت موجود شب است
  if (!newIsNight && existingIsNight) {
    // بخش اول شیفت موجود: existingStart تا 24:00
    if (_simpleOverlap(newStart, newEnd, existingStart, 24 * 60)) {
      return true;
    }
    return false;
  }

  // اگر هر دو شیفت شب هستند
  // بخش اول هر دو (تا 24:00) با هم تداخل دارند
  if (_simpleOverlap(newStart, 24 * 60, existingStart, 24 * 60)) {
    return true;
  }
  // بخش دوم هر دو (از 00:00) با هم تداخل دارند
  if (_simpleOverlap(0, newEnd, 0, existingEnd)) {
    return true;
  }
  return false;
}

/// بررسی تداخل بخش شب شیفت روز قبل با شیفت روز جاری
///
/// این تابع بررسی می‌کند که آیا بخش دوم یک شیفت شب روز قبل (از 00:00 تا endTime)
/// با شیفت جدید روز جاری تداخل دارد یا نه.
///
/// این تابع برای بررسی تداخل شیفت‌های شب که از روز قبل شروع شده‌اند و تا روز جاری
/// ادامه دارند با شیفت‌های روز جاری استفاده می‌شود.
///
/// حالت‌های بررسی:
/// 1. شیفت جدید هم شب است: بررسی تداخل بخش دوم هر دو (از 00:00)
/// 2. شیفت جدید معمولی است: بررسی تداخل بخش دوم شیفت شب روز قبل با شیفت جدید
///
/// [nightShiftEnd]: زمان پایان بخش دوم شیفت شب روز قبل به دقیقه از ابتدای روز (0-1439)
///                  این زمان مربوط به روز جاری است (مثلا 06:00 = 360 دقیقه)
///
/// [newStart]: زمان شروع شیفت جدید به دقیقه از ابتدای روز (0-1439)
///
/// [newEnd]: زمان پایان شیفت جدید به دقیقه از ابتدای روز (0-1439)
///           اگر [newIsNight] `true` باشد، این زمان مربوط به روز بعد است
///
/// [newIsNight]: آیا شیفت جدید یک شیفت شب است یا نه.
///
/// Returns `true` اگر بخش دوم شیفت شب روز قبل با شیفت جدید تداخل داشته باشد،
///         در غیر این صورت `false`.
///
/// مثال:
/// ```dart
/// // شیفت شب روز قبل (22:00-06:00) با شیفت صبح روز جاری (08:00-17:00)
/// _doNightShiftOverlapWithNextDay(
///   nightShiftEnd: 360,  // 06:00
///   newStart: 480,        // 08:00
///   newEnd: 1020,         // 17:00
///   newIsNight: false,
/// ) // false (تداخل ندارند: 06:00 < 08:00)
///
/// // شیفت شب روز قبل (22:00-06:00) با شیفت صبح زود روز جاری (05:00-13:00)
/// _doNightShiftOverlapWithNextDay(
///   nightShiftEnd: 360,  // 06:00
///   newStart: 300,       // 05:00
///   newEnd: 780,         // 13:00
///   newIsNight: false,
/// ) // true (تداخل دارند: 05:00-06:00)
/// ```
bool _doNightShiftOverlapWithNextDay({
  required final int nightShiftEnd,
  required final int newStart,
  required final int newEnd,
  required final bool newIsNight,
}) {
  // بخش دوم شیفت شب روز قبل: 00:00 تا nightShiftEnd
  if (newIsNight) {
    // اگر شیفت جدید هم شب است، بخش دوم آن با شیفت روز قبل تداخل دارد
    return _simpleOverlap(0, nightShiftEnd, 0, newEnd);
  } else {
    // شیفت جدید معمولی است
    return _simpleOverlap(0, nightShiftEnd, newStart, newEnd);
  }
}

/// بررسی تداخل ساده دو بازه زمانی در یک روز
///
/// این تابع بررسی می‌کند که آیا دو بازه زمانی ساده (بدون در نظر گرفتن شیفت شب)
/// با هم تداخل دارند یا نه.
///
/// الگوریتم: دو بازه زمانی زمانی تداخل دارند که:
/// - start1 < end2 (شروع بازه اول قبل از پایان بازه دوم)
/// - start2 < end1 (شروع بازه دوم قبل از پایان بازه اول)
///
/// این الگوریتم برای بازه‌های زمانی در یک روز کار می‌کند و فرض می‌کند که
/// start < end است (یعنی بازه از یک زمان شروع می‌شود و قبل از نیمه شب پایان می‌یابد).
///
/// [start1]: زمان شروع بازه اول به دقیقه از ابتدای روز (0-1439)
///
/// [end1]: زمان پایان بازه اول به دقیقه از ابتدای روز (0-1439)
///
/// [start2]: زمان شروع بازه دوم به دقیقه از ابتدای روز (0-1439)
///
/// [end2]: زمان پایان بازه دوم به دقیقه از ابتدای روز (0-1439)
///
/// Returns `true` اگر دو بازه زمانی با هم تداخل داشته باشند، در غیر این صورت `false`.
///
/// مثال:
/// ```dart
/// // دو بازه که تداخل دارند
/// _simpleOverlap(480, 1020, 540, 1080) // true
/// // بازه 1: 08:00-17:00
/// // بازه 2: 09:00-18:00
/// // تداخل: 09:00-17:00
///
/// // دو بازه که تداخل ندارند
/// _simpleOverlap(480, 1020, 1080, 1320) // false
/// // بازه 1: 08:00-17:00
/// // بازه 2: 18:00-22:00
/// // تداخل ندارند
///
/// // دو بازه که دقیقا به هم می‌رسند (تداخل ندارند)
/// _simpleOverlap(480, 1020, 1020, 1320) // false
/// // بازه 1: 08:00-17:00
/// // بازه 2: 17:00-22:00
/// // تداخل ندارند (17:00 نقطه مشترک است اما بازه نیست)
/// ```
bool _simpleOverlap(final int start1, final int end1, final int start2, final int end2) {
  return start1 < end2 && start2 < end1;
}

/// نرمال‌سازی کلید روز (تبدیل میلادی به شمسی)
///
/// این تابع یک تاریخ را به فرمت استاندارد کلید روز (yyyy-MM-dd شمسی) تبدیل می‌کند.
/// اگر تاریخ ورودی به فرمت میلادی باشد، آن را به شمسی تبدیل می‌کند.
/// اگر قبلا شمسی باشد، آن را به همان صورت برمی‌گرداند.
///
/// منطق تشخیص:
/// - اگر سال بیشتر از 1500 باشد، احتمالا تاریخ شمسی است و بدون تغییر برمی‌گردد
/// - در غیر این صورت، تاریخ میلادی فرض می‌شود و به شمسی تبدیل می‌شود
///
/// فرمت ورودی: 'yyyy-MM-dd' (میلادی یا شمسی)
/// فرمت خروجی: 'yyyy-MM-dd' (همیشه شمسی)
///
/// [raw]: تاریخ خام به فرمت 'yyyy-MM-dd'
///
/// Returns کلید روز به فرمت استاندارد yyyy-MM-dd شمسی.
///         اگر فرمت ورودی نامعتبر باشد، همان مقدار ورودی برمی‌گردد.
///
/// مثال:
/// ```dart
/// _normalizeDayKey('2024-01-15') // '1402-10-25' (تبدیل میلادی به شمسی)
/// _normalizeDayKey('1403-01-15') // '1403-01-15' (قبلا شمسی است)
/// _normalizeDayKey('invalid')    // 'invalid' (فرمت نامعتبر)
/// ```
String _normalizeDayKey(final String raw) {
  final parts = raw.split('-');
  if (parts.length != 3) return raw;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return raw;

  // اگر سال بیشتر از 1500 باشد احتمالا شمسی است
  if (y > 1500) return raw;

  final dt = DateTime(y, m, d);
  final jalali = Jalali.fromDateTime(dt);
  return _dayKey(jalali);
}

/// ساخت کلید روز از تاریخ شمسی
///
/// این تابع یک تاریخ شمسی ([Jalali]) را به فرمت استاندارد کلید روز
/// (yyyy-MM-dd) تبدیل می‌کند.
///
/// فرمت خروجی: 'yyyy-MM-dd' که در آن:
/// - yyyy: سال به صورت 4 رقمی با padding صفر در سمت چپ
/// - MM: ماه به صورت 2 رقمی با padding صفر در سمت چپ
/// - dd: روز به صورت 2 رقمی با padding صفر در سمت چپ
///
/// [date]: تاریخ شمسی که باید به کلید روز تبدیل شود
///
/// Returns کلید روز به فرمت 'yyyy-MM-dd' (مثلا '1403-01-15')
///
/// مثال:
/// ```dart
/// _dayKey(Jalali(1403, 1, 15))  // '1403-01-15'
/// _dayKey(Jalali(1402, 12, 5))  // '1402-12-05'
/// _dayKey(Jalali(1400, 3, 1))   // '1400-03-01'
/// ```
String _dayKey(final Jalali date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// دریافت کلید روز قبل از یک کلید روز
///
/// این تابع کلید روز قبل از یک کلید روز داده شده را محاسبه می‌کند.
/// برای مثال، اگر کلید روز '1403-01-15' باشد، کلید روز قبل '1403-01-14' خواهد بود.
///
/// این تابع برای بررسی تداخل شیفت‌های شب روز قبل با شیفت‌های روز جاری استفاده می‌شود.
///
/// فرمت ورودی: 'yyyy-MM-dd' (شمسی)
/// فرمت خروجی: 'yyyy-MM-dd' (شمسی)
///
/// [dayKey]: کلید روز به فرمت 'yyyy-MM-dd' (شمسی)
///
/// Returns کلید روز قبل به فرمت 'yyyy-MM-dd' (شمسی).
///         اگر فرمت ورودی نامعتبر باشد، همان مقدار ورودی برمی‌گردد.
///
/// مثال:
/// ```dart
/// _getPreviousDayKey('1403-01-15') // '1403-01-14'
/// _getPreviousDayKey('1403-01-01') // '1402-12-29' (روز قبل از اول ماه)
/// _getPreviousDayKey('1403-12-29') // '1403-12-28'
/// ```
String _getPreviousDayKey(final String dayKey) {
  final parts = dayKey.split('-');
  if (parts.length != 3) return dayKey;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return dayKey;

  final jalali = Jalali(y, m, d).addDays(-1);
  return _dayKey(jalali);
}
