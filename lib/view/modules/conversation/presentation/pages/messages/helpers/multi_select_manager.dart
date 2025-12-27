import 'package:u/utilities.dart';

import '../../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../../core/core.dart';
import '../../../../../../../../core/navigator/navigator.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../../forward/forward_conversation_selection_page.dart';
import '../conversation_messages_controller.dart';

class MultiSelectManager {
  MultiSelectManager(this.controller);

  final ConversationMessagesController controller;

  void enterMultiSelectMode() {
    if (controller.isAnonymousBot) return;
    controller.replyEditManager.clearPinedMessageToInputBox();
    controller.isMultiSelectMode.value = true;
    controller.selectedMessageIds.clear();
  }

  void exitMultiSelectMode() {
    controller.isMultiSelectMode.value = false;
    controller.selectedMessageIds.clear();
  }

  void toggleMessageSelection(final String messageId) {
    if (controller.isAnonymousBot) return;
    if (controller.selectedMessageIds.contains(messageId)) {
      controller.selectedMessageIds.remove(messageId);
    } else {
      controller.selectedMessageIds.add(messageId);
    }
    if (controller.selectedMessageIds.isEmpty) {
      exitMultiSelectMode();
    }
  }

  void selectAllMessages() {
    if (controller.isAnonymousBot) return;
    for (final message in controller.messages) {
      controller.selectedMessageIds.add(message.id);
    }
  }

  void deselectAllMessages() {
    controller.selectedMessageIds.clear();
    exitMultiSelectMode();
  }

  void copySelectedMessagesTexts() {
    if (controller.isAnonymousBot) return;
    final textMessages = controller.messages
        .cast<MessageDto>()
        .where(
          (final m) =>
              controller.selectedMessageIds.contains(m.id) &&
              m.type == MessageType.text &&
              m.text != null &&
              m.text!.trim().isNotEmpty,
        )
        .map((final m) => m.text!)
        .toList();

    if (textMessages.isEmpty) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.noTextMessagesSelected,
      );
      return;
    }

    final combinedText = textMessages.join('\n');
    UClipboard.set(combinedText);
    exitMultiSelectMode();
  }

  void forwardSelectedMessages() {
    if (controller.isAnonymousBot) return;
    if (controller.selectedMessageIds.isEmpty) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.noMessagesSelected);
      return;
    }

    final messageIds = controller.selectedMessageIds.toList();
    UNavigator.push(ForwardConversationSelectionPage(messageIds: messageIds));
    exitMultiSelectMode();
  }

  void forwardSelectedMessage(final MessageDto message) {
    if (controller.isAnonymousBot) return;
    UNavigator.push(ForwardConversationSelectionPage(messageIds: [message.id]));
    exitMultiSelectMode();
  }

  void deleteSelectedMessages() {
    if (controller.isAnonymousBot) return;
    if (controller.selectedMessageIds.isEmpty) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.noMessagesSelected);
      return;
    }

    if (controller.isGroup && controller.haveAdminAccess) {
    } else {
      final isThereOtherMemberMessages = controller.messages
          .cast<MessageDto>()
          .where((final m) => controller.selectedMessageIds.contains(m.id))
          .any((final m) => m.isOwner == false);

      if (isThereOtherMemberMessages) {
        AppNavigator.snackbarRed(
          title: s.error,
          subtitle: s.notAllowedDeleteOtherUsersMessages,
        );
        return;
      }
    }

    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back();
        for (String messageId in controller.selectedMessageIds) {
          controller.deleteMessage(messageId);
        }
        exitMultiSelectMode();
      },
    );
  }
}

