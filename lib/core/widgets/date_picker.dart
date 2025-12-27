part of "widgets.dart";

class WDatePicker extends StatefulWidget {
  WDatePicker({
    required this.onConfirm,
    this.startDate,
    this.initialDate,
    this.showYearSelector = false,
    this.enableClearButton = true,
    super.key,
  }) : assert(initialDate != null && startDate != null ? !initialDate.isBefore(startDate) : true);

  final Function(Jalali? date) onConfirm;
  final Jalali? startDate;
  final Jalali? initialDate;
  final bool showYearSelector;
  final bool enableClearButton;

  @override
  State<WDatePicker> createState() => _WDatePickerState();
}

class _WDatePickerState extends State<WDatePicker> {
  static const _maxWidth = 300.0;

  final Rx<PageState> pageState = PageState.loaded.obs;
  final Rx<Jalali> monthAndYearSelected = Jalali.now().withDay(1).obs;
  final Rx<Jalali> dateTimeSelected = Jalali.now().obs;
  final List<String> persianWeekDays = ["ش", "ی", "د", "س", "چ", "پ", "ج"];
  final List<String> englishWeekDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  Jalali? startDate;

  int get firstWeekDay => monthAndYearSelected.value.withDay(1).weekDay - 1;

  int get monthLength => monthAndYearSelected.value.monthLength;

  bool get showClearButton => widget.enableClearButton && widget.initialDate != null;

  bool isDayActive(final Jalali date) => startDate != null
      ? date.formatCompactDate().numericOnly().toInt() >= (startDate?.formatCompactDate().numericOnly().toInt() ?? 0)
      : true;

  @override
  void initState() {
    startDate = widget.startDate != null ? Jalali(widget.startDate!.year, widget.startDate!.month, widget.startDate!.day) : null;
    monthAndYearSelected(widget.initialDate?.withDay(1));
    dateTimeSelected(widget.initialDate);
    super.initState();
  }

  void increaseYear() {
    monthAndYearSelected(monthAndYearSelected.value.addYears(1));
    pageState.refresh();
  }

  void decreaseYear() {
    monthAndYearSelected(monthAndYearSelected.value.addYears(-1));
    pageState.refresh();
  }

  void increaseMonth() {
    try {
      monthAndYearSelected(monthAndYearSelected.value.addMonths(1));
    } catch (e) {
      debugPrint(e.toString());
    }
    pageState.refresh();
  }

  void decreaseMonth() {
    monthAndYearSelected(monthAndYearSelected.value.addMonths(-1));
    pageState.refresh();
  }

  /// Update selected date
  void updateSelectedDate(final Jalali selectedDate) {
    final newDate = Jalali(selectedDate.year, selectedDate.month, selectedDate.day);
    final oldDate = Jalali(dateTimeSelected.value.year, dateTimeSelected.value.month, dateTimeSelected.value.day);

    // Check that new date is different or not
    if (newDate.isBefore(oldDate) || newDate.isAfter(oldDate)) {
      dateTimeSelected(selectedDate); // Update selected date
    }
    pageState.refresh();
  }

  @override
  void dispose() {
    pageState.close();
    monthAndYearSelected.close();
    dateTimeSelected.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => pageState.isLoaded()
          ? WCard(
              child: SizedBox(
                width: _maxWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showYearSelector) _yearSelector(),
                      _monthSelector(), // Month selection widget (previous/next buttons)
                      _weekDays(), // Displays the names of the week days
                      _monthDays().marginOnly(top: 5), // Displays the days of the month in a GridView
                      /// Buttons
                      Row(
                        children: [
                          if (showClearButton) _buildClearButton().expanded() else _buildCancelButton().expanded(),
                          const SizedBox(width: 10),
                          _buildConfirmButton().expanded(),
                        ],
                      ).marginOnly(top: 12),
                      if (showClearButton) _buildCancelButton(width: _maxWidth).marginOnly(top: 10),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  //-------------------------------------------------------------
  // Buttons
  //-------------------------------------------------------------

  Widget _buildCancelButton({final double? width}) {
    return UElevatedButton(
      title: s.cancel,
      width: width,
      backgroundColor: context.theme.hintColor,
      onTap: UNavigator.back,
    );
  }

  Widget _buildClearButton() {
    return UElevatedButton(
      title: s.clear,
      backgroundColor: AppColors.red,
      onTap: () => widget.onConfirm(Jalali(0)),
    );
  }

  Widget _buildConfirmButton() {
    return UElevatedButton(
      title: s.confirm,
      onTap: () => widget.onConfirm(dateTimeSelected.value),
    );
  }

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  //-------------------------------------------------------------

  /// Widget for the year selector bar
  Widget _yearSelector() {
    final textColor = context.theme.primaryColorDark;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Button to decrease the year
          Container(
            width: 30,
            height: 30,
            color: Colors.transparent,
            child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
          ).onTap(decreaseYear).withTooltip(s.previousYear),

          // Displays the current year
          Text("${monthAndYearSelected.value.year}").bodyLarge(color: textColor),

          // Button to increase the year
          Container(
            width: 30,
            height: 30,
            color: Colors.transparent,
            child: Icon(Icons.arrow_forward_ios_rounded, size: 20, color: textColor),
          ).onTap(increaseYear).withTooltip(s.nextYear),
        ],
      ),
    ).marginOnly(bottom: 10);
  }

  /// Widget for the month selector bar
  Widget _monthSelector() {
    final textColor = context.theme.primaryColorDark;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Button to decrease the month
          Container(
            width: 30,
            height: 30,
            color: Colors.transparent,
            child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
          ).onTap(decreaseMonth).withTooltip(s.previousMonth),

          if (widget.showYearSelector)
            Text(monthAndYearSelected.value.formatter.mN.getJalaliMonthNameFaEn()).bodyLarge(color: textColor)
          else
            Text(
              "${monthAndYearSelected.value.formatter.mN.getJalaliMonthNameFaEn()} ${monthAndYearSelected.value.year}",
            ).bodyLarge(color: textColor),

          // Button to increase the month
          Container(
            width: 30,
            height: 30,
            color: Colors.transparent,
            child: Icon(Icons.arrow_forward_ios_rounded, size: 20, color: textColor),
          ).onTap(increaseMonth).withTooltip(s.nextMonth),
        ],
      ),
    ).marginOnly(bottom: 10);
  }

  /// Widget to display the names of the weekdays
  Widget _weekDays() => Container(
    height: 25,
    decoration: BoxDecoration(
      color: context.theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: (isPersianLang ? persianWeekDays : englishWeekDays)
          .map(
            (final day) => Text(
              day,
            ).bodyMedium(),
          )
          .toList(),
    ),
  );

  /// Widget to display the days of the month as a `GridView`
  Widget _monthDays() => GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    // Disables internal scrolling
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7, // 7 columns for the days of the week
      mainAxisSpacing: 8, // Vertical spacing between items
      crossAxisSpacing: 8, // Horizontal spacing between items
    ),
    itemCount: monthLength + firstWeekDay,
    // Total number of cells (days of the month + empty placeholders)
    itemBuilder: (final context, final index) {
      // Display empty placeholders for days before the start of the month
      if (index < firstWeekDay) {
        return const SizedBox();
      }

      final int day = index - firstWeekDay + 1; // Calculate the correct day number

      final bool isSelected =
          monthAndYearSelected.value.year == dateTimeSelected.value.year &&
          monthAndYearSelected.value.month == dateTimeSelected.value.month &&
          day == dateTimeSelected.value.day; // Check if the day is selected

      final bool isToday =
          monthAndYearSelected.value.year == Jalali.now().year &&
          monthAndYearSelected.value.month == Jalali.now().month &&
          day == Jalali.now().day; // Check if the day is today

      return Container(
        decoration: BoxDecoration(
          color: isSelected ? navigatorKey.currentContext!.theme.primaryColor : Colors.transparent, // Highlight selected day
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: isToday
              ? Border.all(color: navigatorKey.currentContext!.theme.primaryColor, width: 1)
              : null, // Add blue border for today
        ),
        alignment: Alignment.center,
        child: Text(day.toString()).bodyLarge(
          color: isDayActive(monthAndYearSelected.value.withDay(day))
              ? (isSelected ? Colors.white : null)
              : context.theme.hintColor, // White text color for selected day
        ),
      ).onTap(() {
        // Set the selected day when tapped
        if (isDayActive(monthAndYearSelected.value.withDay(day))) {
          updateSelectedDate(monthAndYearSelected.value.withDay(day));
        }
      });
    },
  ).marginSymmetric(horizontal: 4);
}
