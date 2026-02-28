import 'dart:async';

import '../controllers/support_chat_controller.dart';

class SupportTypingManager {
  SupportTypingManager(this.controller);

  final SupportChatController controller;
  Timer? _typingTimer;

  void onTextChanged() {
    final text = controller.messageController.text;
    if (text.isNotEmpty && !controller.isTyping.value) {
      controller.isTyping.value = true;
      sendTyping(true);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 500), () {
      if (controller.isTyping.value) {
        controller.isTyping.value = false;
        sendTyping(false);
      }
    });
  }

  void sendTyping(final bool typing) {
    if (typing) {
      controller.repository.sendTyping(controller.room.id);
    } else {
      controller.repository.stopTyping(controller.room.id);
    }
  }

  void dispose() {
    _typingTimer?.cancel();
  }
}
