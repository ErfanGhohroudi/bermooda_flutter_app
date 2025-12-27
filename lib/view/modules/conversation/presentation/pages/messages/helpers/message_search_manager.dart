import 'package:u/utilities.dart';

import '../../../../../../../../core/core.dart';
import '../../../../../../../../core/navigator/navigator.dart';
import '../conversation_messages_controller.dart';

class MessageSearchManager {
  MessageSearchManager(this.controller);

  final ConversationMessagesController controller;

  void toggleSearchBoxVisible() {
    controller.searchCtrl.clear();
    controller.searchResults.clear();
    controller.currentSearchResultIndex.value = 0;
    controller.showSearchBox(!controller.showSearchBox.value);
  }

  Future<void> searchInMessages() async {
    if (controller.isAnonymousBot) return;
    controller.currentSearchResultIndex.value = 0;
    if (controller.searchCtrl.text.trim().isEmpty || controller.searchCtrl.text.trim().length < 2) {
      return controller.searchResults.clear();
    }
    try {
      final results = await controller.repository.searchMessages(
        query: controller.searchCtrl.text.trim(),
        conversationId: controller.conversation.value.id,
      );
      controller.searchResults(results);
      if (controller.searchResults.isNotEmpty) {
        final messageId = controller.searchResults[controller.currentSearchResultIndex.value].id;
        controller.scrollManager.scrollToMessage(messageId);
      }
    } catch (e) {
      AppNavigator.snackbarRed(title: s.error, subtitle: e.toString());
    }
  }

  void nextSearchResult() {
    if (controller.isAnonymousBot) return;
    if (controller.currentSearchResultIndex.value + 1 >= controller.searchResults.length) return;
    controller.currentSearchResultIndex(controller.currentSearchResultIndex.value + 1);
    if (controller.searchResults.isNotEmpty) {
      final messageId = controller.searchResults[controller.currentSearchResultIndex.value].id;
      controller.scrollManager.scrollToMessage(messageId);
    }
  }

  void previousSearchResult() {
    if (controller.isAnonymousBot) return;
    if (controller.currentSearchResultIndex.value == 0) return;
    controller.currentSearchResultIndex(controller.currentSearchResultIndex.value - 1);
    if (controller.searchResults.isNotEmpty) {
      final messageId = controller.searchResults[controller.currentSearchResultIndex.value].id;
      controller.scrollManager.scrollToMessage(messageId);
    }
  }
}

