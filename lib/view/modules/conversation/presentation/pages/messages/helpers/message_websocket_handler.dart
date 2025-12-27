import 'dart:async';
import 'dart:developer' as developer;
import 'package:u/utilities.dart';

import '../../../../../../../../core/core.dart';
import '../../../../../../../../core/navigator/navigator.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../conversation_messages_controller.dart';

class MessageWebSocketHandler {
  MessageWebSocketHandler(this.controller);

  final ConversationMessagesController controller;

  late StreamSubscription _wsSubscription;
  late StreamSubscription _wsConnectionSubscription;

  void setupWebSocketListeners() {
    if (controller.repository.isConnected.value == false) {
      controller.connectionState(ChatConnectionType.connecting);
    }

    _wsConnectionSubscription = controller.repository.isConnected.listen((
      final connected,
    ) {
      if (connected) {
        controller.connectionState(ChatConnectionType.update);
        controller.getMessages();
      } else {
        controller.connectionState(ChatConnectionType.connecting);
      }
    });

    _wsSubscription = controller.repository.messagesStream.listen((final message) {
      handleWebSocketMessage(message);
    });
  }

  Future<void> handleWebSocketMessage(
    final Map<String, dynamic> message,
  ) async {
    try {
      final type = message['type'] as String?;

      switch (type) {
        case 'messages_list':
          if (controller.isAnonymousBot) return;
          if (message['conversation_id'] == controller.conversation.value.id) {
            try {
              if (message["extra"]?["count"] != null) {
                controller.chatMessagesCount = message["extra"]?["count"] as int;
              }

              final messagesList = (message['data'] as List?)?.map((final e) => MessageDto.fromMap(e)).toList() ?? [];

              final page = controller.currentPage;
              controller.currentPage = (message["extra"]?["next"] as int?) ?? 0;

              if (page == 1) {
                if (controller.messages.isNotEmpty) {
                  final sendingMessages = controller.messages
                      .cast<MessageDto>()
                      .where(
                        (final m) => m.clientId != null && (m.isSending || m.isFailed),
                      )
                      .toList();
                  controller.messages([...sendingMessages, ...messagesList]);
                } else {
                  controller.messages(messagesList);
                }
              } else {
                controller.messages.addAll(messagesList);
              }

              controller.pageState.loaded();
              controller.isLoadingMore(false);
              delay(1000, () => controller.connectionState(ChatConnectionType.done));

              if (controller.searchingForMessageId != null) {
                // Auto searching mode is enable
                controller.scrollManager.scrollToMessage(controller.searchingForMessageId!);
              }
              markAsRead();
            } catch (e) {
              AppNavigator.snackbarRed(title: s.error, subtitle: e.toString());
            }
          }
          break;

        case 'anonymous_feedbacks_list':
          if (controller.isAnonymousBot) {
            try {
              if (message["pagination"]?["total_count"] != null) {
                controller.chatMessagesCount = message["pagination"]?["total_count"] as int;
              }

              final anonymousMessagesList =
                  (message['feedbacks'] as List?)?.map((final e) => FeedbackDto.fromMap(e)).toList() ?? [];

              final page = controller.currentPage;
              controller.currentPage = (message["pagination"]?["next"] as int?) ?? 0;

              if (page == 1) {
                controller.messages(anonymousMessagesList);
              } else {
                controller.messages.addAll(anonymousMessagesList);
              }

              controller.pageState.loaded();
              controller.isLoadingMore(false);
              delay(1000, () => controller.connectionState(ChatConnectionType.done));
            } catch (e) {
              AppNavigator.snackbarRed(title: s.error, subtitle: e.toString());
            }
          }
          break;

        case 'new_message':
          if (controller.isAnonymousBot) return;
          final messageData = MessageDto.fromMap(message['message']);
          if (messageData.conversationId == controller.conversation.value.id) {
            await controller.addOrUpdateMessage(messageData);
            controller.scrollManager.scrollToBottom();
            markAsRead();
          }
          break;

        case 'message_edited':
          if (controller.isAnonymousBot) return;
          final messageData = MessageDto.fromMap(message['message']);
          if (messageData.conversationId == controller.conversation.value.id) {
            controller.updateMessage(messageData);
          }
          break;

        case 'message_deleted':
          if (controller.isAnonymousBot) return;
          final messageId = message['message_id'] as String?;
          if (messageId != null) {
            controller.chatMessagesCount--;
            controller.messages.removeWhere((final m) => m.id == messageId);
            if (controller.isMultiSelectMode.value) {
              controller.selectedMessageIds.removeWhere((final id) => id == messageId);
              if (controller.selectedMessageIds.isEmpty) {
                controller.exitMultiSelectMode();
              }
            }
          }
          break;

        case 'messages_read':
          if (controller.isAnonymousBot) return;
          final conversationId = message['conversation_id'];
          final messageIds = (message['message_ids'] as List?)?.cast<String>() ?? [];
          if (conversationId == controller.conversation.value.id) {
            for (var msg in controller.messages.cast<MessageDto>()) {
              if (messageIds.contains(msg.id) && msg.isOwner) {
                final index = controller.messages.indexOf(msg);
                controller.messages[index] = msg.copyWith(status: MessageStatus.read);
              }
            }
          }
          break;

        case 'user_typing':
          if (controller.isAnonymousBot) return;
          final conversationId = message['conversation_id'];
          if (conversationId == controller.conversation.value.id) {
            final userId = message['user_id']?.toString();
            final isTypingValue = message['is_typing'] as bool? ?? false;
            if (userId != null) {
              developer.log("is work true");
              controller.typingUsers[userId] = isTypingValue;
              controller.isTyping(controller.typingUsers.values.any((final v) => v));
              controller.isTyping.refresh();
            }
          }
          break;

        case 'message_pinned':
          if (controller.isAnonymousBot) return;
          final messageId = message['message_id'] as String?;
          if (messageId != null) {
            final index = controller.messages.indexWhere((final m) => m.id == messageId);
            if (index != -1) {
              controller.messages[index] = controller.messages.cast<MessageDto>()[index].copyWith(
                isPinned: true,
              );
            }
            // Refresh pinned messages list
            controller.getPinnedMessages();
          }
          break;
        case 'message_unpinned':
          if (controller.isAnonymousBot) return;
          final messageId = message['message_id'] as String?;
          if (messageId != null) {
            final index = controller.messages.indexWhere((final m) => m.id == messageId);
            if (index != -1) {
              controller.messages[index] = controller.messages.cast<MessageDto>()[index].copyWith(
                isPinned: false,
              );
            }
            // Refresh pinned messages list
            controller.getPinnedMessages();
          }
          break;

        case 'pinned_messages_list':
          if (controller.isAnonymousBot) return;
          if (message['conversation_id'] == controller.conversation.value.id) {
            final pinnedList = (message['messages'] as List?)?.map((final e) => MessageDto.fromMap(e)).toList() ?? [];
            controller.pinnedMessages.value = pinnedList;
            // Set to last pinned message (most recent)
            if (controller.pinnedMessages.isNotEmpty) {
              controller.currentPinnedIndex.value = controller.pinnedMessages.length - 1;
            } else {
              controller.currentPinnedIndex.value = 0;
            }
          }
          break;

        case 'reaction_added' || 'reaction_removed':
          if (controller.isAnonymousBot) return;
          if (message['conversation_id'] == controller.conversation.value.id) {
            final messageId = message['message_id'] as String?;

            if (messageId != null) {
              final index = controller.messages.indexWhere((final m) => m.id == messageId);
              if (index != -1) {
                final currentMessage = controller.messages.cast<MessageDto>()[index];

                // Update userReactions
                final List<UserReactionDto> updatedUserReactions = message['user_reactions'] != null
                    ? List<UserReactionDto>.from(
                        message['user_reactions'].map(
                          (final x) => UserReactionDto.fromMap(x),
                        ),
                      )
                    : [];
                // Update reactions
                final List<ReactionDto> updatedReactions = message['reaction_list'] != null
                    ? List<ReactionDto>.from(
                        message['reaction_list'].map(
                          (final x) => ReactionDto.fromMap(x),
                        ),
                      )
                    : [];

                controller.messages[index] = currentMessage.copyWith(
                  userReactions: updatedUserReactions,
                  reactions: updatedReactions,
                );
              }
            }
          }
          break;

        case 'you_were_removed':
          if (controller.isAnonymousBot) return;
          final conversationId = message['conversation_id'];
          if (controller.conversation.value.id == conversationId) {
            UNavigator.back();
          }
          break;

        case 'conversation_update':
          final updatedConversation = message["conversation_data"] == null
              ? null
              : ConversationDto.fromMap(message["conversation_data"]);
          if (updatedConversation == null || updatedConversation.id != controller.conversation.value.id) return;
          controller.conversation(updatedConversation);
          break;

        case 'member_added_successfully':
          if (controller.isAnonymousBot) return;
          AppNavigator.snackbarGreen(
            title: s.done,
            subtitle: s.memberAddedSuccessfully,
          );
          break;
        case 'feedback_sent':
          if (controller.isAnonymousBot && message["success"] == true) {
            AppNavigator.snackbarGreen(
              title: s.done,
              subtitle: s.messageSentSuccessfully,
            );
          }
          break;

        case 'member_removed_success':
          if (controller.isAnonymousBot) return;
          AppNavigator.snackbarGreen(
            title: s.done,
            subtitle: s.memberRemovedSuccessfully,
          );
          break;

        case 'error':
          final errorMessage = message['message'] as String? ?? s.error422;
          AppNavigator.snackbarRed(title: s.error, subtitle: errorMessage);
          break;
      }
    } catch (e) {
      developer.log('Error handling WebSocket message: $e');
    }
  }

  void markAsRead() {
    if (controller.isAnonymousBot) return;
    final unreadMessages = controller.messages
        .cast<MessageDto>()
        .where((final m) => !m.isOwner && m.status != MessageStatus.read)
        .map((final m) => m.id)
        .toList();
    if (unreadMessages.isNotEmpty) {
      controller.repository.markAsRead(controller.conversation.value.id, unreadMessages);
    }
  }

  void dispose() {
    _wsSubscription.cancel();
    _wsConnectionSubscription.cancel();
  }
}
