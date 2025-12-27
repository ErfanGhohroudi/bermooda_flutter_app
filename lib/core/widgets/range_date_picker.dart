part of "widgets.dart";

class WRangeDatePicker extends StatefulWidget {
  WRangeDatePicker({
    required this.onConfirm,
    this.startDate,
    this.initialDate,
    this.showYearSelector = false,
    this.enableClearButton = true,
    super.key,
  });

  final Function(RangeDatePickerViewModel data) onConfirm;
  final Jalali? startDate;
  final RangeDatePickerViewModel? initialDate;
  final bool showYearSelector;
  final bool enableClearButton;

  @override
  State<WRangeDatePicker> createState() => _WRangeDatePickerState();
}

class _WRangeDatePickerState extends State<WRangeDatePicker> {
  static const _maxWidth = 300.0;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final Rx<PageState> pageState = PageState.loaded.obs;
  final Rx<Jalali> monthAndYearSelected = Jalali.now().withDay(1).obs;
  final Rx<RangeDatePickerViewModel> selectedData = RangeDatePickerViewModel().obs;
  final List<String> persianWeekDays = ["ش", "ی", "د", "س", "چ", "پ", "ج"];
  final List<String> englishWeekDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  Jalali? startDate;

  int get firstWeekDay => monthAndYearSelected.value.withDay(1).weekDay - 1;

  int get monthLength => monthAndYearSelected.value.monthLength;

  bool get showClearButton => widget.enableClearButton && widget.initialDate?.startDate != null;

  bool isDayActive(final Jalali date) => startDate != null
      ? date.formatCompactDate().numericOnly().toInt() >= (startDate?.formatCompactDate().numericOnly().toInt() ?? 0)
      : true;

  @override
  void initState() {
    startDate = widget.startDate != null ? Jalali(widget.startDate!.year, widget.startDate!.month, widget.startDate!.day) : null;
    monthAndYearSelected(widget.initialDate?.copyWith().startDate?.toJalali()?.withDay(1));
    selectedData(widget.initialDate?.copyWith());
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
    monthAndYearSelected(monthAndYearSelected.value.addMonths(1));
    pageState.refresh();
  }

  void decreaseMonth() {
    monthAndYearSelected(monthAndYearSelected.value.addMonths(-1));
    pageState.refresh();
  }

  /// Update selected date
  void updateSelectedDate(final Jalali date) {
    if (selectedData.value.startDate == null || (selectedData.value.startDate != null && selectedData.value.endDate != null)) {
      selectedData.value.startDate = date.formatCompactDate();
      selectedData.value.endDate = null;
    } else if (selectedData.value.endDate == null && selectedData.value.startDate != date.formatCompactDate()) {
      if ((selectedData.value.startDate?.numericOnly().toInt() ?? 0) < date.formatCompactDate().numericOnly().toInt()) {
        selectedData.value.endDate = date.formatCompactDate();
      } else {
        selectedData.value.startDate = date.formatCompactDate();
      }
    }
    pageState.refresh();
  }

  @override
  void dispose() {
    pageState.close();
    monthAndYearSelected.close();
    selectedData.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => pageState.isLoaded()
          ? Form(
              key: _formKey,
              child: WCard(
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
                        WDropDownFormField<String>(
                          enable: selectedData.value.startDate != null,
                          labelText:
                              "${s.startTime}${selectedData.value.startDate != null ? ' (${selectedData.value.startDate})' : ''}",
                          value: selectedData.value.startTime,
                          required: false,
                          deselectable: true,
                          items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots()),
                          onChanged: (final value) {
                            selectedData.value.startTime = value;
                          },
                        ).marginOnly(top: 18),
                        WDropDownFormField<String>(
                          enable: selectedData.value.startDate != null,
                          labelText:
                              "${s.dueTime}${selectedData.value.startDate != null ? ' (${selectedData.value.endDate ?? selectedData.value.startDate})' : ''}",
                          value: selectedData.value.dueTime,
                          required: false,
                          deselectable: true,
                          items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots()),
                          onChanged: (final value) {
                            selectedData.value.dueTime = value;
                          },
                        ).marginOnly(top: 18),

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
      onTap: () => widget.onConfirm(RangeDatePickerViewModel()),
    );
  }

  Widget _buildConfirmButton() {
    return UElevatedButton(
      title: s.confirm,
      backgroundColor: selectedData.value.startDate != null
          ? context.theme.primaryColor
          : context.theme.primaryColor.withAlpha(150),
      onTap: () {
        if (selectedData.value.startDate != null) {
          validateForm(
            key: _formKey,
            action: () {
              final errorText = selectedData.value.isValid();

              if (errorText != null) {
                return AppNavigator.snackbarRed(title: s.error, subtitle: errorText);
              }

              widget.onConfirm(selectedData.value);
            },
          );
        }
      },
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
      mainAxisSpacing: 4, // Vertical spacing between items
      crossAxisSpacing: 1, // Horizontal spacing between items
    ),
    itemCount: monthLength + firstWeekDay,
    // Total number of cells (days of the month + empty placeholders)
    itemBuilder: (final context, final index) {
      // Display empty placeholders for days before the start of the month
      if (index < firstWeekDay) {
        return const SizedBox();
      }

      final int day = index - firstWeekDay + 1; // Calculate the correct day number

      final Jalali thisDayDate = Jalali(monthAndYearSelected.value.year, monthAndYearSelected.value.month, day);

      final bool isStartDate = thisDayDate.formatCompactDate() == selectedData.value.startDate;

      final bool isEndDate = thisDayDate.formatCompactDate() == selectedData.value.endDate;

      bool isSelected() => isStartDate || isEndDate; // Check if the day is selected

      bool isInSelectedRange = false;
      // Check if the day is in selected range
      if (selectedData.value.startDate != null && selectedData.value.endDate != null) {
        isInSelectedRange =
            thisDayDate.formatCompactDate().numericOnly().toInt() > (selectedData.value.startDate?.numericOnly().toInt() ?? 0) &&
            thisDayDate.formatCompactDate().numericOnly().toInt() < (selectedData.value.endDate?.numericOnly().toInt() ?? 0);
      }

      final bool isToday =
          monthAndYearSelected.value.year == Jalali.now().year &&
          monthAndYearSelected.value.month == Jalali.now().month &&
          day == Jalali.now().day; // Check if the day is today

      final double radius = 10;

      final BorderRadius leftRadius = BorderRadius.horizontal(left: Radius.circular(radius));
      final BorderRadius rightRadius = BorderRadius.horizontal(right: Radius.circular(radius));
      final BorderRadius allRadius = BorderRadius.circular(radius);

      BorderRadiusGeometry? borderRadius() {
        if (isInSelectedRange) return null;

        if (isStartDate && isEndDate) {
          return allRadius;
        }

        if (isStartDate) {
          if (selectedData.value.endDate == null) return allRadius;
          if (isPersianLang) {
            return rightRadius;
          }
          return leftRadius;
        }

        if (isEndDate) {
          if (isPersianLang) {
            return leftRadius;
          }
          return rightRadius;
        }

        if (isToday && !isInSelectedRange) return allRadius;

        return null;
      }

      return Container(
        decoration: BoxDecoration(
          color: isSelected() || isInSelectedRange
              ? (isInSelectedRange ? context.theme.primaryColor.withAlpha(180) : context.theme.primaryColor)
              : Colors.transparent, // Highlight selected day
          shape: BoxShape.rectangle,
          borderRadius: borderRadius(),
          border: isToday ? Border.all(color: context.theme.primaryColor, width: 1) : null, // Add blue border for today
        ),
        alignment: Alignment.center,
        child: Text(day.toString()).bodyLarge(
          color: isDayActive(monthAndYearSelected.value.withDay(day))
              ? (isSelected() || isInSelectedRange ? Colors.white : null)
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
