import 'package:collection/collection.dart';

import '../../../../data/dto/conversation_dtos.dart';
import '../conversation_messages_controller.dart';

class ReplyEditManager {
  ReplyEditManager(this.controller);

  final ConversationMessagesController controller;

  void setReplyMessage(final MessageDto? message) {
    if (controller.isAnonymousBot) return;
    clearPinedMessageToInputBox();
    controller.repliedMessage.value = message;
  }

  void setReplyMessageByMessageId(final String messageId) {
    if (controller.isAnonymousBot) return;
    clearPinedMessageToInputBox();
    final message = controller.messages.cast<MessageDto>().firstWhereOrNull(
      (final m) => m.id == messageId,
    );
    controller.repliedMessage.value = message;
  }

  void clearReplyMessage() {
    controller.messageController.clear();
    controller.repliedMessage.value = null;
    controller.isRecording.refresh(); // reset input Widget
  }

  void setEditingMessage(final MessageDto? message) {
    if (controller.isAnonymousBot) return;
    clearPinedMessageToInputBox();
    controller.editingMessage.value = message;
    if (message != null && message.text != null) {
      controller.messageController.text = message.text!;
      controller.isRecording.refresh(); // reset input Widget
    }
  }

  void clearEditingMessage() {
    controller.messageController.clear();
    controller.editingMessage.value = null;
    controller.isRecording.refresh(); // reset input Widget
  }

  void clearPinedMessageToInputBox() {
    clearReplyMessage();
    clearEditingMessage();
  }
}

