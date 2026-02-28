import 'dart:async';

import '../../domain/entities/support_message.dart';
import '../../data/models/support_message_dto.dart';
import '../../domain/enums/room_connection_state.dart';
import '../controllers/support_chat_controller.dart';

class SupportWebSocketHandler {
  SupportWebSocketHandler(this.controller);

  final SupportChatController controller;
  late StreamSubscription _wsSubscription;
  late StreamSubscription _wsConnectionSubscription;

  void dispose() {
    _wsSubscription.cancel();
    _wsConnectionSubscription.cancel();
  }

  void setupWebSocketListeners() {
    if (controller.repository.isConnected.value == false) {
      controller.connectionState(RoomConnectionState.connecting);
    }

    _wsConnectionSubscription = controller.repository.isConnected.listen((
      final connected,
    ) async {
      if (connected) {
        controller.connectionState(RoomConnectionState.update);
        controller.openRoom();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.getMessages();
      } else {
        controller.connectionState(RoomConnectionState.connecting);
      }
    });

    _wsSubscription = controller.repository.messages.listen((final data) {
      _handleMessage(data);
    });
  }

  void _handleMessage(final Map<String, dynamic> data) {
    final type = data['data_type'] ?? data['type'];
    if (type == null) return;

    switch (type) {
      case 'support_room_message':
        _handleNewMessage(data);
        break;
      case 'room messages':
        _handleRoomMessages(data);
        break;
      case 'user_typing':
        _handleTyping(data);
        break;
      case 'typing': // Sometimes it might come as 'typing' based on other chats
        _handleTyping(data);
        break;
    }
  }

  void _handleNewMessage(final Map<String, dynamic> data) async {
    final messageData = data['data'] ?? data;
    if (messageData['room_id'] != controller.room.id) return;

    final dto = SupportMessageDto.fromMap(messageData);
    final message = dto.toEntity();
    await controller.addOrUpdateMessage(message);
    controller.scrollManager.scrollToBottom();
    if (!message.isOperator) {
      controller.markAsRead();
    }
  }

  void _handleRoomMessages(final Map<String, dynamic> data) {
    controller.isLoadingPage.value = false;
    controller.isLoadingMore.value = false;

    final paginationData = data['data'];
    if (paginationData == null) return;

    final nextPage = paginationData['next'];
    controller.chatMessagesCount = (paginationData["count"] as int?) ?? 0;
    controller.hasMoreMessage = nextPage != null;

    final List rawList = paginationData['data'] ?? [];
    final List<SupportMessage> newMessages = [];

    for (final item in rawList) {
      if (item != null) {
        final dto = SupportMessageDto.fromMap(item);
        newMessages.add(dto.toEntity());
      }
    }

    final page = controller.currentPage;
    controller.currentPage = nextPage ?? 0;

    if (page == 1) {
      if (controller.messages.isNotEmpty) {
        final sendingMessages = controller.messages
            .where(
              (final m) => m.clientId != null && (m.isSending || m.isFailed),
            )
            .toList();
        controller.messages([...sendingMessages, ...newMessages]);
      } else {
        controller.messages(newMessages);
      }
    } else {
      controller.messages.addAll(newMessages);
    }

    if (controller.isLoadingPage.value) {
      controller.isLoadingPage(false);
    }

    if (controller.isLoadingMore.value) {
      controller.isLoadingMore(false);
    }

    Future.delayed(
      const Duration(milliseconds: 1000),
      () => controller.connectionState(RoomConnectionState.done),
    );

    // Handle searchingForMessageId
    if (controller.searchingForMessageId != null) {
      controller.scrollManager.scrollToMessage(controller.searchingForMessageId!);
    }
    controller.markAsRead();
  }

  void _handleTyping(final Map<String, dynamic> data) {
    final messageData = data['data'] ?? data;
    if ((messageData['room_id'] as int?) != controller.room.id) return;

    final isTyping = messageData['is_typing'] as bool? ?? false;
    final type = messageData['type'] as String?;

    if (type == 'customer') {
      controller.isCustomerTyping.value = isTyping;
    }
  }
}
