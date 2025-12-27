import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../core/core.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import '../project/task/task_details_page.dart';

mixin NotificationController {
  final NotificationDataSource _datasource = Get.find<NotificationDataSource>();
  final core = Get.find<Core>();
  final RxList<INotificationReadDto> notifications = <INotificationReadDto>[].obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  int pageNumber = 1;
  final RefreshController refreshController = RefreshController();
  bool isAtEnd = false;

  void disposeItems() {
    refreshController.dispose();
    pageState.close();
    notifications.close();
  }

  bool isNotificationSupported(final INotificationReadDto notification) {
    if (notification is TaskNotificationReadDto ||
        notification is SubtaskNotificationReadDto ||
        notification is CustomerNotificationReadDto ||
        notification is FollowupNotificationReadDto) {
      return true;
    }
    return false;
  }

  String getIcon(final INotificationReadDto notification) {
    if (notification is TaskNotificationReadDto || notification is SubtaskNotificationReadDto) {
      return AppIcons.bordColor;
    } else if (notification is CustomerNotificationReadDto || notification is FollowupNotificationReadDto) {
      return AppIcons.crmModule;
    } else {
      return AppIcons.info;
    }
    // notification.customData?.dataType == NotificationDataType.project_task || notification.customData?.dataType == NotificationDataType.task_chek_list
    //     ? AppIcons.bordColor
    //     : notification.customData?.dataType == NotificationDataType.mail_manager
    //     ? AppIcons.mailColor
    //     : notification.customData?.dataType == NotificationDataType.plan_member
    //     ? AppIcons.calendarColor
    //     : notification.customData?.dataType == NotificationDataType.customer
    //     ? AppIcons.crmModule
    //     : '',
  }

  void initialController() {
    onRefresh();
  }

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getNotifications();
  }

  void loadMore() {
    pageNumber++;
    _getNotifications();
  }

  void _getNotifications() async {
    _datasource.getNotifications(
      workspaceId: core.currentWorkspace.value.id,
      pageNumber: pageNumber,
      onResponse: (final response) {
        if (notifications.subject.isClosed || response.resultList == null) return;
        if (pageNumber == 1) {
          core.resetUnreadNotificationsCount();
          notifications(response.resultList);
          refreshController.refreshCompleted();
        } else {
          notifications.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          isAtEnd = true;
        } else {
          refreshController.loadComplete();
          isAtEnd = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.isInitial()) {
          pageState.error();
        }

        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
    );
  }

  void onTabNotification(final INotificationReadDto notification) {
    if (notification is TaskNotificationReadDto) {
      if (notification.task?.projectId == null) return;
      UNavigator.push(
        TaskDetailsPage(
          projectId: notification.task!.projectId!,
          task: notification.task!,
          onEdit: (final model) {},
          onDelete: () {},
        ),
      );
      return;
    } else if (notification is SubtaskNotificationReadDto) {
      if (notification.subtask?.taskData?.projectId == null) return;
      UNavigator.push(
        TaskDetailsPage(
          projectId: notification.subtask!.projectId!,
          task: notification.subtask!.taskData!,
          scrollToSubtaskId: notification.subtask!.id,
          onEdit: (final model) {},
          onDelete: () {},
        ),
      );
      return;
    } else if (notification is CustomerNotificationReadDto || notification is FollowupNotificationReadDto) {
      return;
    } else {
      AppNavigator.snackbarRed(title: s.warning, subtitle: 'در این نسخه امکان باز کردن این اعلان وجود ندارد');
      return;
    }

    // UNavigator.push(
    //   LetterDetailPage(
    //     mail: LetterReadDto(recipients: []),
    //     mailId: notification.customData?.mailId,
    //     onUpdated: (final mail) {},
    //   ),
    // );
  }
}
