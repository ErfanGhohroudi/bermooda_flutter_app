import 'package:u/utilities.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../../../../core/core.dart';
import '../../../../../../../../core/loading/loading.dart';
import '../../../../../../../../core/navigator/navigator.dart';
import '../conversation_messages_controller.dart';

class MessageScrollManager {
  MessageScrollManager(this.controller);

  final ConversationMessagesController controller;

  void setupScrollListener() {
    controller.scrollController.addListener(handleScroll);
  }

  void scrollToBottom() {
    if (controller.messages.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        controller.scrollController.animateTo(
          controller.scrollController.position.minScrollExtent,
          duration: 300.milliseconds,
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> scrollToMessage(final String messageId) async {
    AppLoading.showLoading();
    final index = controller.messages.indexWhere((final m) => m.id == messageId);
    if (index != -1) {
      AppLoading.dismissLoading();
      controller.searchingForMessageId = null; // Disable auto searching mode

      await Future.delayed(const Duration(milliseconds: 100), () async {
        await controller.scrollController.scrollToIndex(
          index,
          preferPosition: AutoScrollPosition.middle,
        );
        controller.scrollController.highlight(index);
      });
      AppLoading.dismissLoading();
    } else if (controller.hasMoreMessage == true) {
      // Load more pages to find the message if there is another page
      controller.searchingForMessageId = messageId; // Enable auto searching mode
      controller.repository.getMessages(controller.conversation.value.id, page: controller.currentPage);
    } else if (controller.hasMoreMessage == false) {
      AppLoading.dismissLoading();
      controller.searchingForMessageId = null; // Disable auto searching mode
      AppNavigator.snackbarRed(title: s.error, subtitle: s.messageNotFound);
    }
  }

  void handleScroll() {
    if (controller.scrollController.position.atEdge) {
      bool isBottom = controller.scrollController.position.pixels == controller.scrollController.position.maxScrollExtent;
      if (isBottom && !controller.isLoadingMore.value && controller.hasMoreMessage) {
        loadMoreMessages();
      }
    }

    /// scroll to top button listener
    if (controller.scrollController.offset > 300 && !controller.showScrollToTop.value) {
      if (controller.scrollController.isAutoScrolling) {
        delay(1300, () => controller.showScrollToTop(true));
      } else {
        controller.showScrollToTop(true);
      }
    } else if (controller.scrollController.offset <= 300 && controller.showScrollToTop.value) {
      controller.showScrollToTop(false);
    }
  }

  void loadMoreMessages() {
    if (controller.isLoadingMore.value) return;
    controller.isLoadingMore(true);
    if (controller.isAnonymousBot) {
      controller.repository.getAnonymousFeedbacks(controller.currentPage);
    } else {
      controller.repository.getMessages(controller.conversation.value.id, page: controller.currentPage);
    }
  }

  void dispose() {
    controller.scrollController.removeListener(handleScroll);
  }
}
