import 'package:u/utilities.dart';

import '../../../../core/utils/extensions/date_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../../crm/board/widgets/customer_card/customer_card.dart';
import '../../../../core/widgets/subtask_card/subtask_card.dart';
import 'calendar_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with CalendarController, TickerProviderStateMixin {
  @override
  void initState() {
    initialController(this);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: _floatingActionButton(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          WSmartRefresher(
            controller: refreshController,
            scrollController: scrollController,
            enablePullUp: false,
            onRefresh: getEvents,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Calendar
                  _calendarWidget().marginOnly(top: 10, bottom: 8).pSymmetric(horizontal: 16),

                  /// Events List
                  _eventsList().pSymmetric(horizontal: 16),
                ],
              ),
            ),
          ),

          /// Compact Calendar
          FadeTransition(
            opacity: fade,
            child: Obx(
              () => Visibility(
                visible: isCompactCalenderVisible.value,
                child: _calendarWidget(
                  showCompactMonth: true,
                ),
              ),
            ),
          ),

          /// Scroll To Top Button
          WScrollToTopButton(
            scrollController: scrollController,
            show: showScrollToTop,
            bottomMargin: 90,
          ),
        ],
      ),
    ).safeArea();
  }

  Widget? _floatingActionButton() => FloatingActionButton(
        heroTag: "calendarFAB",
        onPressed: resetToToday,
        tooltip: s.today,
        child: Text(Jalali.now().day.toString()).bodyLarge(color: Colors.white),
      );

  Widget _calendarWidget({final bool showCompactMonth = false}) => Container(
        decoration: BoxDecoration(
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: showCompactMonth ? Radius.zero : const Radius.circular(30),
            topRight: showCompactMonth ? Radius.zero : const Radius.circular(30),
            bottomLeft: const Radius.circular(30),
            bottomRight: const Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _monthSelector(), // Month selection widget (previous/next buttons)
            _weekDays(), // Displays the names of the week days
            _monthDays(showCompactMonth: showCompactMonth).marginOnly(top: 5),
          ],
        ),
      );

  /// Widget for the month selector bar
  Widget _monthSelector() => Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
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
              child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: context.theme.primaryColor),
            ).onTap(decreaseMonth).withTooltip(s.previousMonth),

            // Displays the current month name and year
            Obx(
              () => Text("${monthAndYearSelected.value.formatter.mN.getJalaliMonthNameFaEn()} ${monthAndYearSelected.value.year}")
                  .bodyLarge(color: context.theme.primaryColor),
            ),

            // Button to increase the month
            Container(
              width: 30,
              height: 30,
              color: Colors.transparent,
              child: Icon(Icons.arrow_forward_ios_rounded, size: 20, color: context.theme.primaryColor),
            ).onTap(increaseMonth).withTooltip(s.nextMonth),
          ],
        ),
      ).marginOnly(bottom: 10);

  /// Widget to display the names of the weekdays
  Widget _weekDays() => SizedBox(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: (isPersianLang ? persianWeekDays : englishWeekDays)
              .map((final day) => Text(
                    day,
                  ).bodyMedium(color: Colors.white))
              .toList(),
        ),
      );

  /// Widget to display the days of the month as a `GridView`
  Widget _monthDays({final bool showCompactMonth = false}) => Obx(
        () {
          final totalDays = monthLength + firstWeekDay;

          List<Widget> dayWidgets = List.generate(totalDays, (final index) {
            if (index < firstWeekDay) return const SizedBox();

            final int day = index - firstWeekDay + 1;
            final int dayIndex = day - 1;

            final bool isSelected = monthAndYearSelected.value.year == dateTimeSelected.value.year &&
                monthAndYearSelected.value.month == dateTimeSelected.value.month &&
                day == dateTimeSelected.value.day;

            final bool isToday =
                monthAndYearSelected.value.year == Jalali.now().year && monthAndYearSelected.value.month == Jalali.now().month && day == Jalali.now().day;

            return UBadge(
              badgeContent: Text(
                eventsCountList.isNotEmpty ? (eventsCountList[dayIndex].count ?? 0).toString() : '',
                style: context.textTheme.bodySmall!.copyWith(
                  color: isSelected ? Colors.white : context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              showBadge: eventsCountList.isNotEmpty && (eventsCountList[dayIndex].count ?? 0) > 0,
              animationType: BadgeAnimationType.fade,
              badgeColor: isSelected ? context.theme.primaryColor : AppColors.yellow,
              position: const BadgePosition(bottom: -5),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday ? Border.all(color: Colors.white, width: 1) : null,
                ),
                alignment: Alignment.center,
                child: Text(day.toString()).bodyLarge(
                  color: isSelected ? context.theme.primaryColor : Colors.white,
                ),
              ).onTap(() {
                updateSelectedDate(monthAndYearSelected.value.withDay(day));
              }),
            );
          });

          if (showCompactMonth) {
            final selectedDay = dateTimeSelected.value.day;
            final selectedIndex = firstWeekDay + selectedDay - 1;
            final weekStart = (selectedIndex ~/ 7) * 7;
            final weekEnd = (weekStart + 7).clamp(0, dayWidgets.length);
            dayWidgets = dayWidgets.sublist(weekStart, weekEnd);
          }

          return GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: dayWidgets,
          ).marginSymmetric(horizontal: 4);
        },
      );

  Widget _eventsList() => Obx(
        () => listState.isLoaded()
            ? events.isNotEmpty
                ? ListView.builder(
                    itemCount: events.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (final context, final index) => events[index] is MeetingReadDto
                        ? _meetingWidget(index: index)
                        : events[index] is SubtaskReadDto
                            ? _subtaskWidget(index: index)
                            : events[index] is CustomerReadDto
                                ? _customerWidget(index: index)
                                : const SizedBox(),
                  )
                : const WEmptyWidget()
            : _loadingShimmerList(),
      );

  Widget _loadingShimmerList() => ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.only(bottom: 16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (final context, final index) => WCard(
          child: SizedBox(width: context.width, height: 60),
        ),
      ).shimmer();

  Widget _meetingWidget({required final int index}) {
    final meeting = events[index] as MeetingReadDto;

    return WMeetingItem(
      meeting: meeting,
      onEdited: (final model) {
        getEvents();
      },
      onDelete: () {
        events.removeAt(index);
        getEvents();
      },
    );
  }

  Widget _subtaskWidget({required final int index}) => WSubtaskCard(
        subtask: events[index] as SubtaskReadDto,
        showOwner: false,
        onChangedCheckBoxStatus: (final model) {
          final i = checklistList.indexOf(events[index] as SubtaskReadDto);
          if (i != -1) {
            checklistList[i] = model;
          }
          setEventsList();
        },
        onEdited: (final model) => getEvents(),
        onDelete: getEvents,
        // ).onTap(
        //   () {
        //     if (((events[index] as SubtaskReadDto).projectId ?? '') != '' && ((events[index] as SubtaskReadDto).taskData?.id?.toString() ?? '') != '') {
        //       UNavigator.push(TaskPage(
        //         taskId: (events[index] as SubtaskReadDto).taskData?.id,
        //         onChanged: (final model) => getEvents(),
        //       ));
        //     }
        //   },
        // );
      );

  Widget _customerWidget({required final int index}) => Obx(
        () {
          CustomerReadDto customer = events[index] as CustomerReadDto;

          return WCustomerCard(
            customer: customer,
            outerScrollController: scrollController,
            onChangedCheckBox: (final customer) => getEvents(),
            onStepChanged: (final customer) {
              final i = customerList.indexOf(events[index] as CustomerReadDto);
              if (i != -1) {
                customerList[i] = customer;
                setEventsList();
              }
            },
            onEdit: (final customer) => getEvents(),
            onDelete: (final customer) => getEvents(),
          );
        },
      );
}
