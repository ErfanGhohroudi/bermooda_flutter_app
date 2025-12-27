import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/crm_categories_dropdown/crm_categories_dropdown.dart';
import '../../../../core/widgets/fields/projects_dropdown/projects_dropdown.dart';
import '../../../../core/core.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin CalendarController {
  final CalendarDatasource _calendarDatasource = Get.find<CalendarDatasource>();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final SubscriptionService subService = Get.find<SubscriptionService>();
  final PermissionService perService = Get.find<PermissionService>();
  late AnimationController animationController;
  late Animation<double> fade;
  final Rx<bool> isCompactCalenderVisible = false.obs;
  final Rx<bool> isCreateEventEnable = true.obs;
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> listState = PageState.loading.obs;
  final Rx<Jalali> monthAndYearSelected = Jalali.now().withDay(1).obs;
  final Rx<Jalali> dateTimeSelected = Jalali.now().obs;
  final List<String> persianWeekDays = ["ش", "ی", "د", "س", "چ", "پ", "ج"];
  final List<String> englishWeekDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  final RxList<CalendarReadDto> eventsCountList = <CalendarReadDto>[].obs;

  CalendarFilterType filterType = CalendarFilterType.all;

  List<MeetingReadDto> meetingList = [];
  List<SubtaskReadDto> checklistList = [];
  List<CustomerReadDto> customerList = [];
  final RxList<dynamic> events = <dynamic>[].obs;

  int get firstWeekDay => monthAndYearSelected.value.withDay(1).weekDay - 1;

  int get monthLength => monthAndYearSelected.value.monthLength;

  Jalali get today => Jalali(Jalali.now().year, Jalali.now().month, Jalali.now().day);

  bool get dateTimeSelectedIsToday =>
      dateTimeSelected.value.year == Jalali.now().year &&
      dateTimeSelected.value.month == Jalali.now().month &&
      dateTimeSelected.value.day == Jalali.now().day;

  bool isAtThisMonth(final Jalali date) =>
      monthAndYearSelected.value.year == date.year && monthAndYearSelected.value.month == date.month;

  bool isThisDay(final Jalali date) =>
      dateTimeSelected.value.year == date.year &&
      dateTimeSelected.value.month == date.month &&
      dateTimeSelected.value.day == date.day;

  StreamSubscription<bool>? _showScrollToTopWorker;

  void disposeItems() {
    scrollController.removeListener(_scrollListener);
    fade.removeListener(_fadeListener);
    refreshController.dispose();
    scrollController.dispose();
    animationController.dispose();
    isCompactCalenderVisible.close();
    isCreateEventEnable.close();
    _showScrollToTopWorker?.cancel();
    showScrollToTop.close();
    listState.close();
    monthAndYearSelected.close();
    dateTimeSelected.close();
    eventsCountList.close();
    events.close();
  }

  void initialController(final TickerProvider tickerProvider) {
    getEvents();
    _setupScrollControllerListeners(tickerProvider);
  }

  void _setupScrollControllerListeners(final TickerProvider tickerProvider) {
    scrollController.addListener(_scrollListener);

    animationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 300),
    );
    fade = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    fade.addListener(_fadeListener);
    _showScrollToTopWorker = showScrollToTop.listen((final visible) {
      if (visible) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void _fadeListener() {
    if (fade.value == 0) {
      isCompactCalenderVisible(false);
    } else {
      if (!isCompactCalenderVisible.value) {
        isCompactCalenderVisible(true);
      }
    }
  }

  void increaseMonth() {
    monthAndYearSelected(monthAndYearSelected.value.addMonths(1));
    _getEventsCount();
  }

  void decreaseMonth() {
    monthAndYearSelected(monthAndYearSelected.value.addMonths(-1));
    _getEventsCount();
  }

  /// Resets calendar to today's date
  void resetToToday() {
    final today = Jalali.now();
    if (monthAndYearSelected.value.year != today.year || monthAndYearSelected.value.month != today.month) {
      monthAndYearSelected(today.withDay(1)); // Update selected date
      _getEventsCount();
    }
    updateSelectedDate(today); // Update selected date
  }

  /// Update selected date
  void updateSelectedDate(final Jalali selectedDate) {
    final newDate = Jalali(selectedDate.year, selectedDate.month, selectedDate.day);
    final oldDate = Jalali(dateTimeSelected.value.year, dateTimeSelected.value.month, dateTimeSelected.value.day);

    bool selectedDateIsNotInThisMonth() =>
        monthAndYearSelected.value.year != dateTimeSelected.value.year ||
        monthAndYearSelected.value.month != dateTimeSelected.value.month;

    // Check that new date is different or not
    if (newDate.isBefore(oldDate) || newDate.isAfter(oldDate)) {
      dateTimeSelected(selectedDate); // Update selected date
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      if (selectedDateIsNotInThisMonth()) {
        monthAndYearSelected(selectedDate.withDay(1));
        getEvents();
      } else {
        _getDayEvents();
      }
      isCreateEventEnable(dateTimeSelected.value.isAfter(today) || dateTimeSelectedIsToday);
    }
  }

  void getEvents() {
    _getEventsCount();
    _getDayEvents();
  }

  /// Get selected month's events count
  void _getEventsCount() {
    eventsCountList.clear();
    _calendarDatasource.getAllDays(
      year: monthAndYearSelected.value.year,
      month: monthAndYearSelected.value.month,
      onResponse: (final response) {
        eventsCountList(response.resultList);
      },
      onError: (final errorResponse) {
        refreshController.refreshFailed();
      },
    );
  }

  /// Get selected day's events
  void _getDayEvents() {
    listState.loading();

    String yyyyFromDateTime(final int i) {
      final str = i.toString();
      if (str.length == 3) return '0$str';
      return str;
    }

    String mmFromDateTime(final int i) {
      final str = i.toString();
      return str.length == 1 ? '0$str' : str;
    }

    String ddFromDateTime(final int i) {
      final str = i.toString();
      return str.length == 1 ? '0$str' : str;
    }

    _calendarDatasource.getADay(
      year: yyyyFromDateTime(dateTimeSelected.value.toDateTime().year),
      month: mmFromDateTime(dateTimeSelected.value.toDateTime().month),
      day: ddFromDateTime(dateTimeSelected.value.toDateTime().day),
      onResponse: (final response) {
        meetingList = response.result?.meetings ?? [];
        checklistList = response.result?.checklists ?? [];
        customerList = response.result?.customers ?? [];
        setEventsList();
        refreshController.refreshCompleted();
      },
      onError: (final errorResponse) {
        refreshController.refreshFailed();
      },
    );
  }

  /// Set [events] and Sort it and Refresh ListView
  void setEventsList() {
    switch (filterType) {
      case CalendarFilterType.meetings:
        events(meetingList);
        break;

      case CalendarFilterType.checklists:
        events(checklistList);
        break;

      case CalendarFilterType.customers:
        events(customerList);
        break;

      default:
        events([...meetingList, ...checklistList, ...customerList]);
    }

    try {
      events.sort(
        (final a, final b) {
          final aStartTime = a is MeetingReadDto
              ? int.tryParse(a.startMeetingTime?.replaceAll(':', '') ?? '') ?? 0
              : a is SubtaskReadDto
              ? int.tryParse(a.timeToEnd?.replaceAll(':', '') ?? a.timeToStart?.replaceAll(':', '') ?? '') ?? 0
              : a is CustomerReadDto
              ? 0
              : 3000;

          final bStartTime = b is MeetingReadDto
              ? int.tryParse(b.startMeetingTime?.replaceAll(':', '') ?? '') ?? 0
              : b is SubtaskReadDto
              ? int.tryParse(a.timeToEnd?.replaceAll(':', '') ?? a.timeToStart?.replaceAll(':', '') ?? '') ?? 0
              : b is CustomerReadDto
              ? 0
              : 3000;

          return aStartTime.compareTo(bStartTime);
        },
      );
    } catch (e) {
      debugPrint("failed sort events");
    }
    delay(
      50,
      () {
        listState.loaded();
        listState.refresh();
      },
    );
  }

  void createTask({required final Function(ProjectReadDto project) onConfirmed}) {
    ProjectReadDto? selectedProject;

    bottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          WProjectsDropdownFormField(
            value: selectedProject,
            onChanged: (final value) {
              selectedProject = value;
            },
          ).marginOnly(top: 15),
          Text(
            s.projectHelperText,
          ).bodyMedium(color: navigatorKey.currentContext!.theme.hintColor).marginOnly(bottom: 27, top: 5),
          UElevatedButton(
            width: double.maxFinite,
            title: s.confirm,
            onTap: () {
              if (selectedProject != null) {
                UNavigator.back();
                Future.delayed(const Duration(milliseconds: 50), () {
                  onConfirmed(selectedProject!);
                });
              }
            },
          ).marginOnly(top: 100),
        ],
      ),
    );
  }

  void createCustomer({required final Function(CrmCategoryReadDto category) onConfirmed}) {
    CrmCategoryReadDto? selectedCategory;

    bottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          WCrmCategoriesDropdownFormField(
            value: selectedCategory,
            onChanged: (final value) {
              selectedCategory = value;
            },
          ).marginOnly(top: 15),
          Text(
            s.crmGroupHelperText,
          ).bodyMedium(color: navigatorKey.currentContext!.theme.hintColor).marginOnly(bottom: 27, top: 5),
          UElevatedButton(
            width: double.maxFinite,
            title: s.confirm,
            onTap: () {
              if (selectedCategory != null) {
                UNavigator.back();
                Future.delayed(const Duration(milliseconds: 50), () {
                  onConfirmed(selectedCategory!);
                });
              }
            },
          ).marginOnly(top: 100),
        ],
      ),
    );
  }
}
