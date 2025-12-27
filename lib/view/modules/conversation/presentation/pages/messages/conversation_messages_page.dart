import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:bermooda_business/core/theme.dart';
import 'package:bermooda_business/data/data.dart';
import 'package:bermooda_business/view/modules/conversation/data/dto/conversation_dtos.dart';
import 'package:bermooda_business/view/modules/conversation/presentation/pages/messages/conversation_messages_controller.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../widgets/message_bubble/feedback_bubble_widget.dart';
import '../../widgets/message_bubble/message_bubble_widget.dart';
import '../../widgets/message_input_widget.dart';
import '../../widgets/typing_indicator_widget.dart';

class ConversationMessagesPage extends StatefulWidget {
  const ConversationMessagesPage({
    required this.conversation,
    super.key,
  });

  final ConversationDto conversation;

  @override
  State<ConversationMessagesPage> createState() => _ConversationMessagesPageState();
}

class _ConversationMessagesPageState extends State<ConversationMessagesPage> {
  late final ConversationMessagesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConversationMessagesController(conversation: widget.conversation.obs));
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        controller.onPopScope();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Search Box
              _buildSearchBox(),

              /// Pinned Messages Widget
              Obx(
                () => controller.pinnedMessages.isNotEmpty ? _buildPinnedMessagesWidget() : const SizedBox.shrink(),
              ),

              /// loading & empty widget & message list
              Flexible(
                child: Stack(
                  children: [
                    Obx(
                      () {
                        if (controller.pageState.isInitial() || controller.pageState.isLoading()) {
                          return const Center(child: WCircularLoading());
                        }

                        if (controller.pageState.isLoaded() && controller.messages.isEmpty) {
                          return const Center(child: WEmptyWidget());
                        }

                        /// Messages
                        return ListView.separated(
                          itemCount: controller.messages.length,
                          controller: controller.scrollController,
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,
                          cacheExtent: 500,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          separatorBuilder: (final context, final index) => _buildSpacerSeparator(controller.messages, index),
                          itemBuilder: (final context, final index) {
                            // استفاده از message.id به عنوان key به جای random
                            final message = controller.messages[index];
                            final valueKey = message.id;
                            final isFeedbackMessage = message is FeedbackDto;

                            // Memoization برای محاسبات
                            final showFirstChatMessageDateSeparator = (index + 1) == controller.chatMessagesCount;
                            final showDateSeparator =
                                index + 1 < controller.messages.length &&
                                controller.messages[index + 1].createdAt.toJalali().formatCompactDate() !=
                                    message.createdAt.toJalali().formatCompactDate();

                            return RepaintBoundary(
                              key: ValueKey('message_$valueKey'),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// Get More Message Loading
                                  _buildGetMoreMessageLoading(index),

                                  /// Date Separator
                                  if (showFirstChatMessageDateSeparator || showDateSeparator)
                                    _buildDataTimeSeparator(controller.messages, index),

                                  /// Message Widget
                                  AutoScrollTag(
                                    key: ValueKey(valueKey),
                                    controller: controller.scrollController,
                                    index: index,
                                    highlightColor: context.theme.hintColor.withAlpha(50),
                                    child: isFeedbackMessage ? _buildFeedbackMessage(index) : _buildMessageWidget(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    /// Scroll To Top Button
                    WScrollToTopButton(
                      scrollController: controller.scrollController,
                      show: controller.showScrollToTop,
                      bottomMargin: 16,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ],
                ),
              ),

              /// Message Input Widget
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Obx(
                  () {
                    if (controller.isMultiSelectMode.value) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UElevatedButton(
                            width: (context.width / 2) - 50,
                            title: s.forward,
                            icon: const Icon(CupertinoIcons.arrow_turn_up_right, size: 15, color: Colors.white),
                            onTap: controller.forwardSelectedMessages,
                          ),
                          if (controller.selectedMessageIds.length == 1)
                            UElevatedButton(
                              width: (context.width / 2) - 50,
                              title: s.reply,
                              icon: const UImage(AppIcons.reply, size: 15, color: Colors.white),
                              onTap: () {
                                controller.setReplyMessageByMessageId(controller.selectedMessageIds.first);
                                controller.exitMultiSelectMode();
                              },
                            ),
                        ],
                      ).pOnly(left: 16, right: 16, bottom: 16);
                    }

                    if (controller.isAnonymousBot) {
                      return Container(
                        color: context.theme.cardColor,
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                        child: UElevatedButton(
                          width: double.infinity,
                          title: s.sendAnonymousMessage,
                          onTap: () => controller.openSendAnonymousMessageBottomSheet(),
                        ),
                      );
                    }

                    return MessageInputWidget(controller: controller);
                  },
                ),
              ),
            ],
          ),
        ).onTap(() => FocusManager.instance.primaryFocus?.unfocus()),
      ),
    );
  }

  Widget _buildFeedbackMessage(final int index) {
    final message = controller.messages.cast<FeedbackDto>()[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: FeedbackBubbleWidget(message: message),
    );
  }

  Widget _buildMessageWidget(final int index) {
    if (controller.messages is List<FeedbackDto>) return const SizedBox.shrink();
    final message = controller.messages.cast<MessageDto>()[index];
    final isOwn = message.isOwner;

    // منطق نمایش avatar:
    // 1. فقط برای گروه
    // 2. اگر تنها پیام است، avatar را نشان بده
    // 3. اگر پیام بعدی از فرستنده دیگری است (آخرین پیام از این فرستنده)، avatar را نشان بده
    // 4. پیام نباید از خود کاربر باشد
    final isOnlyMessage = controller.messages.length == 1;
    final isLastMessageFromSender = index + 1 < controller.messages.length
        ? controller.messages.cast<MessageDto>()[index + 1].sender.id != message.sender.id
        : true;

    final showAvatar = controller.isGroup && !isOwn && (isOnlyMessage || isLastMessageFromSender);

    return Obx(
      () {
        final isMultiSelect = controller.isMultiSelectMode.value;
        final isSelected = controller.selectedMessageIds.contains(message.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: WithMainActionMenu(
            controller: controller,
            message: message,
            isOwn: isOwn,
            child: Container(
              padding: isSelected ? const EdgeInsetsDirectional.symmetric(vertical: 5) : null,
              decoration: BoxDecoration(
                color: isSelected ? context.theme.primaryColor.withAlpha(30) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isMultiSelect) ...[
                      WCheckBox(
                        isChecked: isSelected,
                        activeColor: context.theme.primaryColor,
                        borderColor: context.theme.primaryColor,
                        onChanged: (final value) {
                          controller.toggleMessageSelection(message.id);
                        },
                      ),
                    ],
                    Expanded(
                      child: Directionality(
                        textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 6,
                          children: [
                            // if (controller.isGroup && !isMultiSelect) ...[
                            if (controller.isGroup) ...[
                              if (!showAvatar && !isOwn) const SizedBox(width: 30),
                              if (showAvatar) WCircleAvatar(user: message.sender, size: 30),
                            ],
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
                    if (isMultiSelect) const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpacerSeparator(final List<MessageEntity> messagesList, final int index) {
    if (messagesList is List<FeedbackDto>) return const SizedBox.shrink();
    try {
      if (index >= messagesList.length - 1) return const SizedBox.shrink();
      return messagesList.cast<MessageDto>()[index + 1].sender.id != messagesList.cast<MessageDto>()[index].sender.id
          ? const SizedBox(height: 20)
          : const SizedBox.shrink();
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildDataTimeSeparator(final List<MessageEntity> messagesList, final int index) => Row(
    children: [
      const Flexible(child: Divider()),
      Text(
        messagesList[index].createdAt.toJalali().formatCompactDate(),
      ).bodyMedium(color: context.theme.hintColor).marginSymmetric(horizontal: 10),
      const Flexible(child: Divider()),
    ],
  ).marginOnly(bottom: 10);

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(
        () {
          if (controller.isMultiSelectMode.value) {
            // Multi-select mode AppBar
            return AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: controller.exitMultiSelectMode,
              ),
              title: Text(controller.selectedMessageIds.length.toString().separateNumbers3By3()),
              actions: [
                IconButton(
                  onPressed: controller.copySelectedMessagesTexts,
                  tooltip: s.copyText,
                  icon: const UImage(AppIcons.copyOutline, color: Colors.white),
                ),
                IconButton(
                  onPressed: controller.forwardSelectedMessages,
                  tooltip: s.forward,
                  icon: const Icon(CupertinoIcons.arrow_turn_up_right, color: Colors.white),
                ),
                IconButton(
                  onPressed: controller.deleteSelectedMessages,
                  tooltip: s.delete,
                  icon: const UImage(AppIcons.delete, color: Colors.white),
                ),
              ],
            );
          }

          // Normal mode AppBar
          return AppBar(
            title: Row(
              children: [
                Obx(
                  () => WCircleAvatar(
                    size: 40,
                    user: UserReadDto(
                      id: controller.conversation.value.id,
                      fullName: controller.conversation.value.displayName,
                      avatarUrl: controller.isAnonymousBot ? AppImages.bot : controller.conversation.value.avatarUrl,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () =>
                          Text(
                            controller.conversation.value.displayName,
                            maxLines: 1,
                          ).bodyMedium(
                            fontSize: 16,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    Obx(
                      () {
                        /// WS Connection Status
                        if (controller.connectionState.value != ChatConnectionType.done) {
                          return Text(controller.connectionState.value.getTitle()).bodyMedium(color: context.theme.hintColor);
                        }

                        /// Is Typing
                        if (controller.isTyping.value) {
                          List<String> typingUsers = [];
                          final typingUsersKeys = controller.typingUsers.keys.toList();
                          for (String key in typingUsersKeys) {
                            final a = controller.typingUsers[key];
                            if (a == true) {
                              typingUsers.add(key);
                            }
                          }
                          return TypingIndicatorWidget(
                            isTyping: controller.isTyping.value,
                            isGroup: controller.isGroup,
                            typingUsers: typingUsers,
                          );
                        }

                        /// Members Count
                        if (controller.isGroup) {
                          return Text(
                            "${controller.conversation.value.members.length} "
                            "${isPersianLang == false && controller.conversation.value.members.length <= 1 ? s.member.removeLast() : s.member}",
                          ).bodyMedium(color: context.theme.hintColor);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              if (!controller.isAnonymousBot) ...[
                IconButton(
                  onPressed: controller.toggleSearchBoxVisible,
                  tooltip: s.search,
                  icon: const UImage(AppIcons.searchOutline, color: Colors.white),
                ),
                if (controller.isGroup)
                  IconButton(
                    onPressed: controller.navigateToGroupSettingsPage,
                    tooltip: s.settings,
                    icon: const UImage(AppIcons.settingsOutline, color: Colors.white),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildPinnedMessagesWidget() {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () {
          final currentPinned = controller.currentPinnedMessage;
          if (currentPinned == null) return const SizedBox.shrink();

          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.scrollToPinnedMessage(currentPinned.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        const Icon(Icons.push_pin, size: 16, color: AppColors.primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentPinned.sender.fullName ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).bodySmall(),
                              Text(
                                currentPinned.type.title ?? currentPinned.text ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).bodySmall(color: context.theme.hintColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.pinnedMessages.length > 1) ...[
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  tooltip: s.previous,
                  onPressed: controller.currentPinnedIndex.value > 0 ? controller.showPreviousPinnedMessage : null,
                ),
                Text(
                  '${controller.currentPinnedIndex.value + 1}/${controller.pinnedMessages.length}',
                ).bodySmall(),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  tooltip: s.next,
                  onPressed: controller.currentPinnedIndex.value < controller.pinnedMessages.length - 1
                      ? controller.showNextPinnedMessage
                      : null,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBox() {
    return Obx(() {
      return AnimatedSize(
        duration: 300.milliseconds,
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          color: context.theme.cardColor,
          child: controller.showSearchBox.value
              ? Row(
                  children: [
                    WSearchField(
                      controller: controller.searchCtrl,
                      height: 50,
                      borderRadius: 0,
                      withClearIcon: false,
                      onChanged: (final value) => controller.searchInMessages(),
                    ).expanded(),
                    Obx(
                      () {
                        if (controller.searchResults.isNotEmpty) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: controller.nextSearchResult,
                                icon: Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: controller.currentSearchResultIndex.value + 1 >= controller.searchResults.length
                                      ? Colors.grey
                                      : null,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "${controller.currentSearchResultIndex.value + 1} ${s.from} ${controller.searchResults.length}",
                                ).bodyMedium(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: controller.previousSearchResult,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: controller.currentSearchResultIndex.value == 0 ? Colors.grey : null,
                                ),
                              ),
                            ],
                          );
                        }

                        if (controller.searchResults.isEmpty && controller.searchCtrl.text.trim().length >= 2) {
                          return Text(s.noResult).bodySmall(color: Colors.grey);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    IconButton(onPressed: controller.toggleSearchBoxVisible, icon: const Icon(Icons.close)),
                  ],
                )
              : null,
        ),
      );
    });
  }

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
}
