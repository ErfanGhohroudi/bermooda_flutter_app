import '../../../../data/dto/conversation_dtos.dart';
import '../conversation_messages_controller.dart';

class PinnedMessagesManager {
  PinnedMessagesManager(this.controller);

  final ConversationMessagesController controller;

  void getPinnedMessages() {
    if (controller.isAnonymousBot) return;
    controller.repository.getPinnedMessages(controller.conversation.value.id);
  }

  void pinMessage(final MessageDto message) {
    if (controller.isAnonymousBot) return;
    controller.repository.pinMessage(controller.conversation.value.id, message.id);
  }

  void unpinMessage(final MessageDto message) {
    if (controller.isAnonymousBot) return;
    controller.repository.unpinMessage(controller.conversation.value.id, message.id);
  }

  void showNextPinnedMessage() {
    if (controller.isAnonymousBot) return;
    if (controller.pinnedMessages.isEmpty) return;
    if (controller.currentPinnedIndex.value < controller.pinnedMessages.length - 1) {
      controller.currentPinnedIndex.value++;
    }
  }

  void showPreviousPinnedMessage() {
    if (controller.isAnonymousBot) return;
    if (controller.pinnedMessages.isEmpty) return;
    if (controller.currentPinnedIndex.value > 0) {
      controller.currentPinnedIndex.value--;
    }
  }

  MessageDto? get currentPinnedMessage {
    if (controller.pinnedMessages.isEmpty ||
        controller.currentPinnedIndex.value < 0 ||
        controller.currentPinnedIndex.value >= controller.pinnedMessages.length) {
      return null;
    }
    return controller.pinnedMessages[controller.currentPinnedIndex.value];
  }
}

