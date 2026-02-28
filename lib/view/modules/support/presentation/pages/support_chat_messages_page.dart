import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:bermooda_business/core/core.dart';
import 'package:bermooda_business/core/theme.dart';
import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../../conversation/presentation/widgets/typing_indicator_widget.dart';
import '../../domain/entities/support_message.dart';
import '../../domain/entities/support_room_entity.dart';
import '../../domain/enums/room_connection_state.dart';
import '../controllers/support_chat_controller.dart';
import '../widgets/chat/massage_action_menu.dart';
import '../widgets/chat/message_bubble_widget.dart';
import '../widgets/support_chat_input_widget.dart';

class SupportChatMessagesPage extends GetView<SupportChatController> {
  final SupportRoomEntity room;

  const SupportChatMessagesPage({
    super.key,
    required this.room,
  });

  @override
  String? get tag => 'room_${room.id}';

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        controller.onPopScope();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.anonymousUser?.fullName ?? '- -',
                style: context.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              Obx(() {
                /// WS Connection Status
                if (controller.connectionState.value != RoomConnectionState.done) {
                  return Text(controller.connectionState.value.title).bodyMedium(color: context.theme.hintColor);
                }

                /// Is Typing
                if (controller.isCustomerTyping.value) {
                  return Text(
                    isPersianLang ? 'در حال تایپ...' : 'typing...',
                  ).bodySmall(
                    fontSize: 10,
                    color: context.theme.hintColor,
                  );
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(AppImages.chatBg),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                context.isDarkMode ? Colors.white : Colors.black54,
                BlendMode.srcIn,
              ),
            ),
          ),
          child: Column(
            children: [
              /// Search Box
              // _buildSearchBox(),

              /// loading & empty widget & message list
              Expanded(
                child: Stack(
                  children: [
                    Obx(() {
                      if (controller.isLoadingPage.value == true) {
                        return const Center(child: WCircularLoading());
                      }

                      if (controller.isLoadingPage.value == false && controller.messages.isEmpty) {
                        return const Center(child: WEmptyWidget());
                      }

                      return ListView.builder(
                        itemCount: controller.messages.length,
                        controller: controller.scrollController,
                        addAutomaticKeepAlives: true,
                        addRepaintBoundaries: true,
                        cacheExtent: 500,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: (final context, final index) {
                          final message = controller.messages[index];
                          final valueKey = message.id;

                          // Memoization برای محاسبات
                          final showFirstChatMessageDateSeparator = (index + 1) == controller.chatMessagesCount;
                          final showDateSeparator =
                              index + 1 < controller.messages.length &&
                              controller.messages[index + 1].created.toJalali().formatCompactDate() !=
                                  message.created.toJalali().formatCompactDate();

                          return RepaintBoundary(
                            key: ValueKey('message_$valueKey'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Get More Message Loading
                                _buildGetMoreMessageLoading(index),

                                /// Date Separator
                                if (showFirstChatMessageDateSeparator || showDateSeparator)
                                  _buildDataTimeSeparator(context, controller.messages, index),

                                /// Message Widget
                                AutoScrollTag(
                                  key: ValueKey(index),
                                  controller: controller.scrollController,
                                  index: index,
                                  highlightColor: context.theme.hintColor.withAlpha(50),
                                  child: _buildMessageWidget(index),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                    WScrollToTopButton(
                      scrollController: controller.scrollController,
                      show: controller.showScrollToTop,
                      bottomMargin: 16,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ],
                ),
              ),

              // Typing indicator
              Obx(() {
                if (controller.isCustomerTyping.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TypingIndicatorWidget(
                        isTyping: true,
                        isGroup: false,
                        typingUsers: [],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              SupportChatInputWidget(controller: controller),
            ],
          ),
        ).onTap(() => FocusManager.instance.primaryFocus?.unfocus()),
      ),
    );
  }

  Widget _buildDataTimeSeparator(final BuildContext context, final List<SupportMessage> messagesList, final int index) => Row(
    children: [
      const Flexible(child: Divider()),
      Text(
        messagesList[index].created.toJalali().formatCompactDate(),
      ).bodyMedium(color: context.theme.hintColor).marginSymmetric(horizontal: 10),
      const Flexible(child: Divider()),
    ],
  ).marginSymmetric(vertical: 6);

  Widget _buildGetMoreMessageLoading(final int index) {
    return Obx(() {
      if (controller.isLoadingMore.value && index + 1 == controller.messages.length) {
        return SizedBox(
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [const WCircularLoading(size: 12, strokeWidth: 2), Text(s.loading).bodySmall()],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildMessageWidget(final int index) {
    final message = controller.messages[index];
    final isOperator = message.isOperator;

    final senderUser = isOperator
        ? message.operatorUser
        : message.anonymousUser ??
              (controller.room.anonymousUser != null
                  ? UserReadDto(
                      id: controller.room.anonymousUser?.id.toString() ?? '',
                      fullName: controller.room.anonymousUser?.fullName,
                      phoneNumber: controller.room.anonymousUser?.phoneNumber,
                    )
                  : null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: MessageActionMenu(
        controller: controller,
        message: message,
        isOwn: isOperator,
        child: Directionality(
          textDirection: isOperator ? TextDirection.rtl : TextDirection.ltr,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 6,
            children: [
              WCircleAvatar(user: senderUser, size: 30),
              Flexible(
                child: MessageBubbleWidget(
                  key: ValueKey(message.id),
                  controller: controller,
                  message: message,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
