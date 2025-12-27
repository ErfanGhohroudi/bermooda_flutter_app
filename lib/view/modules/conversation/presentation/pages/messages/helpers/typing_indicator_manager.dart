import 'dart:async';
import '../conversation_messages_controller.dart';

class TypingIndicatorManager {
  TypingIndicatorManager(this.controller);

  final ConversationMessagesController controller;

  bool _previousTypingStatus = false;
  Timer? _typingTimer;

  void sendTypingStatus(final bool typingStatus) {
    if (controller.isAnonymousBot) return;
    if (_previousTypingStatus == typingStatus) return;
    _previousTypingStatus = typingStatus;
    controller.repository.sendTyping(
      controller.conversation.value.id,
      _previousTypingStatus,
    );

    _typingTimer?.cancel();
    if (_previousTypingStatus) {
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _previousTypingStatus = false;
        controller.repository.sendTyping(
          controller.conversation.value.id,
          _previousTypingStatus,
        );
      });
    }
  }

  void dispose() {
    _typingTimer?.cancel();
  }
}
