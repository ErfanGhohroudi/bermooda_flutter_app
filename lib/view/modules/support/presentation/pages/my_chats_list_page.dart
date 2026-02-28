import 'package:bermooda_business/core/core.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../controllers/my_chats_list_controller.dart';

class SupportMyChatsListPage extends GetView<SupportMyChatsListController> {
  const SupportMyChatsListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text("s.myReplies")),
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = controller.pageState.isLoaded() && controller.rooms.isEmpty;
              final showErrorWidget = controller.pageState.isError();
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
              if (showErrorWidget) return Center(child: WErrorWidget(onTapButton: controller.onTryAgain));
              return const SizedBox.shrink();
            },
          ),
          Column(
            children: [
              WSearchField(
                controller: controller.searchController,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => controller.onSearch(),
              ),
              Expanded(
                child: Obx(
                  () {
                    if (controller.pageState.isInitial() || controller.pageState.isLoading()) {
                      return ListView.builder(
                        itemCount: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (final context, final index) => WCard(
                          child: SizedBox(width: context.width, height: 100),
                        ),
                      ).shimmer();
                    }

                    if (controller.pageState.isError()) {
                      return const SizedBox.shrink();
                    }

                    return WSmartRefresher(
                      controller: controller.refreshController,
                      scrollController: controller.scrollController,
                      onRefresh: controller.onRefresh,
                      onLoading: controller.loadMore,
                      child: ListView.builder(
                        itemCount: controller.rooms.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        itemBuilder: (final context, final index) {
                          final room = controller.rooms[index];
                          return WCard(
                            onTap: () => controller.onTapRoom(room),
                            child: Row(
                              spacing: 4,
                              children: [
                                Column(
                                  crossAxisAlignment: .start,
                                  mainAxisSize: .min,
                                  spacing: 2,
                                  children: [
                                    Text(
                                      room.anonymousUser?.fullName ?? room.anonymousUser?.phoneNumber ?? '- -',
                                      maxLines: 2,
                                    ).titleMedium(overflow: .ellipsis),
                                    if (room.lastMessage != null)
                                      Text(
                                        room.lastMessage?.type.title ?? room.lastMessage?.body ?? '- -',
                                        maxLines: 1,
                                      ).bodyMedium(
                                        color: context.theme.hintColor,
                                        overflow: .ellipsis,
                                      ),
                                  ],
                                ).expanded(),
                                Column(
                                  crossAxisAlignment: .end,
                                  mainAxisSize: .min,
                                  spacing: 6,
                                  children: [
                                    Row(
                                      mainAxisSize: .min,
                                      spacing: 6,
                                      children: [
                                        WLabel(
                                          text: room.status.title,
                                          color: room.status.color,
                                        ),
                                        if (room.unreadCount > 0)
                                          UBadge(
                                            badgeColor: context.theme.primaryColor,
                                            alignment: Alignment.center,
                                            animationType: BadgeAnimationType.fade,
                                            position: const BadgePosition(bottom: 0),
                                            badgeContent: Text(
                                              room.unreadCount.toString().separateNumbers3By3(),
                                            ).bodySmall(color: Colors.white),
                                          ),
                                      ],
                                    ),
                                    if (room.lastMessage?.created != null)
                                      Text(
                                        room.lastMessage!.created!.toTimeAgo(persian: isPersianLang),
                                      ).bodySmall(color: context.theme.hintColor),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ).expanded(),
              ),
            ],
          ),
          WScrollToTopButton(
            scrollController: controller.scrollController,
            show: controller.showScrollToTop,
            bottomMargin: 90,
          ),
        ],
      ),
    );
  }
}
