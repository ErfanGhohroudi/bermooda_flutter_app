import 'package:u/utilities.dart';

import '../../../core/utils/extensions/date_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import 'notification_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with NotificationController {
  @override
  void initState() {
    initialController();
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
      body: Stack(
        children: [
          Obx(
            () {
              if (pageState.isLoaded() && notifications.isEmpty) {
                return Center(child: WEmptyWidget(title: s.noNotifications));
              }

              if (pageState.isError()) {
                return Center(child: WErrorWidget(onTapButton: onTryAgain));
              }

              return const SizedBox.shrink();
            },
          ),
          Obx(
            () {
              if (pageState.isInitial() || pageState.isLoading()) {
                return _buildShimmerLoading();
              }

              if (pageState.isError()) {
                return const SizedBox.shrink();
              }

              return WSmartRefresher(
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: loadMore,
                child: ListView.builder(
                  itemCount: notifications.length,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: isAtEnd ? 100 : 10),
                  itemBuilder: (final context, final index) => _notificationItem(notifications[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _notificationItem(final INotificationReadDto notification) {
    final isSupported = isNotificationSupported(notification);
    final mainColor = notification.isRead ? null : AppColors.red.withValues(alpha: 0.03);
    final notSupportedColor = AppColors.orange.withValues(alpha: 0.1);

    final color = isSupported ? mainColor : notSupportedColor;

    return WCard(
      showBorder: true,
      color: color,
      child: Row(
        crossAxisAlignment: isSupported ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              boxShadow: [
                BoxShadow(
                  color: context.theme.shadowColor,
                  blurRadius: 10,
                  offset: isPersianLang ? const Offset(-2, 2) : const Offset(2, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: context.theme.cardColor,
              radius: 25,
              child: UImage(getIcon(notification), size: 25),
            ),
          ),
          if (isSupported)
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 5,
                    children: [
                      Flexible(
                        child: Text(
                          notification.title ?? '',
                          maxLines: 2,
                        ).bodyMedium(overflow: TextOverflow.ellipsis, color: Colors.orange).bold(),
                      ),
                      Text(
                        notification.createdAt.toJalaliDateTimeString,
                        textDirection: TextDirection.ltr,
                      ).bodyMedium(color: context.theme.hintColor),
                    ],
                  ),
                  Text(notification.subTitle ?? '').bodyMedium(),
                ],
              ),
            )
          else
            Text(s.notSupportedItem).bodyMedium(),
        ],
      ),
      onTap: () => onTabNotification(notification),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 15,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemBuilder: (final context, final index) => WCard(child: SizedBox(width: context.width, height: 50)),
    ).shimmer();
  }
}
