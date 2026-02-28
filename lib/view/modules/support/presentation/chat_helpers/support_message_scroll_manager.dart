import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/loading/loading.dart';
import '../../../../../core/navigator/navigator.dart';
import '../controllers/support_chat_controller.dart';

class SupportMessageScrollManager {
  SupportMessageScrollManager(this.controller);

  final SupportChatController controller;

  void setupScrollListener() {
    controller.scrollController.addListener(handleScroll);
  }

  void scrollToBottom() {
    if (controller.messages.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (controller.scrollController.hasClients) {
          controller.scrollController.animateTo(
            controller.scrollController.position.minScrollExtent,
            duration: 300.milliseconds,
            curve: Curves.easeInOut,
          );
        }
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
        if (controller.scrollController.hasClients) {
          await controller.scrollController.scrollToIndex(
            index,
            preferPosition: AutoScrollPosition.middle,
          );
          controller.scrollController.highlight(index);
        }
      });
      AppLoading.dismissLoading();
    } else if (controller.hasMoreMessage == true) {
      // Load more pages to find the message if there is another page
      controller.searchingForMessageId = messageId; // Enable auto searching mode
      controller.repository.getMessages(controller.room.id, page: controller.currentPage + 1);
      // Note: controller.getMessages() logic needs to handle incrementing page or we pass page here.
      // In original controller `loadMoreMessages` increments page then calls `getMessages`.
      // Here we should probably call `loadMoreMessages` or `getMessages` directly.
      // Let's call `loadMoreMessages` if we want to increment page, but `loadMoreMessages` checks scroll position usually.
      // Better to call `getMessages` with next page.
      // We should probably update `currentPage` in controller before calling if we use `getMessages(page: currentPage)`.
      // Let's assume `loadMoreMessages` logic handles the increment.
      // Actually, looking at ConversationMessagesController, it calls `repository.getMessages`.
      // So here:
      controller.isLoadingMore(true);
      controller.currentPage++;
      controller.repository.getMessages(controller.room.id, page: controller.currentPage);
    } else if (controller.hasMoreMessage == false) {
      AppLoading.dismissLoading();
      controller.searchingForMessageId = null; // Disable auto searching mode
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.messageNotFound);
    }
  }

  void handleScroll() {
    if (!controller.scrollController.hasClients) return;

    // Show/Hide scroll to top button
    if (controller.scrollController.offset > 300 && !controller.showScrollToTop.value) {
      if (controller.scrollController.isAutoScrolling) {
        delay(1300, () => controller.showScrollToTop(true));
      } else {
        controller.showScrollToTop(true);
      }
    } else if (controller.scrollController.offset <= 300 && controller.showScrollToTop.value) {
      controller.showScrollToTop(false);
    }

    // Pagination
    if (controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent &&
        !controller.isLoadingPage.value &&
        !controller.isLoadingMore.value &&
        controller.hasMoreMessage) {
      loadMoreMessages();
    }
  }

  void loadMoreMessages() {
    if (!controller.hasMoreMessage || controller.isLoadingMore.value) return;
    controller.currentPage++;
    controller.isLoadingMore.value = true;
    controller.getMessages(page: controller.currentPage);
  }

  void dispose() {
    try {
      controller.scrollController.removeListener(handleScroll);
    } catch (e) {
      // Ignore if controller already disposed
    }
  }
}
